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
class Link < ActiveRecord::Base
  attr_accessible :url, :accessed_count, :last_accessed
  validates :url, uniqueness: true, format: {with: URI::regexp(%w(http https))}
  
  def short_url; self.id.to_s(36); end

  def link
    if Rails.env.development?
      "/links/#{short_url}"
    else
      "#{ENV['CURRENT_APP_URL']}/links/#{short_url}"
    end
  end
  
  scope :by_short_url, lambda{|url| where(id: url.to_i(36))}
  
  set_callback(:find, :after) do |doc|
    count = (doc.accessed_count || 0) + 1
    doc.update_attributes(accessed_count: count, last_accessed: Time.now)
  end
end