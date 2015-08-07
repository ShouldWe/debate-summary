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
module Pw
  module ActsAsRater
    extend ActiveSupport::Concern

    included do |klass|
      # Declare Association on User Model
      has_many :ratings, inverse_of: :user
    end

    # Check if user has already voted for an item.
    def voted_for?(item)
      return ratings.where(rateable_id: item.id, rateable_type: item.class.to_s).exists?
    end

    # Return what the user voted for an item
    def get_vote_for(item)
      ratings.where(rateable_id: item.id, rateable_type: item.class.to_s).first.score
    rescue
      nil
    end

    # Vote for item provided.
    # TODO: Add check for item.rateable?
    def vote_for(item, score, ip_address=nil)
      return nil unless item && score
      return self.ratings.create({
        rateable_id: item.id,
        rateable_type: item.class.to_s,
        score: score,
        :ip_address => ip_address
      }.reject{|a,b| b.blank?})
    end

    # Vote for item, raise error if not possible.
    # TODO: Add check for item.rateable?
    def vote_for!(item, score, ip_address=nil)
      return nil unless item && score
      return self.ratings.create!({
        rateable_id: item.id,
        rateable_type: item.class.to_s,
        score: score,
        ip_address: ip_address
      }.reject{|a,b| b.blank?})
    end
  end
end