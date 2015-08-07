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

class PagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    Template.create!(title: "Welcome Email")
    @user = User.create!(email: "test@example.com", name: "Tester", password: "password")
    sign_in @user
    @page = Page.create(title: "MyString",
                        markdown: "MyTest",
                        permalink: "MyString",
                        compiled: "MyString",
                        published: true)
  end

  teardown do
    Template.destroy_all
    Page.destroy_all
  end

  test "should show page" do
    get :show, id: @page
    assert_response :success
  end
end