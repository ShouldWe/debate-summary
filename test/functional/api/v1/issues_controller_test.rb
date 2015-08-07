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

class Api::V1::IssuesControllerTest < ActionController::TestCase
  setup do
    Template.create!(title: "Welcome Email")
    @user = create(:user)
  end

  def valid_credentials
    ActionController::HttpAuthentication::Basic.encode_credentials(
      'debate-summary',
      'secretpassword'
    )
  end

  def invalid_credentials
    ActionController::HttpAuthentication::Basic.encode_credentials(
      'admin',
      'password'
    )
  end

  test "valid access control" do
    i = create(:issue)

    @request.env["HTTP_AUTHORIZATION"] = valid_credentials
    @request.env["HTTP_ACCEPT"] = 'application/json'
    get :show, {id: i.id}
    assert_response :success

    assert_match '*', response.headers['Access-Control-Allow-Origin']

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

  test "invalid access control" do
    @request.env["HTTP_AUTHORIZATION"] = invalid_credentials
    @request.env["HTTP_ACCEPT"] = 'application/json'
    get :show, nil
    assert_response 401
  end

  test "GET issue" do
    i = create(:issue)

    @request.env["HTTP_AUTHORIZATION"] = valid_credentials
    @request.env["HTTP_ACCEPT"] = 'application/json'
    get :show, { id: i.id }

    assert_template :show
    assert_template layout: false
    json = JSON.parse(response.body)
    assert_equal i.title, json['title']
    assert_equal i.id,    json['id']

    assert_equal Hash, json['image'].class
    assert_equal 'http://localhost:3000/assets/default_image.jpg', json['image']['thumb']
    assert_equal 'http://localhost:3000/assets/default_image.jpg', json['image']['normal']
    assert_equal 'http://localhost:3000/assets/default_image.jpg', json['image']['original']

    assert_equal Array,   json['context'].class
    assert_equal Array,   json['yesses'].class
    assert_equal Array,   json['noes'].class
    assert_equal Array,   json['perspectives'].class
    assert_equal Array,   json['relevances'].class
    assert_equal Array,   json['tags'].class
    assert_equal Array,   json['contributors'].class
    assert json.has_key?('updatedBy')
    assert_equal i.created_at.iso8601,    json['createdAt']
    assert_equal i.updated_at.iso8601,    json['updatedAt']
  end

  test "GET issues?trending" do
    issue = create(:issue, tag_list: 'Something')
    tag = issue.tags.first
    create(:visit, visitable: issue)

    @request.env["HTTP_AUTHORIZATION"] = valid_credentials
    @request.env["HTTP_ACCEPT"] = 'application/json'

    get :index, {trending: true}

    json = JSON.parse(response.body)

    assert_equal issue.id, json['issues'][0]['id']
    assert_equal issue.title, json['issues'][0]['title']

    assert_equal tag.name, json['tags'][0]['name']
    assert_equal 1, json['tags'][0]['count']

    Api::V1::Tag::GROUPS.length.times do |i|
      assert_equal Api::V1::Tag::GROUPS[i], json['sections'][i]['name']
    end
  end

  test "GET issue other sources" do
    @request.env["HTTP_AUTHORIZATION"] = valid_credentials
    @request.env["HTTP_ACCEPT"] = 'application/json'

    issue = create(:issue)

    get :other_sources, {id: issue.id}

    json = JSON.parse(response.body)
    assert_equal '2014-04-13T05:55:40Z', json[0]['updatedAt']
    assert_equal 'Two Center Tourism Program to be launched between China and the Bahamas', json[0]['title']
    assert_equal 'Extensive consultation has been undertaken with the tourism industry and across government and industry in both China and the Bahamas to guide the development of a Two Center Tourism Program with the Chinese tourist traveling to both the United States and ...', json[0]['content']
    assert_equal 'Thebahamasweekly.com', json[0]['source']
  end

  test "GET search" do
    @request.env["HTTP_AUTHORIZATION"] = valid_credentials
    @request.env["HTTP_ACCEPT"] = 'application/json'

    issue = create(:issue, tag_list: ['politics'])

    get :search, {q: 'politics'}

    json = JSON.parse(response.body)

    assert_equal issue.id, json['issues'][0]['id']
    assert_equal issue.title, json['issues'][0]['title']
  end
end
