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
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :truncation

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  require 'sidekiq/testing'
  require 'webmock/test_unit'
  include WebMock::API

  include FactoryGirl::Syntax::Methods

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  #

  if Rails.env.test? || Rails.env.cucumber?
    CarrierWave.configure do |config|
      config.storage = :file
      config.enable_processing = false
    end
  end

  def load_fixture(filename)
    File.read(File.expand_path(File.join(File.dirname(__FILE__), 'http_fixtures', filename)))
  end

  setup do
    DatabaseCleaner.start
    stub_request(:get, "https://graph.facebook.com/1234567").
      to_return(load_fixture('fb-graph.txt'))

    stub_request(:get, "https://graph.facebook.com/1234567/friends").
      to_return(load_fixture('fb-graph-friends.txt'))

    stub_request(:get, "http://graph.facebook.com/1234567/picture?type=square").
      to_return(load_fixture('fb-graph-picture.txt'))

    stub_request(:get, %r{maps.googleapis.com/maps/api/geocode/json}).
      to_return(load_fixture('googleapis-maps-geocode.txt'))

    stub_request(:get, "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn2/v/t1.0-1/p50x50/1472900_10152120195869009_1655568451_t.jpg?__gda__=1405380711_d55ce6e8e083979bf2719eecc5b72567&oe=53D08165&oh=815028b277911e80e0e4543231b54a8f").
      to_return(load_fixture('fb-graph-image.txt'))

    stub_request(:get, "http://example.com/image.jpg").
      to_return(load_fixture('fb-graph-image.txt'))

    stub_request(:get, "http://example.com/image_normal.jpg").
      to_return(load_fixture('fb-graph-image.txt'))

    stub_request(:get, "http://example.com/").
      to_return(:status => 200, :body => "", :headers => {'Content-Type' => 'text/html'})

    stub_request(:get, "http://example.com/file.pdf").
      to_return(:status => 200, :body => "", :headers => {'Content-Type' => 'application/pdf'})

    stub_request(:get, %r{api.datamarket.azure.com/Bing/Search/v1/Composite}).
      to_return(load_fixture('bing-api.json'))

    stub_request(:get, "http://guides.rubyonrails.org/testing.html").
      to_return(:status => 200, :body => "", :headers => {'Content-Type' => 'text/html'})

    FactoryGirl.lint
  end

  teardown do
    DatabaseCleaner.clean
  end
end