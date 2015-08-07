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
source 'https://rubygems.org'
# ruby '2.1.2'

gem 'rails', '3.2.19' # 3.2.18 newer
gem 'rails_autolink'
gem 'rabl-rails'

gem 'pg'
gem 'pg_search'

gem 'geocoder'
gem 'liquid'

gem 'json'
gem 'passenger'

gem 'dalli'

gem 'draper'

gem 'pjax_rails'

#scheduling
gem 'clockwork'
gem 'psych'

# QUEUE
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'sidekiq'

# ADMIN GEMS
gem 'activeadmin', github: 'gregbell/active_admin', tag: 'v0.6.2'
gem 'sass-rails'
gem 'meta_search', '>= 1.1.0.pre'

# Infrastructure Gems
gem 'hogan_assets'
gem 'rails3-jquery-autocomplete'
gem 'cocoon'
gem 'font-awesome-rails'
gem "autoprefixer-rails"

group :assets do
  gem 'coffee-rails' #, '~> 3.2.1'
  gem 'uglifier'
  gem 'yui-compressor'
  gem 'twitter-bootstrap-rails'#, github: 'jgwmaxwell/twitter-bootstrap-rails'
  gem 'less-rails'
  gem 'jquery-rails'
  gem 'therubyracer'
  gem 'turbo-sprockets-rails3'
end

group :development do
  gem 'copyright-header'
  gem 'sextant'
  gem 'api_taster'
  gem 'quiet_assets'
  gem 'foreman'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'systemu'
  gem 'invoker'
  # gem 'capistrano-rails'
  # gem 'capistrano-sidekiq'
end

group :test do
  gem "database_cleaner", ">= 0.7.1"
  gem "launchy", ">= 2.0.5"
  gem 'webmock'
  gem 'ruby-prof'
end

group :development, :test do
  # gem 'turn'
  gem 'factory_girl_rails'
  gem 'ci_reporter_test_unit'
end

group :test, :development, :staging do
  gem 'better_logging'
end

gem 'friendly_id', '~> 4.0'
gem 'carrierwave'
gem 'mini_magick'
gem 'simple_form'
gem 'kaminari'
gem 'htmlentities'
gem 'aasm'
gem 'awesome_nested_set'
gem 'kramdown'
gem 'redcarpet'

gem 'oj'
gem 'devise'
gem 'fb_graph'
gem 'omniauth'
# gem 'omniauth-oauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-linkedin'

gem 'paper_trail'
gem 'acts-as-taggable-on', '~> 2.2.2'
gem 'acts_as_list', github: 'swanandp/acts_as_list'

gem 'nokogiri'
gem 'sanitize'
gem 'premailer-rails'
gem 'differ'

gem 'open_uri_redirections'

gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
