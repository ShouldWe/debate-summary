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
class Activity < ActiveRecord::Base

  belongs_to :user
  belongs_to :issue
  belongs_to :proposed_edit

  has_many :comments, as: :commentable
  has_many :votes, as: :voteable

  has_many :rule_break_reports, as: :reportable

  belongs_to :recordable, polymorphic: true

  attr_accessible :issue, :activity_type, :proposed_edit, :comment, :recordable

  scope :latest, order('id DESC')

  set_callback(:commit, :after) do |doc|
    NotificationWorker.perform_async(doc.id)
  end

  def empty_edits?
    proposed_edit.nil? || proposed_edit.get_changed_data_to_be_displayed_to_the_user.empty?
  end

  def votes_for
    votes.map{|v| v.vote }.inject(:+) || 0
  end

  def already_flagged_as_inappropriate?(user)
    ! rule_break_reports.where(:reporter_id => user.id).empty?
  end

  def get_rule_break_report_by(user)
    rule_break_reports.where(:reporter_id => user.id).first
  end

  def rule_break_reports_count
    rule_break_reports.count
  end
end