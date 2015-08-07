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
class CreateInternalRelations < ActiveRecord::Migration
  class Issue < ::Issue
    has_many :issue_links
  end
  def up
    create_table :internal_relations do |t|
      t.integer :issue_id, null: false
      t.integer :related_issue_id, null: false
    end

    CreateInternalRelations::Issue.find_each do |issue|
      issue.issue_links.each do |link|
        begin
          related = link.resource_linked_to
          issue.issues << related
          puts "Successfully migrated Related Issue #{link.id}"
        rescue
          puts "Failed to migrate Related Issue #{link.id}"
        end
      end
    end

  end

  def down
    drop_table :internal_relations
  end
end