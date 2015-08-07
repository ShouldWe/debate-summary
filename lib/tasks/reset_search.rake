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
task :reset_search => :environment do
  time = Time.now
  puts "Welcome to Debate Summary"
  puts "Experimental Search Re-indexer (slow)\n\n"
  puts "Deleting old index"
  PgSearch::Document.delete_all
  puts "Index has been reset"
  puts "Rebuilding Documents..."
  i = 0
  Issue.find_each{ |issue| issue.update_pg_search_document; i = i + 1 }
  puts "Rebuilt #{i} Issues"
  puts "All done in #{Time.now - time} seconds"
end
