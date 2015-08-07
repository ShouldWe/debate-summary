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
class MessagesController < ApplicationController
  before_filter :authenticate_user!
  
  def inbox
    @messages = MessageDecorator.decorate current_user.received_messages
    @total_message_size = current_user.received_messages.size
  end
  
  def sent_mail
    @messages = MessageDecorator.decorate current_user.sent_messages
    @total_message_size = current_user.sent_messages.size
  end
  
  def read_all
    current_user.received_messages.update_all(read: true)
    redirect_to mailbox_path, notice: "All Notifications have been marked as Read."
  end
  
  def show
    @message = MessageDecorator.decorate Message.where("recipient_id = ?", current_user.id).find(params[:id])
    @message.read! if @message.recipient_id == current_user.id
  end
  
  def send_mail
    data = params[:message].reject{|key,val| [:recipient_id, :title, :content].include?(key)}
    recipient_id = data.delete(:recipient_id).to_i
    sender_id = current_user.id
    
    Message.message_to(sender_id, recipient_id, data)
    
    respond_to do |format|
      format.html { redirect_to sentmail_path, notice: "Message Sent" }
      format.js { render nothing: true }
    end
  end
end