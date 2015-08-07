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
class IssueTitleVote < ActiveRecord::Base
  belongs_to :issue_title
  belongs_to :user
  attr_accessible :ip_address, :issue_title_id, :user_id

  after_create :update_issue_title

  private

  def update_issue_title
    issue = issue_title.issue
    top_title = issue.suggested_titles.max_by { |t| t.current_score }
    if ! top_title.blank? && top_title.title != issue.title
      issue.title = top_title.title
      issue.save
    end
  end
end