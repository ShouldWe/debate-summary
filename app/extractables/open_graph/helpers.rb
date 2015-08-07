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
module OpenGraph
  module Helpers
    include ActionView::Helpers::SanitizeHelper
    
    # The set of special characters and their escaped values
    TABLE_FOR_ESCAPE_HTML__ = {
     	 "'" => '&#x27;',
     	 '&' => '&amp;',
     	 '"' => '&quot;',
     	 '<' => '&lt;',
     	 '>' => '&gt;',
     }
    
    
    def self.included(klass)
      klass.send :helper_method, :opengraph_meta_tags
    end
    
    def opengraph_meta_tags
      output = ""
      if params[:controller] == "issues" && params[:action] == "show"
        if @issue.opengraph
          ['title', 'description', 'image', 'type'].each do |meta|
            output << "<meta property='og:#{meta}' content='#{@issue.opengraph.send(meta).gsub(/['&\"<>]/, TABLE_FOR_ESCAPE_HTML__)}'>" unless @issue.opengraph.send(meta).nil?
          end
        end
      end
      output.html_safe
    end
  end
end