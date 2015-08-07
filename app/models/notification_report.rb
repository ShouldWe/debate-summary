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
module NotificationReport
  Clock = { hourly: 1.hour, daily: 1.day,weekly: 1.week,fortnightly: 2.weeks ,monthly: 1.month }

  module_function
  
  def page period, user
    issues      = user.activities.collect(&:issue).uniq.select(&:present?)
    {}.tap do |output|
      # Get changes for all pages I have ever had anything to do with in the last period
      # Return hash with issue as key and array of activities as value
      # We're also scoping on the date that the user was last sent the info in case they changed prefs
      # and don't want to be told twice
      issues.each do |issue|
        user_report_date = user.notification_preferences.page_report_date || UserNotificationPrefs::Ago[period]
        activities = issue.activities.where('updated_at >= ?',user_report_date)
        output[issue] = activities if activities.present?
      end
    end
  end

  def comments_edit_i_made period, user
    issues   = user.activities.collect(&:issue).uniq.select(&:present?)
    {}.tap do |output|
      # Get my edits (activities) and then get the issues that someone has commented on
      # Return hash with issue as key array of activities as value, only if there is a new comment
      # We're also scoping on the date that the user was last sent the info in case they changed prefs
      # and don't want to be told twice
      issues.each do |issue|
        user_report_date = user.notification_preferences.comments_edit_i_made_report_date || UserNotificationPrefs::Ago[period]
        activities = issue.activities.includes(:comments).where("exists (select 1 from comments where commentable_id = activities.id and commentable_type = 'Activity' and updated_at >= ?)",user_report_date)
        output[issue] = activities if activities.present?
      end
    end
  end

  def comments_edit_i_commented period, user
    # This is horribly clumsy because we're using objects and sometimes things have been deleted so we need .select(&:present?)
    # TODO make this work with SQL
    # Get activities I have commented on
    activities   = user.comments.collect(&:commentable).uniq.select(&:present?)
    # Get issues for these activities
    issues = activities.collect(&:issue).uniq.select(&:present?)
    {}.tap do |output|
      # Return hash with issue as key array of activities as value, only if there is a new comment
      # We're also scoping on the date that the user was last sent the info in case they changed prefs
      # and don't want to be told twice
      issues.each do |issue|
        user_report_date = user.notification_preferences.comments_edit_i_commented_report_date || UserNotificationPrefs::Ago[period]
        activities = issue.activities.where("exists (select 1 from comments where commentable_id = activities.id and commentable_type = 'Activity' and updated_at >= ?)",user_report_date)
        output[issue] = activities if activities.present?
      end
    end
  end

  def section period, user
    # This method does nothing
  end

  def send_reports period
    reports = {}
    User.all.each do |user|
      user.setup_notification_prefs
      [
        :page,
        :section,
        :comments_edit_i_made,
        :comments_edit_i_commented,
      ].each do |notification|
        if user.notification_preferences.send(notification) == period
          reports[user] ||= {}
          reports[user][notification] = NotificationReport.send(notification, period, user)
          user.notification_preferences.send(:"#{notification}_report_date=",Time.zone.now)
        end
      end
    end
    reports.each_pair do |user,notifications|
      notifications.each_pair do |notification,data|
        NotificationMailer.send(:"#{notification}_for_period",period,user,data).deliver if data.present?
      end
      user.save!
    end
  end

end