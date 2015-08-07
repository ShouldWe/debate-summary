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
ActiveAdmin.register Template do
  
  index do
    column :title
    column :content
    default_actions
  end
  
  form do |form|
    form.inputs do
      form.input :title
      form.input :content, as: :text
    end
    
    form.actions do
      form.submit
    end
  end
  
  show do
    attributes_table do
      row :title
      row :content
    end
  end
  
  
  sidebar "Help", only: [:new, :edit] do
    para "These are the templates that we use to send emails to our users when they do certain actions on our website."
    para "For the most part, it is best to avoid altering them, but if you need to change something, you have access to some special commands to access the user information in the message."
    para "These commands are described below"
  end
  
  sidebar "User Data", only: [:new, :edit] do
    dl do
      dt "{{user.name}}"
      dd "prints the user's full name"
      dt "{{user.first_name}}"
      dd "just the user's first name"
      dt "{{user.last_name}}"
      dd "just the user's last name"
      dt "{{user.email}}"
      dd "the user's email address"
      dt "{{user.profile_url}}"
      dd "the permalink to this user's profile page"
      dt "{{user.edit_profile_url}}"
      dd "the permalink to the edit page for this user"
    end
  end
  
  sidebar "Issue Data", only: [:new, :edit] do
    dl do
      dt "{{issue.title}}"
      dd "the title of the issue"
      dt "{{issue.url}}"
      dd "the permalink to access the issue, including domain"
    end
  end
  
  sidebar "Site Data", only: [:new, :edit] do
    dl do
      dt "{{site.url}}"
      dd "the permalink to access the index page of the site"
      dt "{{site.login_url}}"
      dd "the permalink to log in to the site"
    end
  end

end