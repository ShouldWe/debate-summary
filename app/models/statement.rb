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
class Statement < ActiveRecord::Base
  belongs_to :statementable, polymorphic: true

  has_many :proposed_edits, as: :editable
  
  # acts_as_list scope: [:statementable_id, :statementable_type]
  attr_accessible :name, :body, :source, :new_paragraph, :image, 
    :statementable_id, :statementable_type, :user_id, :issue_id

  has_paper_trail

  before_validation :cache_issue_id

  mount_uploader :image, ImageUploader

  scope :with_image, where("image IS NOT NULL")
  scope :without_image, where(:image => nil)

  def parent_issue_id
    if self.statementable.class == Issue
      self.statementable.id
    else
      self.statementable.try(:issue_id)
    end
  end

private

  def cache_issue_id
    self.issue_id = self.parent_issue_id
  end
end