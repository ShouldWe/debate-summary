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
require 'openssl'
require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'

class LinkHealth < ActiveRecord::Base
  serialize :sha
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ERB::Util

  alias_attribute :shas, :sha
  alias_attribute :body_shas, :sha

  has_many :visits, as: :visitable, dependent: :destroy
  belongs_to :link_checkable, polymorphic: true

  scope :broken_or_unchecked,  -> {
    where(status: [(400..599),nil])
  }

  scope :broken,  -> {
    where(status: (400..599))
  }

  scope :to_be_checked, -> {
    where("last_checked_at is null or last_checked_at < ?", 60.minute.ago)
  }

  scope :duplicate_links,  -> {
    where('count > 1').where('status not in (?)', (400..500))
  }

  scope :pending, -> {
    where(status: nil)
  }

  DISPLAYABLE = [
    'application/pdf',
    'text/html'
  ]

  self.table_name = "link_health"

  attr_accessible :link_checkable_id, :link_checkable_type, :url, :status, :mime_type, :last_verified, :sha, :issue_id

  class << self
    def extract_hyperlinks(resource)
      anchors = Nokogiri::HTML::fragment(resource.body).css('a')
      anchors.each do |anchor|
        href = anchor['href']
        sha  = anchor['name']
        if sha
          health = resource.link_health.where(url: href).first_or_initialize
          health.sha = [] if health.sha.nil?
          health.sha << sha if health.sha.exclude?(sha)
          health.save!
          LinkChecker.perform_async(health.id)
        end
      end
    end

    def destroy_redundant_records(resource)
      ids = resource.link_health.select([:sha, :id]).reject do |lh|
        lh.sha.any? {|s| resource.body_shas.include?(s)}
      end.collect(&:id)
      LinkHealth.where(id: ids).destroy_all
    end
  end

  def issue
    if link_checkable_type == 'Issue'
      link_checkable
    else
      link_checkable.detailable
    end
  end

  def detect_meta_redirect content
    doc = Nokogiri::HTML(content)

    meta_refresh = doc.at('meta[http-equiv="refresh"]')
    if meta_refresh
      return meta_refresh['content'][/URL=(.+)/, 1].gsub(/['"]/, '')
    end

    nil
  rescue
    nil
  end

  def get_url_response
    # allow 30x redirects
    @response ||= open(
      url,
      allow_redirections: :all,
      read_timeout: 60,
      ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
    )
  end

  def check_link
    self.mime_type = nil
    begin
      response = get_url_response

      self.status = response.status.first
      self.mime_type = response.content_type

      meta_url = detect_meta_redirect(response.read)
      self.url = meta_url if meta_url && meta_url != self.url

      self.destination_url = response.base_uri.to_s


      self.x_frame_options = response.meta.fetch("x-frame-options", 'allow')
    rescue TypeError, NoMethodError, SocketError, Errno::ENOENT, URI::InvalidURIError => e
      self.error_reason = e.message.to_s + ' : ' + e.backtrace[0..3].inspect.to_s
      self.status = 400
    rescue OpenSSL::SSL::SSLError => e
      self.error_reason = e.message.to_s + ' : ' + e.backtrace[0..3].inspect.to_s
      self.status = 403
    rescue OpenURI::HTTPError => e
      self.error_reason = e.message.to_s + ' : ' + e.backtrace[0..3].inspect.to_s
      self.status = 404
    rescue Timeout::Error => e
      self.error_reason = e.message.to_s + ' : ' + e.backtrace[0..3].inspect.to_s
      self.status = 500
    rescue Zlib::DataError => e
      self.error_reason = e.message.to_s + ' : ' + e.backtrace[0..3].inspect.to_s
      self.status = 501
    rescue
    end

    self.touch(:last_checked_at)
    self.save
    check_link if meta_url
  end

  def update_content_url
    if link_checkable
      doc = Nokogiri::HTML::fragment(link_checkable.body)
      doc.css('a').each do |anchor|
        if self.sha.include?(anchor['name']) && self.url
          anchor['href'] = self.url
          anchor['title'] = self.url
        end
      end
      link_checkable.body = doc.to_html
      link_checkable.save
    end
  end

  def url_count
    # return count of other uses of Url
    LinkHealth.where(url: url).count
  end

  def short_link
    if url.nil?
      'No url given'
    else
      link_to(truncate(url, :length => 100, :omission => '...'), url)
    end
  end

  def content
    content = []
    shas.each do |sha|
      begin
        content << "\"#{truncate(text(sha))}\"".html_safe
      rescue
        content << "MISSING"
      end
    end
    content.to_sentence.html_safe
  end

  def can_display
    if DISPLAYABLE.include? mime_type
      "Healthy"
    else
      "Cannot be displayed"
    end
  end

  def status_name
    case self.status
    when 200
      "OK"
    when 404
      "Not Found"
    when 500
      "Server Error"
    when 302
      "Redirect"
    end
  end

  def total_visits
    visits.all.map(&:total_visits).reduce(:+)
  end

  def text sha
    parent.content_by_sha(sha)
  end

  def parent
    link_checkable
  end

  def embeddable
    return false if self.updated_at.nil?
    !['sameorigin','deny', nil].include? self.x_frame_options.try(:downcase)
  end


  def self.mime_types
    LinkHealth.where("mime_type is not null").all.to_a.group_by {|l| l.mime_type}.sort{|a| a.last.size }.reverse
  end
end