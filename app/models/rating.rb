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
class Rating < ActiveRecord::Base
  ## CONSTANTS AND CLASS ESSENTIAL CODE
  IP_VALIDATION_REGEX = /^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$/
  RATEABLE_MODELS = ['issue']
  
  ## SECURITY / ACCESS CONTROL
  attr_accessible :ip_address, :rateable_id, :rateable_type, :score
  
  ## RELATIONSHIPS
  belongs_to :rateable, polymorphic: true
  belongs_to :user, inverse_of: :ratings
  
  ## VALIDATIONS
  validates :rateable_id, presence: true
  validates :rateable_type, presence: true
  validates :ip_address, presence: true, format: {with: IP_VALIDATION_REGEX}, uniqueness: {scope: [:rateable_id, :rateable_type, :user_id]}
  validates :score, presence: true, numericality: true
  
  ## UTILITY SCOPES FOR RECALLING TIME BASED RATINGS
  scope :this_week, lambda { where('created_at > ?', Time.now.beginning_of_week) }
  scope :last_week, lambda { where(created_at: (Time.now - 1.week).beginning_of_week..(Time.now - 1.week).end_of_week) }
  scope :this_month, lambda{ where(created_at: Time.now.start_of_month..Time.now.end_of_month) }
  scope :last_month, lambda{ where(created_at: (Time.now - 1.month).start_of_month..(Time.now - 1.month).end_of_month) }
  scope :this_year, lambda{ where(created_at: Time.now.start_of_year..Time.now.end_of_year) }
  scope :last_year, lambda{ where(created_at: (Time.now - 1.year).start_of_year..(Time.now - 1.year).end_of_year) }
  
  ## CONVENIENCE METHODS FOR ACCESSING AVERAGE SCORES
  class << self
    def average_this_week; this_week.average(:score); end
    def average_last_week; last_week.average(:score); end
    def average_this_month; this_month.average(:score); end
    def average_last_month; last_month.average(:score); end
    def average_this_year; this_year.average(:score); end
    def average_last_year; last_year.average(:score); end
  end
end