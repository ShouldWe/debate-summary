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
require_relative '../../../app/extractables/bing_news'

class BingNewsTest < Test::Unit::TestCase

  include WebMock::API
  def setup
    stub_request(:get, %r{api.datamarket.azure.com/Bing/Search/v1/Composite}).
      to_return(File.read(File.dirname(__FILE__) + '/../../http_fixtures/bing-api.json'))
  end

  def test_correctly_generated_endpoint_uri
    api = BingNews.new('travel & tourism')
    assert_equal 'https://api.datamarket.azure.com/Bing/Search/v1/Composite?Sources=%27news%27&Query=%27travel+%26+tourism%27', api.endpoint
  end

  def test_query_string
    api = BingNews.new('Business')
    assert_equal 'https://api.datamarket.azure.com/Bing/Search/v1/Composite?Sources=%27news%27&Query=%27Business%27', api.endpoint
  end

  def test_news
    api = BingNews.new('travel & tourism')
    assert_equal 15, api.news.size
  end

  def test_failed_response
    stub_request(:get, %r{api.datamarket.azure.com/Bing/Search/v1/Composite}).
      to_return({status: 400})
    api = BingNews.new('travel & tourism')
    assert_equal 0, api.news.size
  end

  def test_failed_response_body
    stub_request(:get, %r{api.datamarket.azure.com/Bing/Search/v1/Composite}).
      to_return({status: 200, body: ''})
    api = BingNews.new('travel & tourism')
    assert_equal 0, api.news.size
  end

end
