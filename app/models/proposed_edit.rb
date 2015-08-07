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
class ProposedEdit < ActiveRecord::Base
  include AASM

  attr_accessible :editable, :statementable, :change_data, :detail_type, :detailable, :issue

  belongs_to :user
  belongs_to :issue
  belongs_to :closed_by, class_name: "User"

  has_many :activities, as: :recordable
  has_many :comments, as: :commentable

  belongs_to :editable, polymorphic: true

  scope :open, where("proposed_edits.aasm_state = 'accepted' or proposed_edits.aasm_state = 'rejected'")
  scope :closed, where("proposed_edits.aasm_state = 'new' or proposed_edits.aasm_state = 'pending'")



  aasm do
    state :new, initial: true
    state :rejected, enter: :notify_experts
    state :accepted, enter: :publish

    event :accept do
      transitions :to => :accepted, :from => :new
    end

    event :reject do
      transitions :to => :rejected, :from => :new
    end
  end

  def edit_detail
    YAML::load(self.change_data)
    #   {:type => "the title", :from => changes[0], :to => changes[1]}
  end

  def get_changed_data_to_be_displayed_to_the_user
    YAML::load(change_data).select { |k, v| ! (k =~ /detailable/i) && v[0] != v[1] && (! v[0].blank? || ! v[1].blank?) }
  rescue
    return []
  end

  def notify_experts
    
  end

  def publish
    if self.change_data.is_a? String
      change_data_hash = YAML::load(self.change_data)
    else
      change_data_hash = self.change_data
    end
    change_data_hash.delete_if {|k,v| k == 'detailable_id' || k == 'detailable_type'}
    changes = change_data_hash.collect {|k,v| {k => v[1]} }.reduce(:merge)
    begin
      self.editable.attributes = changes
      self.editable.detail_type = self.detail_type
    rescue
    end
    self.editable.save
  end

  def diffs_from_to
    a = !self.edit_detail[:body].blank? ? Detail.statements(self.edit_detail[:body][0]) : []
    b = !self.edit_detail[:body].blank? ? Detail.statements(self.edit_detail[:body][1]) : []
    
    # a = !p.edit_detail[:body].blank? ? Detail.statements(p.edit_detail[:body][0]) : []
    # b = !p.edit_detail[:body].blank? ? Detail.statements(p.edit_detail[:body][1]) : []

    diffs = []
    if b
      b.each_with_index do |e, i| 
        if a && a[i] && a[i][:content] != e[:content]
          diffs << { :from => a[i][:content], :to => e[:content] }
        end
      end
    end
    return diffs
  end

  def difference
    a = !self.edit_detail[:body].blank? ? Detail.statements(self.edit_detail[:body][0]) : []
    b = !self.edit_detail[:body].blank? ? Detail.statements(self.edit_detail[:body][1]) : []

    diff_strings = []

    if b
      b.each_with_index do |e, i| 
        Differ.format = :html
        if a && a[i]
          diff_strings << Differ.diff_by_char(e[:content], a[i][:content]) if a[i][:content] != e[:content] 
        else
          diff_strings << Differ.diff(e[:content], "")
        end
      end
    end
    diff_strings.join

    # if a && b
    #   a.each_with_index do |e, i| 
    #     Differ.format = :html
    #     return Differ.diff(b[i][:content], e[:content]) if b[i][:content] != e[:content] 
    #   end
    # end

    # orig_text = Sanitize.clean Detail.format_body(p.edit_detail[:body][0])[0]
    # new_text = Sanitize.clean Detail.format_body(p.edit_detail[:body][1])[0]
    # Differ.diff_by_word orig_text, new_text
  end
end