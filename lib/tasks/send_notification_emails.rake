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
require './app/models/user_notification_prefs'
# This is all controlled dynamically by the data in the above class
# NOTE: for Heroku we're using clock - this will only matter if we go to more conventional
# tin and want to use rake and cron instead
namespace :notifications do
  UserNotificationPrefs::Frequency.delete_if { |thing| thing == :never }.each do |frequency|
    desc "send #{frequency} notification reports"
    task frequency => :environment do
      NotificationReport.send_reports frequency
    end
  end
end