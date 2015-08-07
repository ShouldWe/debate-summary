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
module FriendlyId
	module Delayed
    extend ActiveSupport::Concern
    
    module InstanceMethods
      
      # OVERRIDES FRIENDLY_ID'S INBUILT METHOD TO ENSURE WE 
      # CHECK THE NUMBER OF PAGEVIEWS BEFORE GENERATING A SLUG.
      # 
      # To do this, we need to keep track of how many unique views
      # an issue has had, to know what is locked and what isn't.
      # the best way to do this for now is to rely on a simple method
      # call inside the host model.
      #
      # For sake of argument, this is going to expect to be able to call
      # model#title_locked? initially, to check if it is locked.
      #
      # If that returns true, and there is no existing slug then we need
      # to generate a new slug.
      #
      # TODO
      # The other scenario to be covered is if the title has been locked
      # and a slug generated, but needs to be changed.
      def should_generate_new_friendly_id?
        base        =  send(friendly_id_config.base)
        slug_value  =  send(friendly_id_config.slug_column)
        
        # RETURN FALSE IF NEITHER BASE NOR SLUG_VALUE IS SET
        return false if base.nil? && slug_value.nil?
        
        # DO NOT A GENERATE A SLUG IF THIS IS A NEW RECORD
        return false if new_record?
        
        # CHECK IF THE TITLE IS LOCKED AND A SLUG IS PRESENT
        # IF THE TITLE IS LOCKED, BUT NO SLUG IS PRESENT THEN
        # GENERATE ONE.
        if title_locked?
          return slug_value.nil? ? true : false
        end
        
      end
    end
	end
end