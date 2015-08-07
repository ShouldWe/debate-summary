# encoding: UTF-8
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
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140903124206) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "activities", :force => true do |t|
    t.integer  "issue_id"
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "activity_type",    :limit => 15
    t.integer  "proposed_edit_id"
    t.text     "body"
    t.integer  "recordable_id"
    t.string   "recordable_type"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "issue_id"
    t.integer  "proposed_edit_id"
    t.text     "body"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  create_table "contextuals", :force => true do |t|
    t.string   "title"
    t.text     "field_description"
    t.text     "think_about"
    t.string   "field_title"
    t.text     "placeholder"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "contextuals", ["title"], :name => "index_contextuals_on_title"

  create_table "details", :force => true do |t|
    t.integer  "issue_id"
    t.integer  "detailable_id"
    t.string   "detailable_type"
    t.string   "title"
    t.integer  "position",        :default => 0, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.text     "body"
    t.text     "formatted_body"
    t.string   "detail_type"
    t.string   "shas"
  end

  add_index "details", ["detailable_id", "detailable_type"], :name => "index_details_on_detailable_id_and_detailable_type"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "house_rules", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "house_rules_rule_break_reports", :id => false, :force => true do |t|
    t.integer "rule_break_report_id", :null => false
    t.integer "house_rule_id",        :null => false
  end

  add_index "house_rules_rule_break_reports", ["rule_break_report_id", "house_rule_id"], :name => "house_rules_rule_break_reports_index", :unique => true

  create_table "internal_relations", :force => true do |t|
    t.integer "issue_id",         :null => false
    t.integer "related_issue_id", :null => false
  end

  create_table "issue_links", :force => true do |t|
    t.integer  "issue_id"
    t.integer  "position",   :default => 0, :null => false
    t.string   "title"
    t.string   "url"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "issue_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "issue_id"
    t.boolean  "expert",     :default => false
    t.boolean  "monitor",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "issue_title_votes", :force => true do |t|
    t.integer  "issue_title_id"
    t.integer  "user_id"
    t.string   "ip_address"
    t.integer  "score",          :default => 1, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "issue_title_votes", ["issue_title_id"], :name => "index_issue_title_votes_on_issue_title_id"
  add_index "issue_title_votes", ["user_id"], :name => "index_issue_title_votes_on_user_id"

  create_table "issue_titles", :force => true do |t|
    t.string   "title"
    t.integer  "issue_id"
    t.boolean  "canonical"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "issue_titles", ["issue_id"], :name => "index_issue_titles_on_issue_id"

  create_table "issue_votes", :force => true do |t|
    t.integer  "issue_vote_id"
    t.integer  "user_id"
    t.string   "cookie_id"
    t.string   "up_or_down"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "detail_id"
    t.string   "yes_or_no"
  end

  create_table "issues", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "slug"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "version",      :default => 0
    t.string   "image"
    t.string   "uuid"
    t.text     "context"
    t.string   "context_shas"
  end

  add_index "issues", ["slug"], :name => "index_issues_on_slug", :unique => true
  add_index "issues", ["user_id"], :name => "index_issues_on_user_id"
  add_index "issues", ["uuid"], :name => "index_issues_on_uuid"

  create_table "link_health", :force => true do |t|
    t.text     "url"
    t.integer  "status"
    t.string   "mime_type"
    t.string   "sha",                 :default => "[]"
    t.string   "x_frame_options"
    t.text     "destination_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count"
    t.string   "link_checkable_type"
    t.integer  "link_checkable_id"
    t.datetime "last_checked_at"
    t.integer  "issue_id"
    t.text     "error_reason"
  end

  create_table "links", :force => true do |t|
    t.string   "url"
    t.integer  "accessed_count"
    t.datetime "last_accessed"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "links", ["url"], :name => "index_links_on_url"

  create_table "messages", :force => true do |t|
    t.string   "title"
    t.string   "content",                         :null => false
    t.boolean  "read",         :default => false, :null => false
    t.boolean  "abuse",        :default => false, :null => false
    t.integer  "recipient_id",                    :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "sender_id"
  end

  create_table "notification_subscriptions", :force => true do |t|
    t.integer  "issue_id",                      :null => false
    t.integer  "user_id",                       :null => false
    t.string   "preference", :default => "all", :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "notification_subscriptions", ["issue_id", "preference"], :name => "index_notification_subscriptions_on_issue_id_and_preference"
  add_index "notification_subscriptions", ["issue_id"], :name => "index_notification_subscriptions_on_issue_id"
  add_index "notification_subscriptions", ["user_id"], :name => "index_notification_subscriptions_on_user_id"

  create_table "opengraphs", :force => true do |t|
    t.string   "title"
    t.string   "type"
    t.string   "image"
    t.string   "description"
    t.string   "opengraphable_type"
    t.integer  "opengraphable_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title",                         :null => false
    t.text     "markdown",                      :null => false
    t.text     "compiled"
    t.string   "permalink",                     :null => false
    t.boolean  "published",  :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "pages", ["permalink", "published"], :name => "index_pages_on_permalink_and_published"
  add_index "pages", ["permalink"], :name => "index_pages_on_permalink"
  add_index "pages", ["published"], :name => "index_pages_on_published"

  create_table "penalties", :force => true do |t|
    t.string   "name"
    t.integer  "duration",   :default => 0
    t.boolean  "global",     :default => false
    t.boolean  "permanent",  :default => false
    t.boolean  "no_penalty", :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "pg_search_documents", :force => true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "proposed_edits", :force => true do |t|
    t.string   "edit_type"
    t.integer  "edit_id"
    t.string   "statementable_type"
    t.integer  "statementable_id"
    t.string   "aasm_state"
    t.integer  "closed_by_id"
    t.text     "change_data"
    t.integer  "user_id"
    t.integer  "issue_id"
    t.text     "name"
    t.text     "body"
    t.text     "source"
    t.text     "title"
    t.text     "url"
    t.text     "tag_list"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "editable_id"
    t.string   "editable_type"
    t.string   "detail_type",        :limit => 20
  end

  create_table "ratings", :force => true do |t|
    t.integer  "rateable_id",   :null => false
    t.string   "rateable_type", :null => false
    t.integer  "user_id"
    t.string   "ip_address"
    t.float    "score",         :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "ratings", ["ip_address"], :name => "index_ratings_on_ip_address"
  add_index "ratings", ["rateable_id", "rateable_type"], :name => "index_ratings_on_rateable_id_and_rateable_type"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "rich_rich_files", :force => true do |t|
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "rich_file_file_name"
    t.string   "rich_file_content_type"
    t.integer  "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.text     "uri_cache"
    t.string   "simplified_type",        :default => "file"
  end

  create_table "rule_break_report_votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "penalty_id"
    t.integer  "rule_break_report_id"
    t.boolean  "apply_unilaterally"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "rule_break_report_votes", ["penalty_id"], :name => "index_rule_break_report_votes_on_penalty_id"
  add_index "rule_break_report_votes", ["rule_break_report_id"], :name => "index_rule_break_report_votes_on_rule_break_report_id"
  add_index "rule_break_report_votes", ["user_id"], :name => "index_rule_break_report_votes_on_user_id"

  create_table "rule_break_reports", :force => true do |t|
    t.integer  "seriousness"
    t.text     "message"
    t.integer  "house_rule_id"
    t.integer  "reportable_id",                      :null => false
    t.string   "reportable_type",                    :null => false
    t.integer  "reporter_id"
    t.string   "reporter_type"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "resolved",        :default => false
    t.integer  "resolver_id"
    t.integer  "penalty_id"
    t.datetime "resolved_at"
    t.datetime "penalty_end"
  end

  add_index "rule_break_reports", ["reportable_id", "reportable_type"], :name => "index_rule_break_reports_on_reportable_id_and_reportable_type"
  add_index "rule_break_reports", ["reporter_id", "reporter_type", "reportable_id", "reportable_type"], :name => "fk_one_report_per_user_per_entity", :unique => true
  add_index "rule_break_reports", ["reporter_id", "reporter_type"], :name => "index_rule_break_reports_on_reporter_id_and_reporter_type"
  add_index "rule_break_reports", ["resolved"], :name => "index_rule_break_reports_on_resolved"
  add_index "rule_break_reports", ["resolved_at"], :name => "index_rule_break_reports_on_resolved_at"

  create_table "statements", :force => true do |t|
    t.integer  "user_id"
    t.integer  "statementable_id"
    t.string   "statementable_type"
    t.string   "name"
    t.text     "body"
    t.text     "source"
    t.integer  "position",           :default => 0,     :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "new_paragraph",      :default => false, :null => false
    t.string   "image"
    t.integer  "issue_id"
  end

  create_table "tag_issue_clicks", :force => true do |t|
    t.integer  "tag_id",                     :null => false
    t.integer  "issue_id",                   :null => false
    t.integer  "click_count", :default => 0, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "templates", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.text     "compiled"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "templates", ["slug"], :name => "index_templates_on_slug"

  create_table "users", :force => true do |t|
    t.string   "name",                       :default => "",    :null => false
    t.string   "email",                      :default => "",    :null => false
    t.string   "encrypted_password",         :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "bio_headline"
    t.text     "bio"
    t.string   "avatar"
    t.string   "slug"
    t.boolean  "admin",                      :default => false, :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "facebook_uid"
    t.string   "facebook_token"
    t.integer  "facebook_token_expires_at"
    t.string   "twitter_uid"
    t.string   "twitter_token"
    t.string   "twitter_token_secret"
    t.integer  "twitter_token_expires_at"
    t.text     "facebook_info"
    t.text     "twitter_info"
    t.integer  "facebook_friend_count"
    t.integer  "twitter_follower_count"
    t.boolean  "endorsed",                   :default => false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "country"
    t.string   "city"
    t.boolean  "post_privately_by_default"
    t.string   "monitors"
    t.string   "endorsed_by"
    t.string   "linkedin_uid"
    t.string   "linkedin_token"
    t.text     "linkedin_info"
    t.integer  "linkedin_connections_count"
    t.text     "notification_preferences"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["facebook_uid"], :name => "index_users_on_facebook_uid"
  add_index "users", ["linkedin_uid"], :name => "index_users_on_linkedin_uid"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true
  add_index "users", ["twitter_uid"], :name => "index_users_on_twitter_uid"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "visits", :force => true do |t|
    t.string   "visitable_type"
    t.integer  "visitable_id"
    t.integer  "user_id"
    t.string   "ip_address"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "total_visits",   :default => 0, :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "country"
    t.string   "city"
  end

  add_index "visits", ["user_id"], :name => "index_visits_on_user_id"
  add_index "visits", ["visitable_id", "visitable_type"], :name => "index_visits_on_visitable_id_and_visitable_type"

  create_table "votes", :force => true do |t|
    t.integer  "vote",          :default => 1, :null => false
    t.integer  "voteable_id",                  :null => false
    t.string   "voteable_type",                :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end