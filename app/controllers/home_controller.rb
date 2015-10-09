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
class HomeController < ApplicationController
  # Home page code for trending topics and tags
  layout 'home'
  HOME_PAGE_DIRECTORY_TAGS = [
    'Constitution & Government',
    'Culture',
    'Defence',
    'Economy & Business',
    'Education & Skills',
    'Energy & Environment',
    'Foreign Affairs',
    'Health',
    'Local Government & the Regions',
    'Social Issues & Justice',
    'Transport',
    'Miscellaneous'
  ]

  def index
    @help_us = Template.find('help-us').liquid
    @trending_topics = Issue.trending
    @trending_tags = Issue.trending_tags
    @left_entries = sliced_entries[0]
    @right_entries = sliced_entries[1]
  end

  def show
    @page = Page.find_by_permalink!(params[:id])
    @content = Kramdown::Document.new(@page.markdown).to_html
    render template: 'home/homeother', layout: 'layouts/application'
  end

  private

  def sliced_entries
    directory = []
    HOME_PAGE_DIRECTORY_TAGS.each do |tag_string|
      directory << Struct.new(:tags, :issues, :tag_count).new.tap do |dir_entry|
        dir_entry.tags = tag_string
        dir_entry.issues = Issue.by_tag_string tag_string
        dir_entry.tag_count = Issue.count_by_tag_string(tag_string)
      end
    end
    directory.each_slice(directory.length / 2).to_a
  end
end
