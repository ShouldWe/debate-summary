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
ActiveAdmin.register_page 'Broken Links' do
  menu parent: 'Link Health'

  content title: "Link Health" do
    columns do
      column do
        panel "Broken links" do
          render 'broken', items: LinkHealth.broken.page(params[:page])
        end
      end
    end
  end
end

ActiveAdmin.register_page 'Issues with broken Links' do
  menu parent: 'Link Health'

  content title: "Broken Issues" do
    columns do
      column do
        panel "Issues with broken links" do
          render 'broken_issues', issues: Issue.with_broken_links.page(params[:page])
        end
      end
    end
  end
end

ActiveAdmin.register_page 'Duplicate Links' do
  menu parent: 'Link Health'

  content title: "Link Health" do
    columns do
      column do
        panel "Duplicate links" do
          render 'duplicate', items: LinkHealth.duplicate_links.page(params[:page])
        end
      end
    end
  end
end

ActiveAdmin.register_page 'Stats' do
  menu parent: 'Link Health'

  content title: 'Stats' do
    columns do
      column do
        panel "MimeTypes" do
          render 'controlpanel/link_health/mime_table', items: LinkHealth.mime_types
        end
      end

      column do
        panel "Stats" do
          render 'controlpanel/link_health/stats_table'
        end
      end
    end
  end
end