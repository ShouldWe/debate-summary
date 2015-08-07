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
class Page < ActiveRecord::Base
  attr_accessible :compiled, :markdown, :permalink, :published, :title
  
  has_paper_trail skip: [:compiled]
  
  extend FriendlyId
  friendly_id :title, use: [:slugged], slug_column: :permalink
  
  scope :published, where(published: true)
  scope :draft, where(published: false)
  
  def content
    markdown.html_safe
  end
  
  def last_editor
    User.find versions.last.try(:whodunnit)
  rescue
    OpenStruct.new {}
  end
  
end