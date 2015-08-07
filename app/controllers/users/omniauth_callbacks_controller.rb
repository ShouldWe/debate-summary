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
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  layout 'sm_login'

  def facebook
    setup_user_and_oauth :facebook_uid

    if message = current_user.facebook_oauth_message(@omni_response)
      flash[:error] = message
      redirect_to edit_profile_path
    else
      if current_user.new_record?
        current_user.validate_email = false
        current_user.save 
        render template: 'sm_login/confirm'
      else
        save_and_login_user
        redirect_to sm_login_complete_path
      end
    end
  end

  def twitter
    setup_user_and_oauth :twitter_uid

    if message = current_user.twitter_oauth_message(@omni_response)
      flash[:error] = message
      redirect_to edit_profile_path
    else

      if current_user.new_record?
        current_user.validate_email = false
        current_user.save 
        render template: 'sm_login/confirm'
      else
        save_and_login_user
        redirect_to sm_login_complete_path
      end

    end
  end

  def linkedin
    setup_user_and_oauth :linkedin_uid
    if message = current_user.linkedin_oauth_message(@omni_response)
      flash[:error] = message
      redirect_to edit_profile_path
    else
      if current_user.new_record?
        current_user.validate_email = false
        current_user.save 
        render template: 'sm_login/confirm'
      else
        save_and_login_user
        redirect_to sm_login_complete_path
      end

    end

  end

  def failure
    flash[:error] = I18n.t('login.omniauth_error')
  end

  private
  def setup_user_and_oauth key
    @omni_response = request.env['omniauth.auth']
    @current_user ||=  User.where({key => @omni_response.uid}).first  || User.new
  end
  def save_and_login_user
    current_user.save validate: (current_user.new_record?)
    sign_in current_user, :bypass => true 
  end
end