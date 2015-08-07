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
class SiteMapController < ApplicationController
  respond_to :xml, :text
  caches_page :robots
  def index
    @pages  = Page.select([:updated_at, :permalink, :id]).all
    @issues = Issue.select([:updated_at, :slug, :id]).all
    @users  = User.select([:updated_at, :slug, :id]).all

    fresh_when(etag: @issues, last_modified: Issue.maximum(:updated_at), public: true)
  end

  def robots
    expires_in 3.hours, public: true, must_revalidate: true
  end
end