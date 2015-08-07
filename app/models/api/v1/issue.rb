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
    class Issue < ::Issue
      self.table_name = 'issues'
      attr_accessible :title

      delegate :url_helpers, to: 'Rails.application.routes'

      class << self
        delegate :url_helpers, to: 'Rails.application.routes' 
        # def url_helpers
        #   Rails.application.routes.url_helpers
        # end

        def trending(sample_size = 10)
          visits = Visit.select('visitable_id as issue_id, COUNT(visits.id) as visits_count')
            .where(visitable_type: 'Issue')
            .group('visits.visitable_id')
            .order('visits_count DESC').limit(sample_size)
          where(id: visits.collect(&:issue_id))
        end

        def trending_tags
          trending.tag_counts_on(:tags).order(:count).reverse_order
        end

        def sections
          groups = []
          Api::V1::Tag::GROUPS.each do |group|
            groups << Struct.new(:name, :issues, :meta).new.tap do |entry|
              tag_list = group.split('&')
              entry.name = group
              entry.issues = most_visited_by_tags(tag_list).limit(10)
              entry.meta = {
                'canonicalUrl' => url_helpers.tag_url(id: group),
                'totalIssues' => count_most_visited_by_tags(tag_list)
              }
            end
          end
          groups
        end

        private

        def most_visited_by_tags(tags=nil)
          tagged_with(tags, any: true)
            .select('COUNT(visits.id) AS visits_count')
            .joins(:visits)
            .group('issues.id')
            .order('COUNT(visits.id)').reverse_order
        end

        def count_most_visited_by_tags(tags=nil)
          tagged_with(tags, any: true).count
        end

      end

      # Protection against overwriting or deleting records
      def readonly?
        true
      end

      def before_destroy
        raise ActiveREcord::ReadOnlyRecord
      end

      def context
        html = read_attribute('context')
        content_splitter(html)
      end

      def yesses
        detailable_group('fors')
      end

      def noes
        detailable_group('againsts')
      end

      def relevances
        detailable_group('relevants')
      end

      def perspectives
        detailable_group('alternatives')
      end

      private

      def detailable_group(key)
        array = []
        self.send("detail_#{key}".to_sym).each do |detail|
          array << {
            title: detail.title,
            body: content_splitter(detail.body)
          }
        end
        array 
      end

      def content_splitter(html)
        parsed = Nokogiri::HTML::fragment(html)
        array = []
        parsed.css('a').each do |anchor|
          array << {
            href: anchor[:href],
            content: anchor.text,
            sha: anchor[:name]
          }
        end
        array
      end
    end
  end
end