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
# coding: utf-8
class Issue < ActiveRecord::Base
  serialize :body_shas
  include Pw::ActsAsRateable
  include ActionView::Helpers::TextHelper
  alias_attribute :body, :context
  alias_attribute :body_shas, :context_shas
  include HTMLPunctuationCleanup

  class IdNotGeneratedError < StandardError; end;


  include PgSearch
  multisearchable against: [:fulltext]

  include OpenGraph::ActsAsOpenGraph

  attr_accessor :editor, :already_voted

  belongs_to :user

  has_many :details, class_name: "Detail", as: :detailable

  has_many :detail_contexts,      class_name: "Detail", as: :detailable, conditions: {detail_type:'context'}
  #  DAN - removed due to problem with template. Needs fixing before LAUNCH.
  # validates :detail_contexts, presence: true

  has_many :detail_fors,          class_name: "Detail", as: :detailable, conditions: {detail_type:'for'}
  has_many :detail_againsts,      class_name: "Detail", as: :detailable, conditions: {detail_type:'against'}
  has_many :detail_alternatives,  class_name: "Detail", as: :detailable, conditions: {detail_type:'alternative'}
  has_many :detail_data,          class_name: "Detail", as: :detailable, conditions: {detail_type:'datum'}
  has_many :detail_relevants,     class_name: "Detail", as: :detailable, conditions: {detail_type:'relevant'}

  has_and_belongs_to_many(
    :issues,
    join_table: :internal_relations,
    foreign_key: :issue_id,
    association_foreign_key: :related_issue_id,
    uniq: true
  )

  has_many :tag_issue_clicks

  has_many :activities

  has_many :issue_comments, class_name: "Comment"
  has_many :comments, as: :commentable

  has_many :proposed_edits
  has_many :proposed_edits, as: :editable

  has_many :issue_roles

  has_many :experts, :through => :issue_roles,
          :source => :user,
          :conditions => "expert = true"

  has_many :monitors, :through => :issue_roles,
          :source => :user,
          :conditions => "monitor = true"

  has_many :issue_votes

  has_many :notification_subscriptions, dependent: :destroy

  has_many :suggested_titles, class_name: "IssueTitle", conditions: {canonical: false}
  has_one :canonical_title, class_name: "IssueTitle", conditions: {canonical: true}
  has_many :issue_title_votes, through: :suggested_titles

  has_many :visits, as: :visitable, dependent: :destroy
  has_many :link_health, as: :link_checkable, dependent: :destroy

  def visitors
    User.find_all_by_id(visits.pluck(user_id))
  end
  def visited_by?(user_id); visits.where(:user_id => user_id); end
  def anon_visitors; visits.where("user_id IS NULL").count; end

  attr_accessible :title, :tag_list, :image, :image_cache, :context, :tmp_slug, :overwrite_slug

  validates :title,
    presence: true,
    length: {
      minimum: 7
    },
    format: {
      with: /\AShould\s.+\?\Z/
    }
  validates :context,
    presence: true,
    length: {
      maximum: 200,
      too_long: 'is too long (maximum is %{count} words)',
      tokenizer: ->(str) { Nokogiri::HTML::fragment(str).text.strip.scan(/\S+/) }
    },
    hyper_link_content: true

  before_save :set_version_number, :titleize_title, :set_hyperlink_attributes

  before_validation :make_should_first_word

  after_create :add_title_to_issue_titles

  scope :with_broken_links, -> {
    where('id in (?)', LinkHealth.broken.all.collect{ |l| l.issue.id })
  }

  scope :all_invalid, -> {
    issues = []
    issues << all.select(&:invalid?)
    issues << self.with_broken_links
    issues.flatten
  }

  def add_title_to_issue_titles
    suggested_titles.create(title: self.title, user_id: self.user.id)
  end

  def description
    Nokogiri::HTML::fragment(context).text.strip
  end

  extend FriendlyId
  friendly_id :tmp_slug, use: [:slugged, :history]
  attr_accessor :generate_friendly_id, :overwrite_slug
  alias :generate_friendly_id? :generate_friendly_id

  def should_generate_new_friendly_id?
    if generate_friendly_id?
      true
    else
      false
    end
  end

  def tmp_slug
    @tmp_slug || title
  end

  def tmp_slug=(val)
    @tmp_slug=val
  end

  acts_as_taggable
  has_paper_trail

  mount_uploader :image, ImageUploader
  def pico_url
    image.pico.url
  end

  def last_edit_at
    self.updated_at
  end

  def last_edit_by
    User.where(id: self.versions.last.whodunnit.to_i).first if self.versions.last.present?
  end

  def broken_links
    link_health.broken
  end

  def contributors
    @validids ||= Array.new
    contributor_ids.each do |user|
      @userfound = User.where(:id => user)
      if @userfound.present?
        @validids.push(user.to_i)
      end
    end
    @contributors ||= User.find @validids
  end

  def contributor_ids
    @contributor_ids ||= self.activities.select("DISTINCT user_id").map(&:user_id)
  end

  def edits_for_adjudication
    self.proposed_edits.unscoped.to_a
  end

  # def build_statements(params = {})
  #   self.update_attributes(params) if params.any?

  #   self.statements.build unless self.statements

  #   detail_for = self.detail_fors.build unless self.detail_fors.any?
  #   detail_against = self.detail_againsts.build unless self.detail_againsts.any?
  #   detail_alternative = self.detail_alternatives.build unless self.detail_alternatives.any?
  #   detail_datum = self.detail_data.build unless self.detail_data.any?
  #   self.issue_links.build unless self.issue_links.any?
  #   self
  # end

  def pending_proposed_edits_count
    ProposedEdit.where(issue_id: self.id, aasm_state: 'new').count
  end

  def tidy_statements
    self.statements.each do |statement|
      if statement.name.blank? && statement.body.blank? && statement.source.blank?
        statement.delete
      end
    end
    self.details.each do |detail|
      detail.statements.each do |statement|
        if statement.name.blank? && statement.body.blank? && statement.source.blank?
          statement.delete
        end
      end
      if detail.title.blank?
        detail.destroy
      end
    end
  end

  def set_version_number
    self[:version] += 1
  end

  def setup_with_user(user)
    @already_voted = user.voted_for_any_issue_titles?(self)
  end

  def already_voted
    !!@already_voted
  end

  def not_voted
    !!!@already_voted
  end


  # Aggregation method for search
  def fulltext
    details = Detail.where(detailable_id: self.id, detailable_type: "Issue").select([:title, :body])
    output = self.title + " "
    details.each{|detail| output << "#{detail.title unless detail.title.blank?} #{strip_tags detail.body}"}
    return output
  end

  # Override of Serializable Hash for search results
  def serializable_hash(options={})
    options[:methods] ||= []
    super(options.merge({methods: [:pico_url, :link] + options[:methods]}))
  end

  # Link to issue for sake of serializable
  include Rails.application.routes.url_helpers
  def link
    issue_path(self)
  end

  # Convenience methods for visits/visitors
  def total_impressions; visits.sum(:total_visits); end
  def total_unique_visitors; visits.count; end
  def last_visited_at; visits.order("updated_at DESC").last.try(:updated_at); end

  # Add pico image link to JSON
  def as_json(options={})
    options[:methods] ||= []
    super(options.merge({methods: [:pico_url] + options[:methods]}))
  end

  def user_allowed_to_edit?(user)
    activities_blocking_user(user).empty?
  end

  def activities_blocking_user(user)
    activities_blocking_user_locally(user) + user.activities_banning_globally
  end

  def activities_blocking_user_locally(user)
    activities.joins(:rule_break_reports).where('activities.user_id = ? AND rule_break_reports.penalty_end > ?', user.id, DateTime.now)
  end

  def self.user_allowed_to_create?(user)
    ! user.banned_globally?
  end

  def user_ban_will_be_lifted_on(user)
    user.ban_will_be_lifted_on(self)
  end

  def self.trending sample_size=500, top_n=10
    # This sql takes last sample_size issue visits, groups and orders by count (proxy for popularity), and spits out 1st top_n
    # we're using updated_at because visits get reused and their counts updated
    trending_issues_sql = <<-SQL_END
      (select visitable_id as issue_id, count(*) from
        (select * from visits
        where visitable_type = 'Issue'
        order by updated_at desc limit #{sample_size}) as visited_issues
        group by visitable_id order by count(*) desc ) limit #{top_n}
    SQL_END
    top_n_issues = ActiveRecord::Base.connection.execute(trending_issues_sql).map { |top_n| top_n["issue_id"]}
    # can't use SQL in () because we want to preserve ordering
    [].tap do |trending_topics|
      top_n_issues.each { |issue_id|  trending_topics << Issue.find(issue_id) }
    end
  end
  def self.trending_tags sample_size=500, top_n=10
    top_tags_sql = <<-SQL_END
      select tag_id, count(*) from
        (
        select taggings.tag_id tag_id
          from visits
          , issues
          , taggings
        where visitable_type = 'Issue'
        and visits.visitable_id = issues.id
        and  taggings.taggable_type = 'Issue'
        and taggings.taggable_id = issues.id
        order by visits.updated_at desc limit #{sample_size}
        ) as tags_count
        group by tag_id order by count(*) desc limit #{top_n}
      SQL_END
    top_n_tags = ActiveRecord::Base.connection.execute(top_tags_sql).map { |top_n| top_n["tag_id"]}
    # can't use SQL in () because we want to preserve ordering
    [].tap do |tags|
      top_n_tags.each { |tag_id|  tags << Tag.find(tag_id) }
    end
  end
  def self.by_tag_string tag_string, sample_size=500, top_n=10
    # note that requirement said that if we had & it means either
    tags = tag_string.split("&").reduce([]) { |nxt,prev| nxt + Tag.stripped_name(prev).all}
    if tags.empty?
      []
    else
      # Using exists instead of join so we don't double count
      trending_issues_by_tag_sql = <<-SQL_END
        (select id as issue_id, count(*) from
          (select issues.id
            from visits, issues
          where visitable_type = 'Issue'
          and visits.visitable_id = issues.id
          and exists ( select 1 from taggings
            where  taggings.taggable_type = 'Issue'
            and taggings.taggable_id = issues.id
            and taggings.tag_id in (#{tags.collect(&:id).join(",")}
            )
          )
          order by visits.updated_at desc limit #{sample_size}) as visited_issues
          group by issue_id order by count(*) desc ) limit #{top_n}
      SQL_END
      top_n_tagged_issues = ActiveRecord::Base.connection.execute(trending_issues_by_tag_sql).map { |top_n| top_n["issue_id"]}
      [].tap do |trending_topics|
        top_n_tagged_issues.each do |issue_id|
          issue = Issue.find(issue_id)
          trending_topics << issue unless trending_topics.include?(issue)
        end
      end
    end
  end

  def self.count_by_tag_string(tag_string)
    issues = tag_string.split('&').collect do |tag|
      self.tagged_with(tag).count
    end.inject(&:+)
  end

  def views_in_last(duration = :week)
    visits_table = Visit.arel_table
    date = Time.now - 1.send(duration)
    visits.where(visits_table[:created_at].gt(date)).count
  end

  def rating_score
    Rating.where(rateable_id: id).sum(:score)
  end

  def content_by_sha sha
    anchors = Nokogiri::HTML::fragment(context).css('a')
    anchors.each do |anchor|
      if anchor['name'] == sha
        return anchor.inner_text
      end
    end

    return nil
  end

  def detail_type
    "Issue"
  end

  def broken_shas
    shas = []
    shas << link_health.broken.select(:sha).collect(&:sha)
    shas << details.map {|d| d.link_health.broken.collect(&:sha)}
    shas.flatten
  end

  def process_links
    HyperlinkExtractor.perform_async(self.id)
  end

  def filename
    self.title.downcase.strip.underscore.gsub(' ', '-')
  end

  private
  def make_should_first_word
    return unless title && title.size > 0
    title_words = title.split(/[[:space:]]/)
    if title_words && title_words.first.downcase != 'should'
      title = "Should #{title}".humanize
    end
    true
  end

  def titleize_title
    self.title = title.to_s.gsub(/\b(?<!['’`])[a-z]/) { $&.capitalize }
  end

  # slight different version to in detail
  # this should be a concern or application helper method
  def set_hyperlink_attributes
    shas = []
    doc = Nokogiri::HTML.fragment(self.context)
    doc.css('a').each do |node|
      if node.inner_text.strip.blank?
        node.remove
      else
        node['name']  = SecureRandom.hex(3) unless node['name']
        node['title'] = node['href'] if node['href']
        shas << node['name']
      end
    end
    self.context_shas = shas.uniq
    self.context = doc.to_html
  end
end