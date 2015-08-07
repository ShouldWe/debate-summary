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
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_basic_auth! unless Rails.env.development? || Rails.env.test?
  before_filter :check_details_filled_in
  layout :process_pjax
  helper_method :current_user#, :require_admin
  after_filter :update_user_activity
  before_filter :log_referrer

  include OpenGraph::Helpers

  def require_admin
    unless current_user && current_user.admin
      store_location
      redirect_to login_path
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

# Error 404 and 500 code, public section

  #unless Rails.application.config.consider_all_requests_local
  #  rescue_from Exception, with: lambda { |exception| render_error 500, exception }
  #  rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  #end

  private

# Auth setup for John, Geroge and Alan based on preset values

  def authenticate_basic_auth!
    users = {
      ENV['JOHN_USERNAME'] => ENV['JOHN_PASSWORD'],
      ENV['ALAN_USERNAME'] => ENV['ALAN_PASSWORD'],
      ENV['GEORGE_USERNAME'] => ENV['GEORGE_PASSWORD'],
      ENV['BETA_USERNAME'] => ENV['BETA_PASSWORD']
      }.delete_if{|k,v| k.nil? }
    return unless users.any?
    authenticate_or_request_with_http_basic do |username, password|
      users[username] == password
    end
  end

  def authenticate_admin!
    redirect_to root_path unless current_user && current_user.admin?
  end

  def update_user_activity
    current_user.try(:touch) if current_user
  end

  def process_pjax
    request.headers['X-PJAX'] ? false : "application"
  end

  def check_details_filled_in
    if current_user && current_user.email.blank? && controller_name != "sessions"
      flash[:error] = 'Please give us your name and email'
      redirect_to edit_profile_path
    end
  end

  def log_referrer
    session[:referrer] = request.referrer if request.referrer
  end
end
