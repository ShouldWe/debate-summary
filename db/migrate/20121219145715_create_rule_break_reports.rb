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
class CreateRuleBreakReports < ActiveRecord::Migration
  def self.up
    create_table :rule_break_reports, :force => true do |t|

      t.integer    :seriousness
      t.text       :message

      t.references :house_rule
      t.references :reportable, :polymorphic => true, :null => false
      t.references :reporter,   :polymorphic => true
      t.timestamps

    end

    add_index :rule_break_reports, [:reporter_id, :reporter_type]
    add_index :rule_break_reports, [:reportable_id, :reportable_type]


    # Comment out the line below to allow multiple votes per voter on a single entity.
    add_index :rule_break_reports, [:reporter_id, :reporter_type, :reportable_id, :reportable_type], :unique => true, :name => 'fk_one_report_per_user_per_entity'

  end

  def self.down
    drop_table :rule_break_reports
  end
end