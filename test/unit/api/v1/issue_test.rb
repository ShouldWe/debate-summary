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

class Api::V1::IssueTest < ActiveSupport::TestCase
  setup do
    Template.create!(title: "Welcome Email")
    @user = User.create!(email: "test@example.com", name: "Tester", password: "password")
  end

  test "Api::V1::Issue delegated to Issue" do
    i = create(:issue)

    assert_equal i.id, Api::V1::Issue.last.id
  end

  test "context html splitter" do
    i = @user.issues.create!(title: "Should we create something?", context: %Q{<a href="http://example.com">hello world</a>}, tag_list: 'travel')
    d = i.detail_fors.create!(title: "Hello World", body: %Q{<a href="http://example.com">example</a>})
    d = i.detail_againsts.create!(title: "Hello World", body: %Q{<a href="http://example.com">example</a>})
    d = i.detail_alternatives.create!(title: "Hello World", body: %Q{<a href="http://example.com">example</a>})
    d = i.detail_data.create!(title: "Hello World", body: %Q{<a href="http://example.com">example</a>})
    d = i.detail_relevants.create!(title: "Hello World", body: %Q{<a href="http://example.com">example</a>})

    issue = Api::V1::Issue.find(i.id)

    assert_equal 'http://example.com', issue.context.first[:href]
    assert_equal 'hello world', issue.context.first[:content]

    assert_equal 'Hello World', issue.yesses.first[:title]
    assert_equal 'http://example.com', issue.yesses.first[:body].first[:href]
    assert_equal 'example', issue.yesses.first[:body].first[:content]

    assert_equal 'Hello World', issue.noes.first[:title]
    assert_equal 'http://example.com', issue.noes.first[:body].first[:href]
    assert_equal 'example', issue.noes.first[:body].first[:content]

    assert_equal 'Hello World', issue.perspectives.first[:title]
    assert_equal 'http://example.com', issue.perspectives.first[:body].first[:href]
    assert_equal 'example', issue.perspectives.first[:body].first[:content]

    assert_equal 'Hello World', issue.relevances.first[:title]
    assert_equal 'http://example.com', issue.relevances.first[:body].first[:href]
    assert_equal 'example', issue.relevances.first[:body].first[:content]
  end
end