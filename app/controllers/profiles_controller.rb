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
class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :check_details_filled_in

  def edit
    @user = current_user
    @notifications = current_user.notification_subscriptions
    @endorsed_user = User.where(:endorsed_by => @user.email)
    @user.setup_notification_prefs
  end

  def update
    edit # set @ variables
    notification_preferences = params[:user].delete(:notification_preferences)
    @user.update_notification_preferences notification_preferences
    if @user.update_attributes(params[:user])
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

end