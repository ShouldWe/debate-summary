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
require 'active_support/concern'
module HTMLPunctuationCleanup
  require 'active_support/concern'

  def self.included(base)
    base.class_eval do
      before_validation :clean_punctuation
    end
  end

  def clean_punctuation
    if body
      self.body = body.gsub('&nbsp;',' ')
      self.body = body.gsub(%r{</a>(\s*)(\.|,|\?)?(\s*)}, '\2\1\3</a>')
    end
  end
end