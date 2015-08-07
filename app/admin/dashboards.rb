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
ActiveAdmin.register_page 'Dashboard' do
  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content title: "Dashboard" do
    columns do
      column do
        panel "Recent Active Issues" do
          table_for Issue.order('updated_at desc').limit(10).each do |issue|
            column(:title)    {|issue| link_to(issue.title, controlpanel_issue_path(issue))}
          end
        end
      end

      column do
        panel "Recent Active Users" do
          table_for User.order('updated_at desc').limit(10).each do |user|
            column(:name)    {|user| link_to(user.name, controlpanel_user_path(user)) }
            column("Last seen")    {|user| pretty_format user.last_seen_at }
          end
        end
      end


      column do
        panel(link_to('Link Stats', controlpanel_stats_path)) do
          render 'controlpanel/link_health/stats_table'
        end

        panel(link_to('Invalid Issues',controlpanel_invalid_issues_path)) do
          para 'The following issues will fail to be saved.'
          table_for Issue.all_invalid do |issue|
            column(:title) do |issue|
              link_to(issue.title, edit_issue_path(issue))
            end
          end
        end

      end

    end
  end
end