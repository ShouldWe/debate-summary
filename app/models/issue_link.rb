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
class IssueLink < ActiveRecord::Base
  belongs_to :issue
  has_many :proposed_edits, as: :editable
  attr_accessible :title, :url
  has_paper_trail
  
  set_callback(:save, :before) do |doc|
    Link.find_or_create_by_url(doc.url) #if doc.url_changed?
  end
  
  def link
    Link.find_by_url(self.url).link
  rescue
    nil
  end

  def resource_linked_to
    resource = Issue.new

    path = get_path(url)

    if ! path.blank?
      match = /.*\/(?<linked_issue_id>.*)$/.match(path)
      issue = Issue.find(match[:linked_issue_id]) unless match.blank? || match[:linked_issue_id].blank?
      resource = issue unless issue.nil?
    end

    resource
  end
  
  def short_url; self.id.to_s(36); end
  scope :by_short_url, lambda{|url| where(id: url.to_i(36))}

  private

  def get_path(url_or_path)
    begin
      uri = URI.parse(url_or_path)
      path = uri.path
    rescue URI::InvalidURIError
      path = url_or_path
    end

    path
  end
end