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
require 'nokogiri'
class HyperLinkContentValidator < ActiveModel::EachValidator
  def validate_each(record, attribtue, value)
    hyper_links = Nokogiri::HTML::fragment(value).css('a').text.strip.gsub(/\s/,'')
    all_text = Nokogiri::HTML::fragment(value).text.strip.gsub(/\s/,'')

    unless hyper_links.size == all_text.size
      record.errors.add(attribtue, :missing_hyper_link_content)
    end
  end
end