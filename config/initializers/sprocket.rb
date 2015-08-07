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
module Sprockets
  class DirectiveProcessor
    # support for: require_tree . exclude: "", "some_other"
    def process_require_tree_directive(path = ".", *args)
      if relative?(path)
        root = pathname.dirname.join(path).expand_path

        unless (stats = stat(root)) && stats.directory?
          raise ArgumentError, "require_tree argument must be a directory"
        end

        exclude = args.shift == 'exclude:' ? args.map {|arg| arg[/['"]?([^'"]+)['"]?,?/, 1]} : []

        context.depend_on(root)

        each_entry(root) do |pathname|
          if pathname.to_s == self.file or pathname.basename(pathname.extname).to_s.in?(exclude)
            next
          elsif stat(pathname).directory?
            context.depend_on(pathname)
          elsif context.asset_requirable?(pathname)
            context.require_asset(pathname)
          end
        end
      else
        # The path must be relative and start with a `./`.
        raise ArgumentError, "require_tree argument must be a relative path"
      end
    end
  end
end