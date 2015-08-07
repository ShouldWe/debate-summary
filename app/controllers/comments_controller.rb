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
class CommentsController < ApplicationController
  before_filter :authenticate_user!
#   Straightforward comment code for use on Hitsory and Statement pages
  def create
    if params[:issue_id]
      @issue = Issue.find params[:issue_id] 
      @comment = @issue.issue_comments.new params[:comment]
      @comment.commentable_id = @issue.id
      @comment.commentable_type = @issue.class.to_s
    elsif params[:activity_id]
      @activity = Activity.find params[:activity_id]
      @comment = @activity.comments.new params[:comment]
      @comment.commentable_id = @activity.id
      @comment.commentable_type = @activity.class.to_s
    end

    @home_object = @issue || @activity
    @comment.user = current_user

    if @comment.save
      if @comment.commentable.class == Issue
        current_user.activities.create(issue: @issue, recordable: @comment, activity_type:'Comment')
      end
      redirect_to @home_object
    else
      # There's a better way to do this, but it would involve updating a few things and testing them again
      if @issue
        @url = issue_comments_path(@issue)
      elsif @activity
        @url = activity_comments_path(@activity)
      end
      render 'new'
    end
  end
end