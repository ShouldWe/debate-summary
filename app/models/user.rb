#
# Debate Summary - Croudsource arguments and debates
# Copyright (C) 2015 Policy Wiki Educational Foundation LTD <hello@shouldwe.org>
#
# This file is part of Debate Summary.
#
# Debate Summary is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Debate Summary is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Debate Summary.  If not, see <http://www.gnu.org/licenses/>.
#
class User < ActiveRecord::Base

  liquid_methods :name

  attr_accessor :validate_email

  serialize :notification_preferences

  mount_uploader :avatar, AvatarUploader

  extend FriendlyId
  friendly_id :name, use: :slugged
  
  include Pw::ActsAsRater

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :bio, :bio_headline, :monitors, :endorsed,
                  :avatar, :avatar_cache, :remove_avatar, :endorsed_by, :remote_avatar_url, :admin, :notification_preferences

  has_many :issues
  has_many :statements
  has_many :activities
  
  has_many :issue_roles

  has_many :proposed_edits
  has_many :closed_by, class_name: "ProposedEdit"
  has_many :comments
  
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", order: "created_at DESC"
  has_many :received_messages, class_name: "Message", foreign_key: "recipient_id", order: "created_at DESC"
  has_many :read_messages, class_name: "Message", foreign_key: "recipient_id", conditions: {read: true}, order: "created_at DESC"
  has_many :unread_messages, class_name: "Message", foreign_key: "recipient_id", conditions: {read: false}, order: "created_at DESC"
  
  has_many :visits # for tracking issue views
  has_many :suggested_issue_titles, class_name: "IssueTitle", conditions: {canonical: false}

  has_many :notification_subscriptions, dependent: :destroy

  validates :name, presence: true

  [:twitter_uid,:facebook_uid,:linkedin_uid].each do |uniquey|
    validates uniquey, uniqueness: true, allow_nil: true  
  end

  # validates_presence_of   :avatar
  validates_integrity_of  :avatar
  validates_processing_of :avatar
  
  before_save :send_welcome_email
  before_save :setup_notification_prefs

  scope :online, lambda{ where("updated_at > ?", 15.minutes.ago) }
  scope :offline, lambda{ where("updated_at < ?", 15.minutes.ago) }
  
  geocoded_by :current_sign_in_ip
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.city = geo.city
      obj.country = geo.country
    end
  end
  
  set_callback(:save, :before) do |doc|
    doc.geocode if :current_sign_in_ip
    doc.reverse_geocode if :current_sign_in_ip
  end
  

  def self.find_for_facebook_oauth(access_token, signed_in_resource = nil)
    data = access_token.extra.raw_info
  end

  def is_admin?
    admin
  end

  def is_endorsed?
    endorsed?
  end

  # Aparently there will be more than one level of "monitoring", so instead of having is_monitor field we have
  # monitors column!?! Needs to be replaced with something more appropriate, like use rolify gem.
  # TODO:ask George what why he needs it here and either: change User::monitors to is_monitor:boolean or use rolify gem
  def is_monitor?
    ! monitors.blank? && monitors == 'normal'
  end

  def visit_resource(resource)
    visits.create(visitable_type: resource.class.to_s, visitable_id: resource.id)
  end
  
  def voted_for_any_issue_titles?(issue)
    issue.issue_title_votes.where(user_id: id).exists?
  end
  
  def vote_for_issue_title(issue_title, ip_address=nil)
    IssueTitleVote.create(
      issue_title_id: issue_title.id,
      user_id: id,
      ip_address: ip_address
    )
  end
  
  def visited?(issue)
    issue.visited_by?(self.id).exists?
  end
  
  def visit_detail(issue)
    Visit.where(visitable_id: issue.id, visitable_type: issue.class.to_s, user_id: self.id).first
  end
  
  def last_visits(num)
    visits.order("updated_at DESC").limit(num).includes(:visitable)
  end

  def visit(issue, ip_address=nil)
    visit = Visit.where(visitable_id: issue.id, visitable_type: issue.class.to_s).find_or_initialize_by_user_id(self.id)
    if visit.new_record?
      visit.ip_address = ip_address[:ip_address]
      visit.save
    else
      visit.ip_address = ip_address[:ip_address]
      visit.total_visits += 1
      visit.save
    end
  end

  def self.admin_emails
    where(admin: true).pluck(:email)
  end

  def voted_for?(voteable)
    ! Vote.find_by_voteable_id_and_voteable_type_and_voter_id_and_voter_type(voteable.id, voteable.class, id, 'User').blank?
  end

  def banned_globally?
    ! activities_banning_globally.empty?
  end

  def activities_banning_globally
    Activity.joins(:rule_break_reports).joins('rule_break_reports' => 'penalty').where('activities.user_id = ? AND penalties.global = ? AND rule_break_reports.penalty_end > ?',id, true, DateTime.now)
  end

  def ban_will_be_lifted_on(issue)
    RuleBreakReport.find_by_sql("
      SELECT rbr.*
        FROM rule_break_reports rbr,
             activities a,
             issues i
       WHERE rbr.reportable_id = a.id AND a.issue_id = i.id
         AND i.id = #{issue.id} AND a.user_id = #{id} AND rbr.penalty_end  > now()
       ORDER BY rbr.penalty_end DESC
    ").first.try(:penalty_end)
  end

  def facebook_oauth_message omni_response
    if message = oauth_taken?( :facebook_uid, omni_response.uid, "Facebook")
      return message
    else
      self.facebook_uid = omni_response.uid
      self.facebook_token = omni_response.credentials.token
      self.facebook_token_expires_at = omni_response.credentials.expires_at
      self.facebook_info = omni_response 
      self.name = omni_response.info.name
      self.email = omni_response.info.email
      begin
        avatar_url = Net::HTTP.get_response(URI(omni_response.info.image))['location']
        self.remote_avatar_url = avatar_url
      end
      self.avatar = "picture.jpeg" if remote_avatar_url
      self.facebook_friend_count = FbGraph::User.fetch(omni_response.uid).friends.size rescue nil
      clear_twitter
      clear_linkedin
      false
    end
  end

  def clear_facebook
    self.facebook_uid =
      self.facebook_token =
      self.facebook_token_expires_at = 
      self.facebook_friend_count = 
      self.facebook_info = nil
  end

  def twitter_oauth_message(omni_response)
    if message = oauth_taken?( :twitter_uid, omni_response.uid, "Twitter")
      return message
    else
      self.twitter_uid = omni_response.uid
      self.twitter_token = omni_response.credentials.token
      self.twitter_token_secret = omni_response.credentials.secret
      self.twitter_info = omni_response
      self.name = omni_response.info.name
      begin
        self.remote_avatar_url = omni_response.info.image.gsub('_normal','') rescue nil
      rescue
      end
      self.avatar = URI.parse(remote_avatar_url).path if remote_avatar_url
      self.twitter_follower_count = omni_response.extra.raw_info.followers_count
      clear_facebook
      clear_linkedin
      false
    end
  end

  def clear_twitter
    self.twitter_uid = 
      self.twitter_token = 
      self.twitter_token_secret = 
      self.twitter_follower_count = 
      self.twitter_info = nil
  end

  def linkedin_oauth_message omni_response
    if message = oauth_taken?( :linkedin_uid, omni_response.uid, "Linked In")
      return message
    else
      self.linkedin_uid = omni_response.uid
      self.linkedin_token = omni_response.credentials.token
      self.linkedin_connections_count = omni_response[:extra][:raw_info][:numConnections]
      self.linkedin_info = omni_response
      self.name = omni_response.info.name
      self.email = omni_response.info.email
      begin
        self.remote_avatar_url = omni_response.info.image rescue nil
      rescue
      end
      self.avatar = "picture.jpeg" if remote_avatar_url
      clear_facebook
      clear_twitter
      false
    end
  end

  def clear_linkedin
    self.linkedin_uid = 
      self.linkedin_token = 
      self.linkedin_connections_count = 
      self.linkedin_info = nil 
  end

  def password_required?
    super && twitter_uid.blank? && facebook_uid.blank? && linkedin_uid.blank?
  end

  def email_required?
    super && !! validate_email
  end

  def email_changed?
    false # turn of uniqueness check
  end

  def trimmed_name
    (name.length > 20)? "#{name[0..16]}..." : name rescue ""
  end

  # We've got serialsed notification preferences
  def setup_notification_prefs
    if self.notification_preferences.blank?
      self.notification_preferences = UserNotificationPrefs.new
    elsif self.notification_preferences.is_a?(String)
      notif_prefs
    end
  end

  def update_notification_preferences hash
    return unless hash.present?
    setup_notification_prefs
    notification_preferences.update_from_hash hash
  end

  # Helper method to coerce the deserialisation
  def notif_prefs
    self.notification_preferences = YAML.load(self.notification_preferences) unless notification_preferences.is_a?(UserNotificationPrefs)
  end

  def last_seen_at
    updated_at
  end

  private

  def oauth_taken? column, uid, name
    already_used = false
    if other = self.class.where(column => uid).first
      already_used = self.id != other.id
    end
    "There is another user with this #{name} account" if already_used
  end

  def send_welcome_email
    if self.email_changed? && self.email_was.blank? && self.email.present?
      UserMailer.welcome_email(self).deliver
    end
  end
end