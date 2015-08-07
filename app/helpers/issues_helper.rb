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
require 'uri'
require "base64"

module IssuesHelper

  def new_detail_link(opts={})
    return link_to "New argument", "#", class: "new-detail btn btn-blue", data: {detail_type: "#{opts[:type]}-argument"}
  end

  def detail_data(type)
    if type == "against"
      input = {
        data: {
          title_help_title: @contextualAgainstTitle.field_title,
          title_help_description: @contextualAgainstTitle.field_description,
          placeholder: @contextualAgainstTitle.placeholder,
          add_source_label: t('issues.form.add-source-label'),
          add_source_help: t('issues.form.add-source-help'),
          content_help_title: @contextualAgainst.field_title,
          content_help_description: @contextualAgainst.field_description,
          content_think_about: @contextualAgainst.think_about,
          detail_type: "detail_#{type}s",
          detail_role: "#{type}-argument"
        }
      }
    elsif type == "for"
        input = {
          data: {
            title_help_title: @contextualForTitle.field_title,
            title_help_description: @contextualForTitle.field_description,
            placeholder: @contextualForTitle.placeholder,
            add_source_label: t('issues.form.add-source-label'),
            add_source_help: t('issues.form.add-source-help'),
            content_help_title: @contextualFor.field_title,
            content_help_description: @contextualFor.field_description,
            content_think_about: @contextualFor.think_about,
            detail_type: "detail_#{type}s",
            detail_role: "#{type}-argument"
          }
        }
    elsif type == "alternative"
        input = {
          data: {
            title_help_title: @contextualAlternativeTitle.field_title,
            title_help_description: @contextualAlternativeTitle.field_description,
            placeholder: @contextualAlternativeTitle.placeholder,
            add_source_label: t('issues.form.add-source-label'),
            add_source_help: t('issues.form.add-source-help'),
            content_help_title: @contextualAlternative.field_title,
            content_help_description: @contextualAlternative.field_description,
            content_think_about: @contextualAlternative.think_about,
            detail_type: "detail_#{type}s",
            detail_role: "#{type}-argument"
          }
        }
    elsif type == "relevant"
        input = {
          data: {
              title_help_title: @contextualRelevantTitle.field_title,
              title_help_description: @contextualRelevantTitle.field_description,
              placeholder: @contextualRelevantTitle.placeholder,
              add_source_label: t('issues.form.add-source-label'),
              add_source_help: t('issues.form.add-source-help'),
              content_help_title: @contextualRelevant.field_title,
              content_help_description: @contextualRelevant.field_description,
              content_think_about: @contextualRelevant.think_about,
              detail_type: "detail_#{type}s",
              detail_role: "#{type}-argument"
          }
        }
    else
        input = {
          data: {
            title_help_title: t("issues.form.#{type}-help-title"),
            title_help_description: t("issues.form.#{type}-help-title-description"),
            placeholder: t('issues.form.placeholder'),
            add_source_label: t('issues.form.add-source-label'),
            add_source_help: t('issues.form.add-source-help'),
            content_help_title: t("issues.form.#{type}-help-title"),
            content_help_description: t("issues.form.#{type}-help-description"),
            content_think_about: t("issues.form.#{type}-help-thinkabout"),
            detail_type: "detail_#{type}s",
            detail_role: "#{type}-argument"
          }
        }
    end
    output = ""
    input.each do |term, hash|
      hash.each do |key, val|
        output << "#{term}-#{key.to_s.dasherize}='#{val}' "
      end
    end
    return output.strip.html_safe
  end

  def rating_box(issue)
    data_statement = {
      rateable_id: issue.id,
      rateable_type: issue.class.to_s,
      rateit_min: 0,
      rateit_max: 5,
      rateit_resetable: false,
      rateit_ispreset: true,
      rateit_value: issue.rating,
    }
    content_tag :div, "", class: "rateit", data: data_statement
  end

  def rating_stars_icons(rating)
    content_tag(:div) do
      if rating == 5
        5.times do
          concat content_tag :i, nil, class: 'fa fa-star'
        end
      elsif rating > 4 && rating < 5
        4.times do
          concat content_tag :i, nil, class: 'fa fa-star'
        end
        concat content_tag :i, nil, class: 'fa fa-star-half-o'
      elsif rating == 4
        4.times do
          concat content_tag :i, nil, class: 'fa fa-star'
        end
        concat content_tag :i, nil, class: 'fa fa-star-o'
      elsif rating > 3 && rating < 4
        3.times do
          concat content_tag :i, nil, class: 'fa fa-star'
        end
        concat content_tag :i, nil, class: 'fa fa-star-half-o'
        concat content_tag :i, nil, class: 'fa fa-star-o'
      elsif rating == 3
        3.times do
          concat content_tag :i, nil, class: 'fa fa-star'
        end
        concat content_tag :i, nil, class: 'fa fa-star-o'
        concat content_tag :i, nil, class: 'fa fa-star-o'
      elsif rating > 2 && rating < 3
        2.times do
          concat content_tag :i, nil, class: 'fa fa-star'
        end
        concat content_tag :i, nil, class: 'fa fa-star-half-o'
        concat content_tag :i, nil, class: 'fa fa-star-o'
        concat content_tag :i, nil, class: 'fa fa-star-o'
      elsif rating == 2
        concat content_tag :i, nil, class: 'fa fa-star'
        concat content_tag :i, nil, class: 'fa fa-star'
        3.times do
          concat content_tag :i, nil, class: 'fa fa-star-o'
        end
      elsif rating > 1 && rating < 2
        concat content_tag :i, nil, class: 'fa fa-star'
        concat content_tag :i, nil, class: 'fa fa-star-half-o'
        3.times do
          concat content_tag :i, nil, class: 'fa fa-star-o'
        end
      elsif rating == 1
        concat content_tag :i, nil, class: 'fa fa-star'
        4.times do
          concat content_tag :i, nil, class: 'fa fa-star-o'
        end
      elsif rating > 0 && rating < 1
        concat content_tag :i, nil, class: 'fa fa-star-half-o'
        4.times do
          concat content_tag :i, nil, class: 'fa fa-star-o'
        end
      elsif rating == 0
        5.times do
          concat content_tag :i, nil, class: 'fa fa-star-o'
        end
      end
    end
  end

  def comment_number(var)
    @count = 0
    @editId = ProposedEdit.where(:editable_id => var).first
    if @editId.present?
      @activityId = Activity.where(:proposed_edit_id => @editId.id).first
      if @activityId.present?
        @count = Comment.where(:commentable_id => @activityId.id).count
      end
    end
    output = @count
  end

  def view_external_links html
    raise html
  end
end
