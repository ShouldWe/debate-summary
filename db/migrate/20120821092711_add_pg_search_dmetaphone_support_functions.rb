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
class AddPgSearchDmetaphoneSupportFunctions < ActiveRecord::Migration
  def self.up
    say_with_time("Adding support functions for pg_search :dmetaphone") do
      execute 'create extension if not exists fuzzystrmatch;'
      execute 'create extension if not exists unaccent;'
      if ActiveRecord::Base.connection.send(:postgresql_version) < 80400
        execute <<-SQL
CREATE OR REPLACE FUNCTION unnest(anyarray)
  RETURNS SETOF anyelement AS
$BODY$
SELECT $1[i] FROM
    generate_series(array_lower($1,1),
                    array_upper($1,1)) i;
$BODY$
  LANGUAGE 'sql' IMMUTABLE

        SQL
      end

      execute <<-SQL
CREATE OR REPLACE FUNCTION pg_search_dmetaphone(text) RETURNS text LANGUAGE SQL IMMUTABLE STRICT AS $function$
  SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\\\\s+')))), ' ')
$function$;

      SQL
    end
  end

  def self.down
    say_with_time("Dropping support functions for pg_search :dmetaphone") do
      execute <<-SQL
DROP FUNCTION pg_search_dmetaphone(text);

      SQL

      if ActiveRecord::Base.connection.send(:postgresql_version) < 80400
        execute <<-SQL
DROP FUNCTION unnest(anyarray);

        SQL
      end
    end
  end
end