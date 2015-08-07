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
class AddFacebookAndTwitterTokensToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_uid, :integer
    add_column :users, :facebook_token, :string
    add_column :users, :facebook_token_expires_at, :integer
    
    add_column :users, :twitter_uid, :integer
    add_column :users, :twitter_token, :string
    add_column :users, :twitter_token_secret, :string
    add_column :users, :twitter_token_expires_at, :integer

    add_column :users, :facebook_info, :text
    add_column :users, :twitter_info, :text

    add_column :users, :facebook_friend_count, :integer
    add_column :users, :twitter_follower_count, :integer
  end
end