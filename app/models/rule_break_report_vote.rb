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
class RuleBreakReportVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :penalty
  belongs_to :rule_break_report
  attr_accessible :apply_unilaterally, :rule_break_report, :rule_break_report_id, :penalty_id, :user_id, :user

  after_validation :mark_rule_break_report_as_resolved

  private
  def mark_rule_break_report_as_resolved
    if apply_unilaterally?
      rule_break_report.resolved=true
      rule_break_report.resolver_id = user_id
      rule_break_report.penalty_id = penalty_id
      rule_break_report.resolved_at = DateTime.now
      rule_break_report.penalty_end = DateTime.now + penalty.duration.seconds
      rule_break_report.save
    end
  end
end