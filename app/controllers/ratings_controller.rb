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
class RatingsController < ApplicationController
  include ActionView::Helpers::TextHelper

# Ratings for issue pages aka the star ratings shwon in the righthand bar. Using Rateit jQuery.
  
  def create

    if current_user
      conditions = {rateable_id: params[:rating][:rateable_id], rateable_type: params[:rating][:rateable_type], 
                    user_id: current_user.id }
      if rating = Rating.find(:first, conditions: conditions)
        rating.update_attribute(:score, params[:rating][:score])
        render json: {msg: "Rating updated.", 
                      current_score: rating.rateable.ratings.average(:score), 
                      current_votes: pluralize(rating.rateable.ratings.count, 'vote', 'votes')}
      else
        if Rating::RATEABLE_MODELS.include?(params[:rating][:rateable_type].downcase)
          params[:rating][:ip_address] = request.ip
          rating = Rating.create(params[:rating])
          if current_user
            rating.user = current_user
          end
          rating.save!
          render json: {msg: "Rating accepted.", 
                        current_score: rating.rateable.ratings.average(:score), 
                        current_votes: pluralize(rating.rateable.ratings.count, 'vote', 'votes')}
        else
          render json: {error: "Sorry, that isn't permitted"}, status: 402
        end
      end
    else
      render json: {msg: "Please login.", 
                    current_score: 0,
                    current_votes: 'Log in to vote'}
    end

  end
end