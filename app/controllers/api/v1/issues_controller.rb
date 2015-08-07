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
module Api
  module V1
    class IssuesController < BaseController
      caches_action :show
      caches_action :other_sources, :index, expires_in: 3.hours
      before_filter :fetch_issue, except: [:index, :search]

      def index
        @issues   = Issue.trending
        @tags     = Issue.trending_tags.limit(10)
        @sections = Issue.sections
        respond_with([@issues, @tags, @sections])
      end

      def show
        respond_with(@issue)
      end

      def other_sources
        query = @issue.tags.collect(&:name).join(' ')
        @news = BingNews.new(query).news
        respond_with(@news)
      end

      def search
        limit = params[:limit] || 10
        limit = 500 if limit > 500

        offset = params[:offset] || 0

        query = params[:q]

        @issues = Issue.tagged_with(query, any: true, wild: true).limit(limit).offset(offset)
        @meta = OpenStruct.new(
          totalResults: Issue.tagged_with(query, any: true, wild: true).count,
          limit: limit,
          offset: offset,
          query: query
        )
        respond_with([@issues, @meta])
      end

      private
      def fetch_issue
        issues = Issue.arel_table
        id = params[:id]
        @issue = Issue.where(issues[:id].eq(id).or(issues[:slug].eq(id))).first
        unless @issue
          return head status: :not_found
        end
      end
    end
  end
end