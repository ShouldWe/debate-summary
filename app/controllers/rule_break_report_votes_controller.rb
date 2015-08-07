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
class RuleBreakReportVotesController < ApplicationController
  before_filter :authorize_monitor!

  def index
    # 
    @rule_break_reports_vote = RuleBreakReport.unresolved.not_voted(current_user)
    @rule_break_reports_previous_votes = RuleBreakReport.previous_votes(current_user)
    @rule_break_reports_decision_due = RuleBreakReport.unresolved.decision_due
  end

  def create
    rbrv = RuleBreakReportVote.create(params[:rule_break_report_vote])

    redirect_to :back
  end

  def update
    rbrv = RuleBreakReportVote.find params[:rule_break_report_vote][:id]
    rbrv.update_attributes(params[:rule_break_report_vote])

    redirect_to :back
  end

  private

  def authorize_monitor!
    redirect_to root_path if current_user.blank? || ! current_user.is_monitor?
  end
end