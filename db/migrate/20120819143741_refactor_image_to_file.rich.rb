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
# This migration comes from rich (originally 20111201095829)
class RefactorImageToFile < ActiveRecord::Migration
  def change
    rename_table :rich_rich_images, :rich_rich_files

    rename_column :rich_rich_files, :image_file_name, :rich_file_file_name
    rename_column :rich_rich_files, :image_content_type, :rich_file_content_type
    rename_column :rich_rich_files, :image_file_size, :rich_file_file_size
    rename_column :rich_rich_files, :image_updated_at, :rich_file_updated_at

    add_column :rich_rich_files, :simplified_type, :string, :default => "file"
  end
end