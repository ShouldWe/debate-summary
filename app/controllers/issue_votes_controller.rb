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
class IssueVotesController < ApplicationController

# Issue votes controller. Heart buttons that appear next to the title of statements on the main issue page

  def new
    @issue_vote = IssueVote.new
  end
 
# Originally this was setup as a thumbs up down function but has since been changed to only allow users to vote on one for or against agrument per issue
  def create
    redirect_to sm_login_pick_method_path and return unless current_user
    @issueid = params[:issue_vote][:issue_vote_id]
    @up_or_down = params[:issue_vote][:up_or_down] 
    @yes_or_no = params[:issue_vote][:yes_or_no] 
    @detail_id = params[:issue_vote][:detail_id]
    
# Not strictly REST but checks table to see if someone has already vote for that issue (issue_vote_id), voted and if the IP address has been sued before

    @voted = IssueVote.find(:first, :conditions => {:issue_vote_id => params[:issue_vote][:issue_vote_id], :yes_or_no => params[:issue_vote][:yes_or_no], :cookie_id => request.session_options[:id]}, )
    if @voted != nil
      begin
        downvoted_detail = Detail.find(@voted.detail_id)
        downvoted_detail.position -= 1
        downvoted_detail.save
      rescue ActiveRecord::RecordNotFound => e
        logger.error "Detail with id #{@voted.detail_id} not found"
      end
      @voted.update_attributes(:up_or_down => params[:issue_vote][:up_or_down], :detail_id => params[:issue_vote][:detail_id], :yes_or_no => params[:issue_vote][:yes_or_no] )
    else
      @issue_vote = IssueVote.create!(
            cookie_id: request.session_options[:id],
            issue_vote_id: @issueid,
            up_or_down: @up_or_down,
            yes_or_no: @yes_or_no,
            user_id: current_user.id,
            detail_id: @detail_id
          )
    end
    @detail = Detail.find_by_id(@detail_id)
    details_count = @detail.detailable.send(:"detail_#{@detail.detail_type}s").count
    @issue_vote_total = IssueVote.where(:detail_id => @detail_id).count
    @detail.update_attributes(:position => @issue_vote_total + details_count)
    redirect_to(:back)
  end
  
  def update

    redirect_to(:back)
    # @rating = Rating.find(:first, :conditions => {issue_vote_id: => params[:issue_vote][:issue_vote_id], :ip_address=> request.ip})
    # @rating.update_attribute(:up_or_down, params[:issue_vote][:up_or_down])
  end
end