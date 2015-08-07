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

  test "comments_edit_i_made_for_period" do
    user = User.new(email: 'test@example.com')
    issue = Issue.new(title: 'Should we test?')
    activity = Activity.new()
    activity.user = user
    activity.issue = issue
    activity.body = 'hi'
    report = {}.tap do |output|
      output[issue] = [activity]
    end
    email = NotificationMailer.comments_edit_i_made_for_period('Some', user, report).deliver

    refute ActionMailer::Base.deliveries.empty?, 'should have delivered'
    assert_equal [user.email], email.to
    assert_equal ['noreply@debatesummary.com'], email.from
    assert_equal '[Debate Summary] Some comments on edits I made', email.subject
  end
end
