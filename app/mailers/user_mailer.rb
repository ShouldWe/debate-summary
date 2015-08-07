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
class UserMailer < ActionMailer::Base
  def welcome_email(user)
    @userFind = UserDecorator.decorate user
    @user = @userFind.name
    @url  = "<a href=#{root_url}users/sign_in>#{root_url}users/sign_in</a>"
    @template = Template.find("welcome-email").liquid
    mail :subject => "Welcome to Debate Summary",
         :to      => user.email
  end

  def expert_email(user_id, issue_id)
    @user = UserDecorator.decorate User.find(user_id)
    @site = {"url" => root_url, "login_url" => "#{new_user_session_url}"}
    @issue = Issue.find(issue_id)
    @template = Template.find("expert-welcome-email").liquid
    mail subject: "You've been appointed as an Expert on Debate Summary",
         to: @user.email
  end

  def endorse_email(user, to)
    @url = "#{ENV['CURRENT_APP_URL']}/users/sign_up"
    @site = {"url" => root_url, "login_url" => "#{new_user_session_url}"}
    @template = Template.find("endorse-email").liquid
    mail :subject => "@user invites you to become a member of Debate Summary",
         :to => to
  end

  # Email sent to people who were endorsed
  def endorsed_email(endorser, endorsee)
    @site = {"url" => root_url, "login_url" => "#{new_user_session_url}"}
    @user = UserDecorator.decorate endorser
    @template = Template.find("endorsed-email").liquid
    mail :subject => "#{@user.name} endorsed you on Debate Summary",
         :to => endorsee.email
  end

  # Email sent to people who were un-endorsed
  def unendorsed_email(endorser, endorsee)
    @site = {"url" => root_url, "login_url" => "#{new_user_session_url}"}
    @user = UserDecorator.decorate endorser
    @template = Template.find("unendorsed-email").liquid
    mail :subject => "#{@user.name} un-endorsed you on Debate Summary",
         :to => endorsee.email
  end

  # Email sent to people who were made a monitor
  def set_monitor_email(endorser, endorsee)
    @site = {"url" => root_url, "login_url" => "#{new_user_session_url}"}
    @user = UserDecorator.decorate endorser
    @template = Template.find("set-monitor-email").liquid
    mail :subject => "#{@user.name} made you a monitor of Debate Summary",
         :to => endorsee.email
  end

  # Email sent to people who were stripped of a monitor privileges
  def unset_monitor_email(endorser, endorsee)
    @site = {"url" => root_url, "login_url" => "#{new_user_session_url}"}
    @user = UserDecorator.decorate endorser
    @template = Template.find("unset-monitor-email").liquid
    mail :subject => "#{@user.name} removed you as a monitor of Debate Summary",
         :to => endorsee.email
  end

  def alleged_abuser_decision_made_email(abuser, rule_break_report)
    @site = {"url" => root_url, "login_url" => "#{new_user_session_url}"}
    @user = UserDecorator.decorate abuser
    @template = Template.find("alleged-abuser-decision-made-email").liquid
    @rule_break_report = rule_break_report
    @broken_rules = rule_break_report.sorted_rule_violations.map { |house_rule|  "<p>#{house_rule.name}</p>"}.join("<br />")
    mail :subject => "Update about a flagged edit on Debate Summary",
         :to => @user.email
  end

  def abuse_reported
    @template = Template.find("abuse-reported").liquid
    mail :subject => "New abuse report",
         :to => "hello@debatesummary.org"
  end
end
