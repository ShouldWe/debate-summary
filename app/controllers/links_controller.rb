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
require 'open_uri_redirections'
class LinksController < ApplicationController
  layout false

  def show
    @link = Link.by_short_url(params[:id]).first.url
    @content_type = link_content_type(@link)
  rescue
    redirect_to :root, notice: "Sorry, we couldn't find that Link."
  end
  
  def index
    @link = params[:link]
    @content_type = link_content_type(@link)
    render :show
  end

  private
  def link_content_type(uri)
    open(uri, :allow_redirections => :all).content_type
  rescue OpenSSL::SSL::SSLError, Errno::ECONNREFUSED, Errno::ETIMEDOUT
    return "application/octet-stream"
  end

end