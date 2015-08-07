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
require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(1.hour,"Send hourly notifications",  at: '**:30', tz: 'UTC') { NotificationReport.send_reports( :hourly) }
every(1.day,"Send daily notifications",  at: '02:00', tz: 'UTC') { NotificationReport.send_reports( :daily) }
every(1.week,"Send weekly notifications",  at: 'Monday 03:00', tz: 'UTC') { NotificationReport.send_reports( :weekly) }
every(2.weeks,"Send fortnightly notifications", at: 'Monday 04:00', tz: 'UTC') { NotificationReport.send_reports( :fortnightly ) }
every(1.day,"Send monthly notifications",  at: '01:00', if: ->(t) { t.day == 1 }, tz: 'UTC') { NotificationReport.send_reports( :monthly) }