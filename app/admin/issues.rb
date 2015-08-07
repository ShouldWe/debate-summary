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
# coding: utf-8
ActiveAdmin.register Issue do

  filter :title
  filter :user
  filter :updated_at
  filter :created_at

  index do
    column :id
    column :title
    column 'Identifier' do |issue|
      issue.slug.present? ? issue.slug : issue.uuid
    end
    column 'Creator' do |issue|
      begin
        link_to issue.user.try(:name), controlpanel_user_path(issue.user)
      rescue
        link_to 'Unknown', '#'
      end
    end
    column :updated_at
    column :created_at
    default_actions
  end

  action_item only: :show do
    link_to('Edit Slug', edit_slug_controlpanel_issue_path(issue))
  end

  show title: :title do
    attributes_table do
      row :title
      row 'Identifier' do |issue|
        if issue.slug.present?
          title = issue.slug
        else
          title = "#{issue.id} #{issue.friendly_id} #{issue.slug} (Slug not set)"
        end

        link_to title, issue, target: '_blank'
      end
      row 'Creator' do |issue|
        begin
          link_to issue.user.name, controlpanel_user_path(issue.user)
        rescue
          link_to 'Unknown', '#'
        end
      end
      row 'Contributors' do |issue|
        render 'contributors', contribs: issue.contributors
      end
    end

    panel 'Visitors' do
      table_for issue.visitors do
        if issue.visitors.size > 0 && defined?(visitor)
          column :name do |visitor|
            link_to visitor.name, controlpanel_user_path(visitor)
          end
          column 'First Visit' do |visitor|
            pretty_format visitor.visit_detail(issue).created_at
          end
          column 'Latest Visit' do |visitor|
            pretty_format visitor.visit_detail(issue).updated_at
          end
          column 'Total Visits' do |visitor|
            visitor.visit_detail(issue).total_visits
          end
          column 'Last visited from' do |visitor|
            visitor_detail = []
            visitor_detail << visitor.visit_detail(issue).city
            visitor_detail << visitor.visit_detail(issue).country
            visitor_detail.join(', ')
          end
        else
          para 'No visitors yet'
        end
      end
    end
  end

  sidebar 'Issue Stats', only: :show do
    attributes_table_for issue, :total_impressions, :total_unique_visitors,
                         :last_visited_at
  end

  form do |f|
    f.inputs 'Issues' do
      f.input :title
    end
    f.buttons
  end

  member_action :edit_slug do
    @issue = Issue.find(params[:id])
  end

  member_action :set_slug, method: :put do
    @issue = Issue.find(params[:id])
    @issue.tmp_slug = params[:issue][:tmp_slug]
    if params[:issue][:overwrite_slug] == '1'
      @issue.generate_friendly_id = true
      if @issue.save
        flash[:notice] = "Successfully changed slug"
      else
        flash[:error] = "Failed to change slug, this is because the Page is not 100% valid. Please <a href=\"#{edit_issue_path(@issue.id)}\">Go and Fix</a> any validations before setting a slug.".html_safe
        return redirect_to edit_slug_controlpanel_issue_path(@issue.id)
      end
    end
    redirect_to([:controlpanel, @issue])
  end

end

ActiveAdmin.register_page('Invalid Issues') do
  menu(parent: 'Issues')

  content(title: 'Invalid Issues') do
    para 'The following issues will fail to be saved.'
    table_for Issue.all_invalid do |issue|
      column(:title) do |issue|
        link_to(issue.title, edit_issue_path(issue))
      end
      column(:errors) do |issue|
        issue.valid?
        errors = []
        errors << issue.errors.full_messages
        errors << 'Contains broken link(s)' if issue.broken_shas.any?
        errors.flatten.to_sentence
      end
      column(:severity) do |issue|
        if issue.valid?
          %Q{<span style="background-color: yellow; width: 10px; height: 10px; display:inline-block;"></span>}.html_safe
        else
          %Q{<span style="background-color: red; width: 10px; height: 10px; display:inline-block;"></span>}.html_safe
        end
      end
    end
  end
end