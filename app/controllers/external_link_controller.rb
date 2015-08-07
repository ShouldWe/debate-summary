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
class ExternalLinkController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :list]
  after_filter :process_visit, only: [:show]

  layout "external_link"

  def show
    @link = LinkHealth.where("sha LIKE ? ", "%#{params[:id]}%").select{|m| m.sha.include?(params[:id]) }.first
    raise ActiveRecord::RecordNotFound unless @link
  end

  private

  def process_visit
    if current_user
      current_user.visit(@link, ip_address: request.ip.to_s)
    else
      Visit.first_or_create(visitable_id: @link.id, visitable_type: @link.class.to_s, ip_address: request.ip)
    end
  end
end