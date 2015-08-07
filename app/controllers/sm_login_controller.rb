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
class SmLoginController < ApplicationController
  layout 'sm_login'
  def pick_method
  end
  def confirm
    @current_user = User.find(params[:id])
    @current_user.validate_email = true
    if @current_user.update_attributes(params[:user])
      sign_in @current_user, :bypass => true
      set_redirect_to
      render action: :complete
    end
  end
  def complete
    set_redirect_to
  end

  private
  def set_redirect_to
    @redirect_to = "/"
  end
end