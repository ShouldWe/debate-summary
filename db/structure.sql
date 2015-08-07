--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    resource_id character varying(255) NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    namespace character varying(255)
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activities (
    id integer NOT NULL,
    issue_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    activity_type character varying(15),
    proposed_edit_id integer,
    body text,
    recordable_id integer,
    recordable_type character varying(255)
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activities_id_seq OWNED BY activities.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    user_id integer,
    issue_id integer,
    proposed_edit_id integer,
    body text,
    parent_id integer,
    lft integer,
    rgt integer,
    depth integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    commentable_id integer,
    commentable_type character varying(255)
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: contextuals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contextuals (
    id integer NOT NULL,
    title character varying(255),
    field_description text,
    think_about text,
    field_title character varying(255),
    placeholder text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: contextuals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contextuals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contextuals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contextuals_id_seq OWNED BY contextuals.id;


--
-- Name: details; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE details (
    id integer NOT NULL,
    issue_id integer,
    detailable_id integer,
    detailable_type character varying(255),
    title character varying(255),
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    body text,
    formatted_body text,
    detail_type character varying(255),
    shas text
);


--
-- Name: details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE details_id_seq OWNED BY details.id;


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(40),
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: house_rules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE house_rules (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: house_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE house_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: house_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE house_rules_id_seq OWNED BY house_rules.id;


--
-- Name: house_rules_rule_break_reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE house_rules_rule_break_reports (
    rule_break_report_id integer NOT NULL,
    house_rule_id integer NOT NULL
);


--
-- Name: internal_relations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE internal_relations (
    id integer NOT NULL,
    issue_id integer NOT NULL,
    related_issue_id integer NOT NULL
);


--
-- Name: internal_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE internal_relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: internal_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE internal_relations_id_seq OWNED BY internal_relations.id;


--
-- Name: issue_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issue_links (
    id integer NOT NULL,
    issue_id integer,
    "position" integer DEFAULT 0 NOT NULL,
    title character varying(255),
    url character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: issue_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_links_id_seq OWNED BY issue_links.id;


--
-- Name: issue_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issue_roles (
    id integer NOT NULL,
    user_id integer,
    issue_id integer,
    expert boolean DEFAULT false,
    monitor boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: issue_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_roles_id_seq OWNED BY issue_roles.id;


--
-- Name: issue_title_votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issue_title_votes (
    id integer NOT NULL,
    issue_title_id integer,
    user_id integer,
    ip_address character varying(255),
    score integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: issue_title_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_title_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_title_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_title_votes_id_seq OWNED BY issue_title_votes.id;


--
-- Name: issue_titles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issue_titles (
    id integer NOT NULL,
    title character varying(255),
    issue_id integer,
    canonical boolean,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: issue_titles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_titles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_titles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_titles_id_seq OWNED BY issue_titles.id;


--
-- Name: issue_votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issue_votes (
    id integer NOT NULL,
    issue_vote_id integer,
    user_id integer,
    cookie_id character varying(255),
    up_or_down character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    detail_id integer,
    yes_or_no character varying(255)
);


--
-- Name: issue_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_votes_id_seq OWNED BY issue_votes.id;


--
-- Name: issues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issues (
    id integer NOT NULL,
    title character varying(255),
    user_id integer,
    slug character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    version integer DEFAULT 0,
    image character varying(255),
    uuid character varying(255),
    context text,
    context_shas text
);


--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issues_id_seq OWNED BY issues.id;


--
-- Name: link_health; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE link_health (
    id integer NOT NULL,
    url text,
    status integer,
    mime_type character varying(255),
    sha text DEFAULT '[]'::character varying,
    x_frame_options character varying(255),
    destination_url text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    count integer,
    link_checkable_type character varying(255),
    link_checkable_id integer,
    last_checked_at timestamp without time zone,
    issue_id integer,
    error_reason text
);


--
-- Name: link_health_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE link_health_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: link_health_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE link_health_id_seq OWNED BY link_health.id;


--
-- Name: links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE links (
    id integer NOT NULL,
    url character varying(255),
    accessed_count integer,
    last_accessed timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE links_id_seq OWNED BY links.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages (
    id integer NOT NULL,
    title character varying(255),
    content character varying(255) NOT NULL,
    read boolean DEFAULT false NOT NULL,
    abuse boolean DEFAULT false NOT NULL,
    recipient_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sender_id integer
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: notification_subscriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notification_subscriptions (
    id integer NOT NULL,
    issue_id integer NOT NULL,
    user_id integer NOT NULL,
    preference character varying(255) DEFAULT 'all'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notification_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notification_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notification_subscriptions_id_seq OWNED BY notification_subscriptions.id;


--
-- Name: opengraphs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE opengraphs (
    id integer NOT NULL,
    title character varying(255),
    type character varying(255),
    image character varying(255),
    description character varying(255),
    opengraphable_type character varying(255),
    opengraphable_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: opengraphs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE opengraphs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: opengraphs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE opengraphs_id_seq OWNED BY opengraphs.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    markdown text NOT NULL,
    compiled text,
    permalink character varying(255) NOT NULL,
    published boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: penalties; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE penalties (
    id integer NOT NULL,
    name character varying(255),
    duration integer DEFAULT 0,
    global boolean DEFAULT false,
    permanent boolean DEFAULT false,
    no_penalty boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: penalties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE penalties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: penalties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE penalties_id_seq OWNED BY penalties.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pg_search_documents (
    id integer NOT NULL,
    content text,
    searchable_id integer,
    searchable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pg_search_documents_id_seq OWNED BY pg_search_documents.id;


--
-- Name: proposed_edits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE proposed_edits (
    id integer NOT NULL,
    edit_type character varying(255),
    edit_id integer,
    statementable_type character varying(255),
    statementable_id integer,
    aasm_state character varying(255),
    closed_by_id integer,
    change_data text,
    user_id integer,
    issue_id integer,
    name text,
    body text,
    source text,
    title text,
    url text,
    tag_list text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    editable_id integer,
    editable_type character varying(255),
    detail_type character varying(20)
);


--
-- Name: proposed_edits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE proposed_edits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: proposed_edits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE proposed_edits_id_seq OWNED BY proposed_edits.id;


--
-- Name: ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ratings (
    id integer NOT NULL,
    rateable_id integer NOT NULL,
    rateable_type character varying(255) NOT NULL,
    user_id integer,
    ip_address character varying(255),
    score double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ratings_id_seq OWNED BY ratings.id;


--
-- Name: rich_rich_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rich_rich_files (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rich_file_file_name character varying(255),
    rich_file_content_type character varying(255),
    rich_file_file_size integer,
    rich_file_updated_at timestamp without time zone,
    owner_type character varying(255),
    owner_id integer,
    uri_cache text,
    simplified_type character varying(255) DEFAULT 'file'::character varying
);


--
-- Name: rich_rich_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rich_rich_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rich_rich_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rich_rich_files_id_seq OWNED BY rich_rich_files.id;


--
-- Name: rule_break_report_votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rule_break_report_votes (
    id integer NOT NULL,
    user_id integer,
    penalty_id integer,
    rule_break_report_id integer,
    apply_unilaterally boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rule_break_report_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rule_break_report_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rule_break_report_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rule_break_report_votes_id_seq OWNED BY rule_break_report_votes.id;


--
-- Name: rule_break_reports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rule_break_reports (
    id integer NOT NULL,
    seriousness integer,
    message text,
    house_rule_id integer,
    reportable_id integer NOT NULL,
    reportable_type character varying(255) NOT NULL,
    reporter_id integer,
    reporter_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    resolved boolean DEFAULT false,
    resolver_id integer,
    penalty_id integer,
    resolved_at timestamp without time zone,
    penalty_end timestamp without time zone
);


--
-- Name: rule_break_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rule_break_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rule_break_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rule_break_reports_id_seq OWNED BY rule_break_reports.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: statements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE statements (
    id integer NOT NULL,
    user_id integer,
    statementable_id integer,
    statementable_type character varying(255),
    name character varying(255),
    body text,
    source text,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    new_paragraph boolean DEFAULT false NOT NULL,
    image character varying(255),
    issue_id integer
);


--
-- Name: statements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE statements_id_seq OWNED BY statements.id;


--
-- Name: tag_issue_clicks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tag_issue_clicks (
    id integer NOT NULL,
    tag_id integer NOT NULL,
    issue_id integer NOT NULL,
    click_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tag_issue_clicks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tag_issue_clicks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_issue_clicks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tag_issue_clicks_id_seq OWNED BY tag_issue_clicks.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying(255),
    tagger_id integer,
    tagger_type character varying(255),
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: templates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE templates (
    id integer NOT NULL,
    title character varying(255),
    slug character varying(255),
    content text,
    compiled text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE templates_id_seq OWNED BY templates.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    bio_headline character varying(255),
    bio text,
    avatar character varying(255),
    slug character varying(255),
    admin boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    facebook_uid character varying(255),
    facebook_token character varying(255),
    facebook_token_expires_at integer,
    twitter_uid character varying(255),
    twitter_token character varying(255),
    twitter_token_secret character varying(255),
    twitter_token_expires_at integer,
    facebook_info text,
    twitter_info text,
    facebook_friend_count integer,
    twitter_follower_count integer,
    endorsed boolean DEFAULT false,
    latitude double precision,
    longitude double precision,
    country character varying(255),
    city character varying(255),
    post_privately_by_default boolean,
    monitors character varying(255),
    endorsed_by character varying(255),
    linkedin_uid character varying(255),
    linkedin_token character varying(255),
    linkedin_info text,
    linkedin_connections_count integer,
    notification_preferences text
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying(255) NOT NULL,
    item_id integer NOT NULL,
    event character varying(255) NOT NULL,
    whodunnit character varying(255),
    object text,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: visits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visits (
    id integer NOT NULL,
    visitable_type character varying(255),
    visitable_id integer,
    user_id integer,
    ip_address character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    total_visits integer DEFAULT 0 NOT NULL,
    latitude double precision,
    longitude double precision,
    country character varying(255),
    city character varying(255)
);


--
-- Name: visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visits_id_seq OWNED BY visits.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE votes (
    id integer NOT NULL,
    vote integer DEFAULT 1 NOT NULL,
    voteable_id integer NOT NULL,
    voteable_type character varying(255) NOT NULL,
    voter_id integer,
    voter_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE votes_id_seq OWNED BY votes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities ALTER COLUMN id SET DEFAULT nextval('activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contextuals ALTER COLUMN id SET DEFAULT nextval('contextuals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY details ALTER COLUMN id SET DEFAULT nextval('details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY house_rules ALTER COLUMN id SET DEFAULT nextval('house_rules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY internal_relations ALTER COLUMN id SET DEFAULT nextval('internal_relations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_links ALTER COLUMN id SET DEFAULT nextval('issue_links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_roles ALTER COLUMN id SET DEFAULT nextval('issue_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_title_votes ALTER COLUMN id SET DEFAULT nextval('issue_title_votes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_titles ALTER COLUMN id SET DEFAULT nextval('issue_titles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_votes ALTER COLUMN id SET DEFAULT nextval('issue_votes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issues ALTER COLUMN id SET DEFAULT nextval('issues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY link_health ALTER COLUMN id SET DEFAULT nextval('link_health_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notification_subscriptions ALTER COLUMN id SET DEFAULT nextval('notification_subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY opengraphs ALTER COLUMN id SET DEFAULT nextval('opengraphs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY penalties ALTER COLUMN id SET DEFAULT nextval('penalties_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pg_search_documents ALTER COLUMN id SET DEFAULT nextval('pg_search_documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY proposed_edits ALTER COLUMN id SET DEFAULT nextval('proposed_edits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ratings ALTER COLUMN id SET DEFAULT nextval('ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rich_rich_files ALTER COLUMN id SET DEFAULT nextval('rich_rich_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rule_break_report_votes ALTER COLUMN id SET DEFAULT nextval('rule_break_report_votes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rule_break_reports ALTER COLUMN id SET DEFAULT nextval('rule_break_reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY statements ALTER COLUMN id SET DEFAULT nextval('statements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_issue_clicks ALTER COLUMN id SET DEFAULT nextval('tag_issue_clicks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY templates ALTER COLUMN id SET DEFAULT nextval('templates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visits ALTER COLUMN id SET DEFAULT nextval('visits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: contextuals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contextuals
    ADD CONSTRAINT contextuals_pkey PRIMARY KEY (id);


--
-- Name: details_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY details
    ADD CONSTRAINT details_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: house_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY house_rules
    ADD CONSTRAINT house_rules_pkey PRIMARY KEY (id);


--
-- Name: internal_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY internal_relations
    ADD CONSTRAINT internal_relations_pkey PRIMARY KEY (id);


--
-- Name: issue_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issue_links
    ADD CONSTRAINT issue_links_pkey PRIMARY KEY (id);


--
-- Name: issue_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issue_roles
    ADD CONSTRAINT issue_roles_pkey PRIMARY KEY (id);


--
-- Name: issue_title_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issue_title_votes
    ADD CONSTRAINT issue_title_votes_pkey PRIMARY KEY (id);


--
-- Name: issue_titles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issue_titles
    ADD CONSTRAINT issue_titles_pkey PRIMARY KEY (id);


--
-- Name: issue_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issue_votes
    ADD CONSTRAINT issue_votes_pkey PRIMARY KEY (id);


--
-- Name: issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: link_health_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY link_health
    ADD CONSTRAINT link_health_pkey PRIMARY KEY (id);


--
-- Name: links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notification_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notification_subscriptions
    ADD CONSTRAINT notification_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: opengraphs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY opengraphs
    ADD CONSTRAINT opengraphs_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: penalties_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY penalties
    ADD CONSTRAINT penalties_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: proposed_edits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY proposed_edits
    ADD CONSTRAINT proposed_edits_pkey PRIMARY KEY (id);


--
-- Name: ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: rich_rich_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rich_rich_files
    ADD CONSTRAINT rich_rich_files_pkey PRIMARY KEY (id);


--
-- Name: rule_break_report_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rule_break_report_votes
    ADD CONSTRAINT rule_break_report_votes_pkey PRIMARY KEY (id);


--
-- Name: rule_break_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rule_break_reports
    ADD CONSTRAINT rule_break_reports_pkey PRIMARY KEY (id);


--
-- Name: statements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY statements
    ADD CONSTRAINT statements_pkey PRIMARY KEY (id);


--
-- Name: tag_issue_clicks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tag_issue_clicks
    ADD CONSTRAINT tag_issue_clicks_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY templates
    ADD CONSTRAINT templates_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: fk_one_report_per_user_per_entity; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX fk_one_report_per_user_per_entity ON rule_break_reports USING btree (reporter_id, reporter_type, reportable_id, reportable_type);


--
-- Name: fk_one_vote_per_user_per_entity; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX fk_one_vote_per_user_per_entity ON votes USING btree (voter_id, voter_type, voteable_id, voteable_type);


--
-- Name: house_rules_rule_break_reports_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX house_rules_rule_break_reports_index ON house_rules_rule_break_reports USING btree (rule_break_report_id, house_rule_id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_admin_notes_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_admin_notes_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_contextuals_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_contextuals_on_title ON contextuals USING btree (title);


--
-- Name: index_details_on_detailable_id_and_detailable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_details_on_detailable_id_and_detailable_type ON details USING btree (detailable_id, detailable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_issue_title_votes_on_issue_title_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_issue_title_votes_on_issue_title_id ON issue_title_votes USING btree (issue_title_id);


--
-- Name: index_issue_title_votes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_issue_title_votes_on_user_id ON issue_title_votes USING btree (user_id);


--
-- Name: index_issue_titles_on_issue_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_issue_titles_on_issue_id ON issue_titles USING btree (issue_id);


--
-- Name: index_issues_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_issues_on_slug ON issues USING btree (slug);


--
-- Name: index_issues_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_issues_on_user_id ON issues USING btree (user_id);


--
-- Name: index_issues_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_issues_on_uuid ON issues USING btree (uuid);


--
-- Name: index_links_on_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_links_on_url ON links USING btree (url);


--
-- Name: index_notification_subscriptions_on_issue_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notification_subscriptions_on_issue_id ON notification_subscriptions USING btree (issue_id);


--
-- Name: index_notification_subscriptions_on_issue_id_and_preference; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notification_subscriptions_on_issue_id_and_preference ON notification_subscriptions USING btree (issue_id, preference);


--
-- Name: index_notification_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notification_subscriptions_on_user_id ON notification_subscriptions USING btree (user_id);


--
-- Name: index_pages_on_permalink; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_permalink ON pages USING btree (permalink);


--
-- Name: index_pages_on_permalink_and_published; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_permalink_and_published ON pages USING btree (permalink, published);


--
-- Name: index_pages_on_published; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_published ON pages USING btree (published);


--
-- Name: index_ratings_on_ip_address; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_ip_address ON ratings USING btree (ip_address);


--
-- Name: index_ratings_on_rateable_id_and_rateable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_rateable_id_and_rateable_type ON ratings USING btree (rateable_id, rateable_type);


--
-- Name: index_ratings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_user_id ON ratings USING btree (user_id);


--
-- Name: index_rule_break_report_votes_on_penalty_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rule_break_report_votes_on_penalty_id ON rule_break_report_votes USING btree (penalty_id);


--
-- Name: index_rule_break_report_votes_on_rule_break_report_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rule_break_report_votes_on_rule_break_report_id ON rule_break_report_votes USING btree (rule_break_report_id);


--
-- Name: index_rule_break_report_votes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rule_break_report_votes_on_user_id ON rule_break_report_votes USING btree (user_id);


--
-- Name: index_rule_break_reports_on_reportable_id_and_reportable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rule_break_reports_on_reportable_id_and_reportable_type ON rule_break_reports USING btree (reportable_id, reportable_type);


--
-- Name: index_rule_break_reports_on_reporter_id_and_reporter_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rule_break_reports_on_reporter_id_and_reporter_type ON rule_break_reports USING btree (reporter_id, reporter_type);


--
-- Name: index_rule_break_reports_on_resolved; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rule_break_reports_on_resolved ON rule_break_reports USING btree (resolved);


--
-- Name: index_rule_break_reports_on_resolved_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rule_break_reports_on_resolved_at ON rule_break_reports USING btree (resolved_at);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_templates_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_templates_on_slug ON templates USING btree (slug);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_facebook_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_facebook_uid ON users USING btree (facebook_uid);


--
-- Name: index_users_on_linkedin_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_linkedin_uid ON users USING btree (linkedin_uid);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_slug ON users USING btree (slug);


--
-- Name: index_users_on_twitter_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_twitter_uid ON users USING btree (twitter_uid);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: index_visits_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_user_id ON visits USING btree (user_id);


--
-- Name: index_visits_on_visitable_id_and_visitable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_visitable_id_and_visitable_type ON visits USING btree (visitable_id, visitable_type);


--
-- Name: index_votes_on_voteable_id_and_voteable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_voteable_id_and_voteable_type ON votes USING btree (voteable_id, voteable_type);


--
-- Name: index_votes_on_voter_id_and_voter_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_voter_id_and_voter_type ON votes USING btree (voter_id, voter_type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20120430025519');

INSERT INTO schema_migrations (version) VALUES ('20120430044335');

INSERT INTO schema_migrations (version) VALUES ('20120430061304');

INSERT INTO schema_migrations (version) VALUES ('20120430115752');

INSERT INTO schema_migrations (version) VALUES ('20120501132905');

INSERT INTO schema_migrations (version) VALUES ('20120501133238');

INSERT INTO schema_migrations (version) VALUES ('20120502013626');

INSERT INTO schema_migrations (version) VALUES ('20120502014758');

INSERT INTO schema_migrations (version) VALUES ('20120502022905');

INSERT INTO schema_migrations (version) VALUES ('20120502075305');

INSERT INTO schema_migrations (version) VALUES ('20120504004014');

INSERT INTO schema_migrations (version) VALUES ('20120514070414');

INSERT INTO schema_migrations (version) VALUES ('20120514121432');

INSERT INTO schema_migrations (version) VALUES ('20120514131754');

INSERT INTO schema_migrations (version) VALUES ('20120515010628');

INSERT INTO schema_migrations (version) VALUES ('20120517114252');

INSERT INTO schema_migrations (version) VALUES ('20120517114300');

INSERT INTO schema_migrations (version) VALUES ('20120517120415');

INSERT INTO schema_migrations (version) VALUES ('20120518114427');

INSERT INTO schema_migrations (version) VALUES ('20120611205005');

INSERT INTO schema_migrations (version) VALUES ('20120613210650');

INSERT INTO schema_migrations (version) VALUES ('20120614125357');

INSERT INTO schema_migrations (version) VALUES ('20120614145045');

INSERT INTO schema_migrations (version) VALUES ('20120615221140');

INSERT INTO schema_migrations (version) VALUES ('20120618142718');

INSERT INTO schema_migrations (version) VALUES ('20120620230130');

INSERT INTO schema_migrations (version) VALUES ('20120625100204');

INSERT INTO schema_migrations (version) VALUES ('20120625153245');

INSERT INTO schema_migrations (version) VALUES ('20120625153430');

INSERT INTO schema_migrations (version) VALUES ('20120625155003');

INSERT INTO schema_migrations (version) VALUES ('20120625160103');

INSERT INTO schema_migrations (version) VALUES ('20120625162827');

INSERT INTO schema_migrations (version) VALUES ('20120626104616');

INSERT INTO schema_migrations (version) VALUES ('20120702135916');

INSERT INTO schema_migrations (version) VALUES ('20120713095315');

INSERT INTO schema_migrations (version) VALUES ('20120716154100');

INSERT INTO schema_migrations (version) VALUES ('20120717212253');

INSERT INTO schema_migrations (version) VALUES ('20120803164153');

INSERT INTO schema_migrations (version) VALUES ('20120808075544');

INSERT INTO schema_migrations (version) VALUES ('20120809124122');

INSERT INTO schema_migrations (version) VALUES ('20120813083840');

INSERT INTO schema_migrations (version) VALUES ('20120813112640');

INSERT INTO schema_migrations (version) VALUES ('20120813113450');

INSERT INTO schema_migrations (version) VALUES ('20120813113747');

INSERT INTO schema_migrations (version) VALUES ('20120814150018');

INSERT INTO schema_migrations (version) VALUES ('20120814150019');

INSERT INTO schema_migrations (version) VALUES ('20120819090822');

INSERT INTO schema_migrations (version) VALUES ('20120819143739');

INSERT INTO schema_migrations (version) VALUES ('20120819143740');

INSERT INTO schema_migrations (version) VALUES ('20120819143741');

INSERT INTO schema_migrations (version) VALUES ('20120821092418');

INSERT INTO schema_migrations (version) VALUES ('20120821092711');

INSERT INTO schema_migrations (version) VALUES ('20120821130546');

INSERT INTO schema_migrations (version) VALUES ('20120821145307');

INSERT INTO schema_migrations (version) VALUES ('20120824141445');

INSERT INTO schema_migrations (version) VALUES ('20120829134048');

INSERT INTO schema_migrations (version) VALUES ('20120831101303');

INSERT INTO schema_migrations (version) VALUES ('20120904112454');

INSERT INTO schema_migrations (version) VALUES ('20120906160103');

INSERT INTO schema_migrations (version) VALUES ('20121113103853');

INSERT INTO schema_migrations (version) VALUES ('20121211142106');

INSERT INTO schema_migrations (version) VALUES ('20121211151124');

INSERT INTO schema_migrations (version) VALUES ('20121211151143');

INSERT INTO schema_migrations (version) VALUES ('20121211151208');

INSERT INTO schema_migrations (version) VALUES ('20121211151232');

INSERT INTO schema_migrations (version) VALUES ('20121211160747');

INSERT INTO schema_migrations (version) VALUES ('20121211162106');

INSERT INTO schema_migrations (version) VALUES ('20121217122438');

INSERT INTO schema_migrations (version) VALUES ('20121218163210');

INSERT INTO schema_migrations (version) VALUES ('20121219145715');

INSERT INTO schema_migrations (version) VALUES ('20121220094011');

INSERT INTO schema_migrations (version) VALUES ('20121220123112');

INSERT INTO schema_migrations (version) VALUES ('20121223213941');

INSERT INTO schema_migrations (version) VALUES ('20121224165119');

INSERT INTO schema_migrations (version) VALUES ('20130101161549');

INSERT INTO schema_migrations (version) VALUES ('20130110172136');

INSERT INTO schema_migrations (version) VALUES ('20130118055400');

INSERT INTO schema_migrations (version) VALUES ('20130121070130');

INSERT INTO schema_migrations (version) VALUES ('20130121104232');

INSERT INTO schema_migrations (version) VALUES ('20130121133637');

INSERT INTO schema_migrations (version) VALUES ('20130128122242');

INSERT INTO schema_migrations (version) VALUES ('20130130160013');

INSERT INTO schema_migrations (version) VALUES ('20130316073754');

INSERT INTO schema_migrations (version) VALUES ('20131031164037');

INSERT INTO schema_migrations (version) VALUES ('20131128201212');

INSERT INTO schema_migrations (version) VALUES ('20131208172223');

INSERT INTO schema_migrations (version) VALUES ('20140219175747');

INSERT INTO schema_migrations (version) VALUES ('20140219204252');

INSERT INTO schema_migrations (version) VALUES ('20140508123734');

INSERT INTO schema_migrations (version) VALUES ('20140509125006');

INSERT INTO schema_migrations (version) VALUES ('20140515133119');

INSERT INTO schema_migrations (version) VALUES ('20140515160011');

INSERT INTO schema_migrations (version) VALUES ('20140520131108');

INSERT INTO schema_migrations (version) VALUES ('20140522120356');

INSERT INTO schema_migrations (version) VALUES ('20140523102111');

INSERT INTO schema_migrations (version) VALUES ('20140523105511');

INSERT INTO schema_migrations (version) VALUES ('20140523140021');

INSERT INTO schema_migrations (version) VALUES ('20140528150903');

INSERT INTO schema_migrations (version) VALUES ('20140529145917');

INSERT INTO schema_migrations (version) VALUES ('20140529151406');

INSERT INTO schema_migrations (version) VALUES ('20140530091239');

INSERT INTO schema_migrations (version) VALUES ('20140530111130');

INSERT INTO schema_migrations (version) VALUES ('20140530150348');

INSERT INTO schema_migrations (version) VALUES ('20140602120634');

INSERT INTO schema_migrations (version) VALUES ('20140613125143');

INSERT INTO schema_migrations (version) VALUES ('20140902105352');

INSERT INTO schema_migrations (version) VALUES ('20140903053418');

INSERT INTO schema_migrations (version) VALUES ('20140903054700');

INSERT INTO schema_migrations (version) VALUES ('20140903124206');

INSERT INTO schema_migrations (version) VALUES ('20140903132224');