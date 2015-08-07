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
require 'test_helper'

class Api::V1::BaseControllerTest < ActionController::TestCase
  test "GET api_status" do
    get :api_status
    assert_response :success

    assert_match '*',         response.headers['Access-Control-Allow-Origin']

    assert_match 'GET',       response.headers['Access-Control-Allow-Methods']
    assert_match 'OPTIONS',   response.headers['Access-Control-Allow-Methods']
    refute_match %r{POST},      response.headers['Access-Control-Allow-Methods']
    refute_match %r{PUT},       response.headers['Access-Control-Allow-Methods']
    refute_match %r{DELETE},    response.headers['Access-Control-Allow-Methods']
    refute_match %r{PATCH},     response.headers['Access-Control-Allow-Methods']
    refute_match %r{TRACE},     response.headers['Access-Control-Allow-Methods']
    refute_match %r{CONNECT},   response.headers['Access-Control-Allow-Methods']

    assert_match 'Accept',         response.headers['Access-Control-Allow-Headers']
    assert_match 'Authorization',  response.headers['Access-Control-Allow-Headers']
  end
end