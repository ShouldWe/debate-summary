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
# coding: utf-8
require 'open-uri'
require 'active_support/core_ext/object'
require 'cgi'

# BingNews
# Uses the Azure DataMarket API to get news feeds matching tags of a given issue
class BingNews
  ACCOUNT_KEY = ENV['AZURE_DATAMARKET_API_KEY']
  attr_accessor :endpoint, :body
  def initialize(query)
    @endpoint = 'https://api.datamarket.azure.com/Bing/Search/v1/Composite'
    query_string = []
    query_string << "'news'".to_query('Sources')
    query_string << "'#{query}'".to_query('Query')
    @endpoint += "?#{query_string.join('&')}"
  end

  def body
    @body ||= open(@endpoint,
         http_basic_authentication: ['',ACCOUNT_KEY],
         'Accept' => 'application/json').read
  end

  def news
    JSON.parse(body)['d']['results'][0]['News']
  rescue OpenURI::HTTPError, JSON::ParserError, SystemCallError
    return []
  end
end
