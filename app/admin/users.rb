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
ActiveAdmin.register User do
  
  scope :online
  scope :offline
  
  filter :name
  filter :email
  filter :created_at
  
  index do
    id_column
    column :name
    column :email
    column :created_at
    column("Roles"){|user| user.is_admin? ? status_tag("Admin") : nil }
    default_actions
  end
  
  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :bio_headline
      # make changes in users.js.coffee
      f.input :bio, as: :text, config: {height: '400px'}, label: false, input_html: {class: 'wysiwyg'}
      f.input :admin
      f.input :monitors
    end
    f.buttons
  end
  
  show :title => :name do
    panel (user.bio_headline ? user.bio_headline : "NO INFO ENTERED") do
      div (user.bio ? user.bio.html_safe : "NO BIO ENTERED")
    end
    panel "Latest Browsing" do
      table_for user.last_visits(10) do
        column :title do |visit| 
          link_to visit.visitable.title, controlpanel_issue_path(visit.visitable)
        end
        column "Latest visit at" do |visit|
          visit.updated_at.strftime("%B %-d, %Y at %k:%M")
        end
      end
    end
    active_admin_comments
  end
  
  sidebar "User Details", only: :show do
    attributes_table_for user, :name, :email, :bio_headline, :current_sign_in_at, :city, :country, :monitors
  end
  
  sidebar "Considerations" do
    render('/admin/sidebar_links', model: 'users')
  end
end