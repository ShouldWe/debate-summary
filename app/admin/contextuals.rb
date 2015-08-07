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
ActiveAdmin.register Contextual do
  menu parent: "Administration"

  filter :title

  index do
    column :title
    column :field_description
    column :think_about
    column :field_title
    column :placeholder
    column :updated_at
    column :created_at
    default_actions
  end

  show do
    attributes_table do
      row :title
      row :field_description
      row :think_about
      row :field_title
      row :placeholder
    end
  end

  sidebar "Help", only: [:new, :edit] do
    para "This page allow you to change the text shown on the helper sidebar. This information is shown when I user clicks on a field in the Issue form or in the field it's self."
    para "Information about what each field represents on the site see the section below."
  end

  sidebar "Field Types", only: [:new, :edit] do
    dl do
      dt "Title"
      para "The title is the identification id that the system used to find this form. Do not change this unless told to by a developer."
      dt "Field description"
      para "This is the description that the user sees telling them what information they should enter."
      dt "Think about"
      para "A suggestion of what make a good entry."
      dt "Field title"
      para "The title of the page."
      dt "Placeholder"
      para "The grey text that is shown in the field if not text has been entered yet."
    end
  end


  form do |f|
    f.inputs "Contextual Help" do
      f.input :title
      f.input :field_description
      f.input :think_about
      f.input :field_title
      f.input :placeholder
    end
    f.buttons
  end

end