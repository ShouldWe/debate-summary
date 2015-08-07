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
class RuleBreakReportsHouseRules < ActiveRecord::Migration
  def change
    create_table :house_rules_rule_break_reports, id: false do |t|
      t.references :rule_break_report, null: false
      t.references :house_rule, null: false
    end

    add_index :house_rules_rule_break_reports, [:rule_break_report_id, :house_rule_id], unique: true, name: "house_rules_rule_break_reports_index"
  end
end
