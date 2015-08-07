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

class Users::OmniauthCallbacksControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include OmniAuth::Test::StrategyTestCase
  setup do
    OmniAuth.config.test_mode = true
    @request.env["devise.mapping"] = Devise.mappings[:user]
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '1',
      credentials: {
        token: 'AAAA%2FAAA%3DAAAAAAAA',
        secret: 'abcdef1234'
      },
      info: {
        name: 'Example User',
        image: 'http://example.com/image_normal.jpg'
      },
      extra: {
        raw_info: {
          followers_count: '1'
        }
      }
    })

    if Rails.env.test? || Rails.env.cucumber?
      CarrierWave.configure do |config|
        config.storage = :file
        config.enable_processing = false
      end
    end

  end

  test "successful twitter authentication" do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    post :twitter, {uid: "1"}
    assert_response :success

    user = User.last
    assert_equal 1, user.twitter_follower_count, 'Stores the user follower count'
    assert_equal 'Example User', user.name, 'Stores the name'
    assert_equal '1', user.twitter_uid, 'Stores the Twitter UID'
    assert_equal "/uploads/user/avatar/#{user.id}/image.jpg", user.avatar.to_s, 'Stores the Twitter Avatar'
  end
end