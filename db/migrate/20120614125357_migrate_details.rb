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
class MigrateDetails < ActiveRecord::Migration
  def up
    Issue.all.each do |issue|
      issue.issue_fors.each do |i|
        attribs = i.attributes
        attribs.delete("id")
        attribs.delete("created_at")
        attribs.delete("updated_at")
        detail = issue.detail_fors.create(attribs)

        i.statements.each do |statement|
          attribs = statement.attributes
          attribs.delete("id")
          attribs.delete("created_at")
          attribs.delete("updated_at")
          detail.statements.create(attribs)
        end
      end

      issue.issue_againsts.each do |i|
        attribs = i.attributes
        attribs.delete("id")
        attribs.delete("created_at")
        attribs.delete("updated_at")
        detail = issue.detail_againsts.create(attribs)

        i.statements.each do |statement|
          attribs = statement.attributes
          attribs.delete("id")
          attribs.delete("created_at")
          attribs.delete("updated_at")
          detail.statements.create(attribs)
        end
      end

      issue.issue_alternatives.each do |i|
        attribs = i.attributes
        attribs.delete("id")
        attribs.delete("created_at")
        attribs.delete("updated_at")
        detail = issue.detail_alternatives.create(attribs)

        i.statements.each do |statement|
          attribs = statement.attributes
          attribs.delete("id")
          attribs.delete("created_at")
          attribs.delete("updated_at")
          detail.statements.create(attribs)
        end
      end

      issue.issue_data.each do |i|
        attribs = i.attributes
        attribs.delete("id")
        attribs.delete("created_at")
        attribs.delete("updated_at")
        detail = issue.detail_data.create(attribs)

        i.statements.each do |statement|
          attribs = statement.attributes
          attribs.delete("id")
          attribs.delete("created_at")
          attribs.delete("updated_at")
          detail.statements.create(attribs)
        end
      end

    end

    drop_table :issue_fors
    drop_table :issue_againsts
    drop_table :issue_alternatives
    drop_table :issue_data
  end

  def down
  end
end