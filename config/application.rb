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
require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  # DAN Changed in order to fix JS problem compiling on Heroku
  # Bundler.require(*Rails.groups(:assets => %w(development test)))
  Bundler.require *Rails.groups(:assets)
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module DebateSummary
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    # config.autoload_paths += %W(#{config.root}/uploaders)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    config.exceptions_app = self.routes

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'London'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    I18n.enforce_available_locales = false

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.initialize_on_precompile = false

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.1'

    config.assets.precompile += %w(modernizr.min.js respond.js)
    config.assets.precompile += %w( bootstrap.css jquery.fancybox.css home.css chosen.css)
    config.assets.precompile += %w( active_admin.css active_admin.js active_admin/print.css home/home.js )
    config.assets.precompile += %w( email.css )
    config.assets.precompile += %w( errors.css errors.js )
    config.assets.precompile += %w( pdf.css )
    config.assets.css_compressor = :yui
    config.assets.js_compressor = Uglifier.new(:mangle => true, :toplevel => true, :copyright => true)

    # SSL - don't need it in development mode, so set to false and then override in Staging and Production
    config.force_ssl = false

    # How many comments do we want to show by default
    config.number_of_comments_to_show = 2

    # How many connections make user self-endorsed
    config.number_of_connections_for_self_endorsement = 50

    # Number of days in which rule break reports should be voted in
    config.rule_break_reports_voting_deadline_in_days = 7

    # Allow HTML tags which are not already in the whitelist.
    config.action_view.sanitized_allowed_tags = %W(u)
    config.action_view.sanitized_allowed_attributes = %w(title name href)
    config.action_view.sanitized_allowed_protocols = 'tel', 'mailto'

    # Voting on issue titles #

    config.voting_on_titles_max_visits_for_suggesting   = 2
    config.voting_on_titles_max_visits_for_voting       = 5
    config.voting_on_titles_max_time_for_voting_in_days = 1

    ActionMailer::Base.default(
      charset: "utf-8",
      from: "Debate Summary <noreply@debatesummary.com>"
    )
    config.after_initialize do
      Rails.application.routes.default_url_options = config.action_mailer.default_url_options
    end
  end
end
