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
class UsersController < ApplicationController
  autocomplete :user, :name

  def show
    @user = UserDecorator.new User.find(params[:id])
    @activities = ActivityDecorator.decorate @user.activities.includes(:issue).order("created_at DESC").limit(10)
  end

  def set_monitor
    if current_user.is_monitor?
      @user = UserDecorator.new User.find(params[:user_id])

      if ! params[:user].blank? && params[:user][:monitors] == 'normal'
        @user.monitors = 'normal'
      else
        @user.monitors = nil
      end
      if @user.save
        if @user.is_monitor?
          UserMailer.set_monitor_email(current_user, @user).deliver
        else
          UserMailer.unset_monitor_email(current_user, @user).deliver
        end
        flash[:notice] = "User has been set as a monitor"
      else
        flash[:error] = "User has not been set as a monitor"
      end

      redirect_to @user
    end
  end

  def set_endorsed
    if current_user.is_endorsed?
      @user = User.find(params[:user_id])

      if ! params[:user].blank? && params[:user][:endorsed] == 'true'
        @user.endorsed = true
        @user.endorsed_by = current_user.email
      end

      if @user.save
        if @user.is_endorsed?
          UserMailer.endorsed_email(current_user, @user).deliver
        else
          UserMailer.unendorsed_email(current_user, @user).deliver
        end
        flash[:notice] = "User has been endorsed"
      else
        flash[:error] = "User has not been endorsed"
      end

      redirect_to @user
    end
  end
end