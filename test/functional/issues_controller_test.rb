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

class IssuesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    Template.create!(title: "Welcome Email")
    @user = User.create!(email: "test@example.com", name: "Tester", password: "password")
    sign_in @user
  end

  teardown do
    Template.destroy_all
    User.destroy_all
    Issue.destroy_all
  end

  test "persistence of attributes on create failure" do
    args = {
      issue: {
        title: "hello world"
      },
      detail_fors: [
        [
          Time.now.to_i,
          {
            title: "hello world",
            body: "<a href='http://example.com'>lorem</a>"
          }
        ]
      ]
    }
    post :create, args

    assert_response :success
    i = assigns['issue']
    detail_for = assigns['detail_fors']
    assert_equal 1, detail_for.size
  end

  test "create page on successful save" do
    HyperlinkExtractor.jobs.clear
    args = {
      issue: {
        title: "Should hello world?",
        context: '<a href="">Hello world</a>'
      },
      detail_fors: [
        [
          Time.now.to_i,
          {
            title: "hello world",
            body: "<a href='http://example.com'>lorem</a>"
          }
        ]
      ]
    }

    post :create, args
    assert_equal 1, HyperlinkExtractor.jobs.size
    assert_response :redirect
    assert session[:updated_issue].present?, "has session set"
  end

  test "update issue with new detail_fors" do
    HyperlinkExtractor.jobs.clear
    i = create(:issue)
    d = i.detail_fors.create(title: 'test', body: '<a href="#">should</a>')
    args = {
      id: i.id,
      issue: {
        tag_list: []
      },
      detail_fors: [
        [
          d.id,
          {
            title: "Hello World",
            body: "<a href='http://example.com'>lorem</a>"
          }
        ]
      ]
    }
    put :update, args
    assert_equal 1, HyperlinkExtractor.jobs.size
    assert_response :redirect
    assert_equal 1, i.detail_fors.size
  end

  test "update issue editing detail_fors" do
    i = create(:issue)
    d = i.detail_fors.create(title: 'test', body: '<a href="#">should</a>')
    args = {
      id: i.id,
      issue: {
        tag_list: []
      },
      detail_fors: [
        [
          d.id,
          {
            title: "Hello World",
            body: "<a href=\"http://example.com\" title=\"http://example.com\">lorem</a>"
          }
        ]
      ]
    }
    put :update, args

    assert_response :redirect
    assert_match %r{<a href="http://example.com" title="http://example.com" name="[a-zA-Z0-9]{6}">lorem</a>}, i.detail_fors.last.body
  end


  test "update removes detail_fors" do
    i = create(:issue)
    d = i.detail_fors.create!(title: "Hello World", body: "<a href>example</a>")
    args = {
      id: i.id,
      issue: {
        tag_list: []
      },
      detail_fors: []
    }

    assert_equal 1, i.detail_fors.size
    put :update, args

    assert_response :redirect
    assert_equal 0, i.detail_fors.size
  end

  test "validate without refreshing page" do
    xhr :post, :create
    assert_response :success
    assert_match 'Title needs to be formatted starting with &quot;Should&quot; and ending with a Question-mark.', response.body
    assert_match 'There was a problem saving this page:', response.body
  end

  test "refreshes page on successful save" do
    args = {
      issue: {
        title: "Should hello world?",
        context: '<a href="">Hello world</a>'
      },
      detail_fors: [
        [
          Time.now.to_i,
          {
            title: "hello world",
            body: "<a href='http://example.com'>lorem</a>"
          }
        ]
      ]
    }

    xhr :post, :create, args
    assert_response :success
    assert session[:updated_issue].present?, "has session set"
  end

  test 'validate post detail without refreshing page and display error' do
    invalid_body = ''
    500.times do
      invalid_body << 'test '
    end
    args = {
      issue: {
        title: "hello world"
      },
      detail_fors: [
        [
          Time.now.to_i,
          {
            title: "hello world",
            body: invalid_body
          }
        ]
      ]
    }
    xhr :post, :create, args
    assert_response :success
    assert_match '&quot;Yes&quot; arguments: is invalid', response.body
    assert_match 'There was a problem saving this page:', response.body
  end

  test 'validate put detail without refreshing page and display error' do
    issue = create(:issue)
    invalid_body = ''
    500.times do
      invalid_body << 'test '
    end
    detailable = [
      [
        '0', {
          title: 'test',
          body: invalid_body
        }
      ]
    ]
    xhr :put, :update, {id: issue.id, issue: {}, detail_fors: detailable}
    assert_response :success
    assert_match '&quot;Yes&quot; arguments: Body is too long (maximum is 200 words)', response.body
    assert_match 'There was a problem saving this page:', response.body
  end

  test 'validate put without refreshing page and display error' do
    issue = create(:issue)
    xhr :put, :update, {id: issue.id, issue: {title: ''}}
    assert_response :success
    assert_match 'Title needs to be formatted starting with &quot;Should&quot; and ending with a Question-mark.', response.body
    assert_match 'There was a problem saving this page:', response.body
  end

  test 'validate put without refreshing page and redirect' do
    issue = create(:issue)
    xhr :put, :update, {id: issue.id, issue: {}}
    assert_response :success
    refute_match %r{There was a problem saving this page:}, response.body
    assert_match 'window.location =', response.body
    assert session[:updated_issue].present?, "has session set"
  end

  test 'removes only one linked issue' do
    issue = create(:issue)
    issue2 = create(:issue)
    issue3 = create(:issue)
    issue.issues << issue2
    issue.issues << issue3

    xhr :put, :update, {id: issue.id, issue: {issues: {issue2.id => {"_destroy" => true}}}}
    issue.reload
    assert_equal 1, issue.issues.size
  end


end