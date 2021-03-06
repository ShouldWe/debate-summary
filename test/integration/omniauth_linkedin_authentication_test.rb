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

class OmniauthLinkedInAuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    OmniAuth.config.on_failure = Proc.new { |env|
      OmniAuth::FailureEndpoint.new(env).redirect_to_failure
    }
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
      provider: 'linkedin',
      uid: '1',
      credentials: {
        token: 'AAAA%2FAAA%3DAAAAAAAA',
        secret: 'abcdef1234'
      },
      info: {
        name: 'Example User',
        image: 'http://example.com/image_normal.jpg',
        email: 'test@example.com'
      },
      extra: {
        raw_info: {
          numConnetions: '1'
        }
      }
    })
  end

  test 'Login to site via LinkedIn' do
    post_via_redirect '/users/auth/linkedin/callback', {uid: '1'}
    assert_response :success
    assert_match 'Confirm your details', response.body
  end

  test 'Error when trying LinkedIn' do
    OmniAuth.config.mock_auth[:linkedin] = :invalid_credentials
    post_via_redirect '/users/auth/linkedin/callback', {uid: '1'}
    assert_match 'Sorry, there was an error authorising your account.', response.body

    assert_match 'Sign in with', response.body
    assert_match 'Facebook', response.body
    assert_match 'Twitter', response.body
    assert_match 'LinkedIn', response.body
  end

end