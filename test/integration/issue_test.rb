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

class IssueTest < ActionDispatch::IntegrationTest
  test '/issues/:slug uses slug' do
    issue = create(:issue)
    issue.generate_friendly_id = true
    issue.tmp_slug = 'something'
    issue.save!
    get '/issues/something'
    assert_response :success, 'uses Friendly ID Slug'
    assert_tag tag: 'meta', attributes: {content: 'http://www.example.com/issues/something', name: 'canonical'}

    get "/issues/#{issue.id}"
    assert_response :redirect, 'standard ID route is a redirect'
    assert_redirected_to 'http://www.example.com/issues/something'

    issue.generate_friendly_id = true
    issue.tmp_slug = 'new something'
    issue.save!
    get '/issues/new-something'
    assert_response :success, 'uses Friendly ID Slug'
    assert_tag tag: 'meta', attributes: {content: 'http://www.example.com/issues/new-something', name: 'canonical'}

    get '/issues/something'
    assert_response :redirect, 'standard ID route is a redirect'
    assert_redirected_to 'http://www.example.com/issues/new-something'
  end

  test '/issues/non-existent' do
    assert_raises(ActiveRecord::RecordNotFound) do
      get '/issues/non-existent'
    end
  end
end