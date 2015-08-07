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
class RuleBreakReport < ActiveRecord::Base

  liquid_methods :penalty_name

  Seriousness = [
        'Not serious: a warning is fine',
        'Serious: this user should be excluded from commenting on this issue',
        'Very serious: this user should be excluded from this website',
  ]

  attr_accessible :message, :seriousness, :house_rule_ids, :reportable_id, :reporter_id

  belongs_to :reportable, :polymorphic => true
  belongs_to :reporter, :polymorphic => true

  has_and_belongs_to_many :house_rules
  accepts_nested_attributes_for :house_rules
  belongs_to :penalty
  delegate :name, to: :penalty, prefix: true, allow_nil: true

  has_many :rule_break_report_votes

  # Comment out the line below to allow multiple reports per user.
  validates_uniqueness_of :reportable_id, :scope => [:reportable_type, :reporter_type, :reporter_id]

  validates_presence_of :message, :seriousness, :house_rules

  after_create :add_create_comment_to_reportable
  after_destroy :add_destroy_comment_to_reportable
  after_update :add_comment_and_send_email_to_alleged_abuser_on_resolution

  default_scope -> { order('created_at DESC') }

  scope :unresolved, -> { where(resolved: false) }

  scope :voted, ->(user) { where('exists (select 1 from rule_break_report_votes rv where user_id = ? and rule_break_reports.id = rv.rule_break_report_id)', user.id) }

  scope :not_voted, ->(user) { where('not exists (select 1 from rule_break_report_votes rv where user_id = ? and rule_break_reports.id = rv.rule_break_report_id)', user.id) }

  scope :decision_due, -> { where('created_at < ?', DebateSummary::Application.config.rule_break_reports_voting_deadline_in_days.days.ago) }

  # I voted and it's not overdue OR it's resolved whatever
  scope :previous_votes, ->(user) { where('resolved = ? or (created_at > ? and exists (select 1 from rule_break_report_votes rv where user_id = ? and rule_break_reports.id = rv.rule_break_report_id))',
    true, DebateSummary::Application.config.rule_break_reports_voting_deadline_in_days.days.ago, user.id) }

  def user_voted?(user)
    ! rule_break_report_votes.where(user_id: user.id).empty?
  end

  def user_vote(user)
    rule_break_report_votes.where(user_id: user.id).first
  end

  def seriousness_text
    Seriousness[seriousness]
  end

  def sorted_rule_violations
    HouseRule.sort_rules house_rules
  end

  private

  def add_create_comment_to_reportable
    reportable.comments.create(:body => "This edit has been flagged as a breach of a following house rules: '#{house_rules.collect {|hr| hr.name}.join(', ')}'")
  end

  def add_destroy_comment_to_reportable
    reportable.comments.create(:body => 'Flag for this edit has been removed')
  end

  def add_comment_and_send_email_to_alleged_abuser_on_resolution
    if resolved_changed? && resolved?
      reportable.comments.create(:body => 'Decision about this flagged edit has been made')
      UserMailer.alleged_abuser_decision_made_email(reportable.user, self).deliver
    end
  end

end