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
class Comment < ActiveRecord::Base
  attr_accessible :body, :activity, :issue, :parent_id, :proposed_edit, :proposed_edit_id, :issue_id, :parent_id, :commentable_id, :commentable_type
  belongs_to :user
  belongs_to :issue
  belongs_to :proposed_edit
  belongs_to :activity
  acts_as_nested_set

  has_many :activities, as: :recordable

  belongs_to :commentable, polymorphic: true

  scope :issue_comments, where(:proposed_edit_id => nil)
  scope :edit_comments, where("comments.proposed_edit_id IS NOT NULL")

  validates :body, presence: true, length: { :minimum => 2 }

  def get_user
    user || User.new
  end
end