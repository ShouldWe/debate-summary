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
class NotificationSubscription < ActiveRecord::Base
  
  PREFERENCES = ["all", "daily", "weekly", "monthly", "no"]
  
  belongs_to :issue
  belongs_to :user
  attr_accessible :preference
  
  validates :preference, inclusion: {in: PREFERENCES}
  validates :issue, presence: true
  validates :user, presence: true
  validates :user_id, uniqueness: {scope: :issue_id}
  
  scope :instant, where(preference: "all")
  
  def self.instant_notification_ids_list
    instant.includes(:user).map(&:user).map(&:id)
  end
  
  set_callback(:commit, :after) do |doc|
    NotificationSubscriptionMailer.delay.subscription_created(doc.id) if doc.created_at == doc.updated_at
  end
  
end