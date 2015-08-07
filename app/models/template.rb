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
class Template < ActiveRecord::Base
  attr_accessible :content, :slug, :title
  serialize :compiled
  
  extend FriendlyId
  friendly_id :title, use: [:slugged]

  set_callback(:save, :before) do |doc|
    doc.compiled = Liquid::Template.parse(doc.content)
  end
  
  def liquid
    self.compiled
  end
  
  
  
  class << self
    def recompile
      find_each do |temp|
        temp.compiled = Liquid::Template.parse(temp.content)
        temp.save
      end
    end
  end
end