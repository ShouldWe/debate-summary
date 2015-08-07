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
class HouseRuleBreakReportController < ApplicationController
  before_filter :setup_text
  def new
    @activity = Activity.find params[:activity_id]

    @rbr = RuleBreakReport.new
    @rbr.seriousness = 0
  end

  def create
    @activity = Activity.find params[:activity_id]
    params[:rule_break_report][:house_rule_ids] ||= []
    @rbr = RuleBreakReport.new(params[:rule_break_report])
    @rbr.reportable = @activity
    @rbr.reporter = current_user

    if @rbr.save
      flash[:notice] = 'Rule break report submitted successfully'
      UserMailer.abuse_reported.deliver
      redirect_to @activity
    else
      render :new
    end
  end

  def destroy
    rbr = RuleBreakReport.find(params[:id])
    activity = rbr.reportable
    rbr.destroy

    redirect_to activity
  end
  private
  def setup_text
    @rule_break_title = get_liquid_for 'rule-break-title'
    @rule_break_top = get_liquid_for 'rule-break-top'
    @rule_break_bottom = get_liquid_for 'rule-break-bottom'
  end
  def get_liquid_for text_name, items={}
    if liquid = Template.find(text_name).liquid
      liquid.render(items).html_safe
    else
      self.class.default_text_for[text_name]
    end
  end
  def self.default_text_for text_name
    @default_text_for ||= {}
    if @default_text_for.empty?
      @default_text_for["rule-break-top"] = <<-EOT
<br>
If you have discovered inappropriate edits on Debate Summary, please re-edit the page back to compliance with the house rules below and create a comment to tell the original author that you disagree with them.<br><br>
If you believe that the original author has acted grossly inappropriately you can use the form below to notify the Debate Summary site admins.  In extreme circumstances they may restrict the account of users who are making inappropriate edits.<br><br>
The edit you disagree with is:<br>
      EOT
      @default_text_for["rule-break-title"] = "<h2>Flag edit as inappropriate</h2>",
      @default_text_for["rule-break-bottom"] = "Other users will see that this edit has been flagged, but they will not know that it was you who flagged it.  The ShouldWe admins will decide whether the user should lose their ability to edit"
    end
    @default_text_for[text_name]
  end
end
