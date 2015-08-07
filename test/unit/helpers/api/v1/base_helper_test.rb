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

class Api::V1::BaseHelperTest < ActionView::TestCase
  test "returns the user avatar thumbnail url" do
    actual = full_url("/assets/fallback/thumb_default.png")
    assert_equal "http://localhost:3000/assets/fallback/thumb_default.png", actual
  end

  test "passes full URL thru" do
    actual = full_url("http://example.com/assets/fallback/thumb_default.png")
    assert_equal "http://example.com/assets/fallback/thumb_default.png", actual
  end

  test "returns nil if no host" do
    stash = ActionMailer::Base.default_url_options.dup
    ActionMailer::Base.default_url_options = {}

    actual = full_url('')
    assert_equal nil, actual

    ActionMailer::Base.default_url_options = stash
  end

end