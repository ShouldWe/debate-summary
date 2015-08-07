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
module Api
  module V1
    class BaseController < ActionController::Base
      respond_to :json

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      before_filter :authenticate, except: [:api_status]
      after_filter :cors_set_access_control_headers

      def api_status
        render nothing: true, status: :no_content
      end

      protected

      def not_found(exception)
        respond_with({error: exception.message})
      end

      def cors_set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
        headers['Access-Control-Allow-Headers'] = 'Accept, Authorization'
      end

      def authenticate
        authenticate_or_request_with_http_basic do |user, pass|
          user == 'debate-summary' && pass == 'secretpassword'
        end
      end

    end
  end
end
