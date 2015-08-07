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
require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test "it honours user preferences" do
    issue = create(:issue)
    user = create(:user)
    user.activities.create(issue: issue)
    NotificationReport.send_reports(:hourly)
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "it does not repetitively notify user about a page" do
    issue = create(:issue)
    user = create(:user)
    user.notification_preferences.page=:hourly
    user.save
    user.activities.create(issue: issue)
    NotificationReport.send_reports(:hourly)
    NotificationReport.send_reports(:hourly)
    NotificationReport.send_reports(:hourly)
    NotificationReport.send_reports(:hourly)
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test "it does not repetitively notify user about a comment" do
    user = create(:user)
    user.notification_preferences.comments_edit_i_made=:hourly
    user.save

    issue = create(:issue)
    activity = user.activities.create(issue: issue)
    comment = create(:comment, issue: issue, commentable: activity)
    comment.user.activities.create(issue: issue, recordable: comment, activity_type: 'Comment')

    NotificationReport.send_reports(:hourly)
    NotificationReport.send_reports(:hourly)
    NotificationReport.send_reports(:hourly)
    NotificationReport.send_reports(:hourly)
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test "it does not repetitively notify user about a commented item" do
    user = create(:user)
    user.notification_preferences.comments_edit_i_commented=:hourly
    user.save

    issue = create(:issue)

    activity = user.activities.create(issue: issue)

    comment = create(:comment, user: user, commentable: activity)

    NotificationReport.send_reports(:hourly)
    NotificationReport.send_reports(:hourly)
    NotificationReport.send_reports(:hourly)
    NotificationReport.send_reports(:hourly)
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

end