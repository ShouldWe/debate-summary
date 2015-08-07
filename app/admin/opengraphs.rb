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
ActiveAdmin.register Opengraph do
  
  menu parent: "Issues"
  
  show title: "OpenGraph details" do
    attributes_table do
      row :title
      row :type
      row :description
      row :opengraphable
    end
  end
  
  form do |f|
    f.inputs "Details" do
      f.input :opengraphable, collection: Issue.without_opengraph_data
      f.input :title
      f.input :description, as: :text
      f.input :opengraphable_type, as: :hidden, value: "Issue"
    end
    f.buttons
  end

end