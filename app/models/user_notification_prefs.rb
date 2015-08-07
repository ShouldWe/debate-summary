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
# This class is serialised and stored inside the user class
class UserNotificationPrefs
  Frequency = [:never, :hourly, :daily,:weekly,:fortnightly,:monthly]
  Ago = { never: 1.day.from_now, hourly: 1.hour.ago, daily: 1.day.ago,weekly: 1.week.ago,fortnightly: 2.weeks.ago ,monthly: 1.month.ago }
  Ago.default = 1.day.from_now

  attr_accessor :page
  attr_accessor :page_report_date
  attr_accessor :section
  attr_accessor :section_report_date
  attr_accessor :comments_edit_i_made
  attr_accessor :comments_edit_i_made_report_date
  attr_accessor :comments_edit_i_commented
  attr_accessor :comments_edit_i_commented_report_date
  def initialize params={}
    self.page                                  = params.fetch(:page) { :weekly }
    self.page_report_date                      = params.fetch(:page_report_date) { nil }
    self.section                               = params.fetch(:section) { :weekly }
    self.section_report_date                   = params.fetch(:section_report_date) { nil }
    self.comments_edit_i_made                  = params.fetch(:comments_edit_i_made) { :weekly }
    self.comments_edit_i_made_report_date      = params.fetch(:comments_edit_i_made_report_date) { nil }
    self.comments_edit_i_commented             = params.fetch(:comments_edit_i_commented) { :weekly }
    self.comments_edit_i_commented_report_date = params.fetch(:comments_edit_i_commented_report_date) { nil }
  end
  def update_from_hash hash
    hash.each_pair do |k,v|
      self.send(:"#{k}=",v.to_sym)
    end
  end
end