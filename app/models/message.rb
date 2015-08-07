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
class Message < ActiveRecord::Base
  attr_accessible :content, :title
  
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  
  scope :read, where(read: true)
  scope :unread, where(read: false)
  
  scope :abuse, where(abuse: true)
  scope :clean, where(abuse: false)
  
  def read!
    update_column(:read, true)
  end
  
  class << self
    def message_to(sender, recipient, details={})
      m = new(details)
      m.sender_id = sender.is_a?(Fixnum) ? sender : sender.id
      m.recipient_id = recipient.is_a?(Fixnum) ? recipient : recipient.id
      m.save!
    end
    
    def reply_to(message_id, details)
    end
    
    def notify(recipients, details={})
      recipients.each do |user|
        m = new(details)
        m.recipient_id = user
        m.save!
      end
    end
  end
  
  set_callback(:commit, :after) do |doc|
    MessageMailer.new_message(doc.id).deliver
  end
  
end