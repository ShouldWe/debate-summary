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
class IssueTitlesController < ApplicationController
  before_filter :authenticate_user!
#   Suggest a new title for an existing issue
  def suggest
    title = current_user.suggested_issue_titles.build(params[:issue_title])
    respond_to do |format|
      if title.issue.can_suggest_title?
        if title.save!
          format.json{ render json: title }
        else
          format.json{ render json: title.errors }
        end
      else
        format.json{ render json: {message: "Sorry, this Issue is locked."}, status: 402}
      end
    end
  end
# Vote on issue title
  def vote
    title = IssueTitle.find(params[:id])
    respond_to do |format|
      if current_user.voted_for_any_issue_titles?(title.issue)
        format.json{ render json: {error: "You have already voted for this Issue."}, status: 402}
      else
        current_user.vote_for_issue_title(title)
        titles = title.issue.suggested_titles.all
        output = titles.to_json(only: [:id, :title], methods: [:current_score])
        format.json{ render json: output}
      end
    end
  end
end