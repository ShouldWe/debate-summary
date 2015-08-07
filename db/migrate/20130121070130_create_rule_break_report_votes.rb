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
class CreateRuleBreakReportVotes < ActiveRecord::Migration
  def change
    create_table :rule_break_report_votes do |t|
      t.references :user
      t.references :penalty
      t.references :rule_break_report
      t.boolean :apply_unilaterally

      t.timestamps
    end
    add_index :rule_break_report_votes, :user_id
    add_index :rule_break_report_votes, :penalty_id
    add_index :rule_break_report_votes, :rule_break_report_id
  end
end