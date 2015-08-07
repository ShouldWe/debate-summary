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

class TagsControllerTest < ActionController::TestCase
  test 'issues tagged with any split with an ampersand' do
    get :show, id: "Economy,Business"
    assert_match '#Economy &amp; #Business', response.body
  end

  test 'displays issues only the tag if ampersand is within the tag' do
    Issue.create(title: 'Should we travel?', tag_list: 'Travel & Tourism')
    get :show, id: "Travel & Tourism"
    assert_match '#Travel &amp; Tourism', response.body
  end

end