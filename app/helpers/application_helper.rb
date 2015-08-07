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
module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields($(this))")
  end

  # def link_to_add_fields(name, f, association)
  #   new_object = f.object.class.reflect_on_association(association).klass.new
  #   fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
  #     render(association.to_s.singularize + "_fields", :f => builder)
  #   end
  #   link_to_function(name, "add_fields($(this), \"#{association}\", \"#{escape_javascript(fields)}\")")
  # end

  def kramdown(text)
    if text
      sanitize(Kramdown::Document.new(text).to_html)
    end
  end
  alias_method :markdown, :kramdown

  def javascript_include_tag(*sources)
    options = sources.extract_options!.stringify_keys
    if options.has_key?('async')
      unless DebateSummary::Application.config.assets.debug == true
        options.merge('defer' => 'defer')
      else
        options.delete 'async'
        options.delete 'defer'
      end
    end
    super(*sources,options)
  end

  # Crazy time here, on link_to that require authentication
  # forcing this ID if not authenticated means that it will pop
  # the modal dialog to log in
  def force_login_dialog_id
    if user_signed_in?
      ""
    else
      "loginLink"
    end
  end

  def full_url(url)
    host = ActionMailer::Base.asset_host
    if not host and ActionMailer::Base.default_url_options.any?
      host = ActionMailer::Base.default_url_options[:protocol] || 'http://'
      host += ActionMailer::Base.default_url_options[:host]
    end

    return URI.join(host, url).to_s if host
  end
end

module DeviseHelper
  def devise_error_messages_bootstrap!
    if resource.errors.any?
      msg = "<div class=\"alert\">"
      msg += "<h4 class=\"alert-heading\">Warning!</h4>"
      # msg += "<button class=\"close\" data-dismiss=\"alert\">x</button>"
      msg += resource.errors.full_messages.join('<br />')
      # msg += resource.errors.full_messages.map { |msg| content_tag(:p, msg) }.join
      msg += "</div>"
    end
  end
end