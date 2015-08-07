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
class VotesController < ApplicationController

# Vote for and against on edit shown on History and Statement pages

  def for
    activity = Activity.find(params[:activity_id])

    vote = find_vote_by_voteable_and_voter(activity,current_user)
    vote.vote = 1
    vote.save

    render :text => activity.votes_for
  end

  def against
    activity = Activity.find(params[:activity_id])

    vote = find_vote_by_voteable_and_voter(activity,current_user)
    vote.destroy

    render :text => activity.votes_for
  end

  private

  def find_vote_by_voteable_and_voter(voteable, voter)
    vote = Vote.find_by_voteable_id_and_voteable_type_and_voter_id_and_voter_type(voteable.id, voteable.class,
                                                                                  voter.id, voter.class)
    if vote.blank?
      vote = Vote.create(:voteable => voteable, :voter => voter)
    end

    vote
  end
end