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
  module ActsAsOpenGraph
    def self.included(klass)
      klass.class_eval "has_one :opengraph, as: :opengraphable, dependent: :destroy"
      klass.class_eval "scope :with_opengraph_data, joins(:opengraph)"
      klass.class_eval <<-EOS
        def self.without_opengraph_data
          ids = with_opengraph_data.pluck(table_name+'.id')
          if ids.size > 0
            where('id not in ?', ids)
          else
            where('id is not ?', ids)
          end
        end
      EOS
    end
  end
end