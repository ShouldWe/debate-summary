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
ActiveAdmin.register Page do
  menu parent: "Administration"
  scope :published
  scope :draft
  
  filter :title
  filter :permalink
  filter :published
  filter :updated_at
  filter :created_at
  
  index do
    column :title
    column :permalink
    column :published
    column "Last Editor" do |page|
      page.last_editor.name
    end
    column :updated_at
    column :created_at
    default_actions
  end
  
  show title: :title do
    div Kramdown::Document.new(page.content).to_html.html_safe
  end
  
  form do |f|
    f.inputs "Pages" do
      f.input :title
      f.input :markdown, as: :text, config: {height: '400px'}, label: false,
        hint: 'It is recommended to use <a href="http://daringfireball.net/projects/markdown/basic">Markdown</a> by HTML is also<D-r> accepted'.html_safe
      f.input :published
    end
    f.actions
  end
  
end