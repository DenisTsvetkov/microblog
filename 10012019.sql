--
-- PostgreSQL database dump
--

-- Dumped from database version 11.1
-- Dumped by pg_dump version 11.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: all_users(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.all_users() RETURNS TABLE(id integer, name character varying, surname character varying, username character varying, email character varying, avatar_src text)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT "User".id, "User".name, "User".surname, "User".username, "User".email, "User".avatar_src FROM "User";
END; $$;


ALTER FUNCTION public.all_users() OWNER TO postgres;

--
-- Name: comment_exist(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.comment_exist(_id_post integer, _logined_user integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
count_row integer;
BEGIN
	select count(*) from "Comment" into count_row where id_post = _id_post and id_user = _logined_user;

	if(count_row = 0) then
		return false;
	else
		return true;
	end if;
end;
$$;


ALTER FUNCTION public.comment_exist(_id_post integer, _logined_user integer) OWNER TO postgres;

--
-- Name: count_liked(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.count_liked(_username character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
res integer;
begin
	select count(*) from "Like" into res where id_user=get_user_id(_username);
	return res;
end;
$$;


ALTER FUNCTION public.count_liked(_username character varying) OWNER TO postgres;

--
-- Name: count_posts(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.count_posts(_username character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$

declare

res integer;

begin

	select count(*) from "Post" into res where id_user=get_user_id(_username);

	return res;

end;

$$;


ALTER FUNCTION public.count_posts(_username character varying) OWNER TO postgres;

--
-- Name: count_subscribers(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.count_subscribers(_username character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
res integer;
begin
	select count(*) from "Subscribe" into res where id_user_subscribe=get_user_id(_username);
	return res-1;
end;
$$;


ALTER FUNCTION public.count_subscribers(_username character varying) OWNER TO postgres;

--
-- Name: count_subscribtion(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.count_subscribtion(_username character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
res integer;
begin
	select count(*) from "Subscribe" into res where id_user=get_user_id(_username);
	return res-1;
end;
$$;


ALTER FUNCTION public.count_subscribtion(_username character varying) OWNER TO postgres;

--
-- Name: create_post(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_post(_user_id integer, _post_text text) RETURNS integer
    LANGUAGE plpgsql
    AS $$

DECLARE
_post_id INTEGER;
BEGIN
	IF _post_text IS NULL OR length(_post_text) = 0 THEN
		RAISE 'Post content is null or empty';
	END IF;
	
	INSERT INTO "Post" (id_user, content) VALUES (_user_id, _post_text) RETURNING "Post".id INTO _post_id;
	RETURN _post_id;
EXCEPTION
	WHEN foreign_key_violation THEN RAISE 'topic not exist';
END

$$;


ALTER FUNCTION public.create_post(_user_id integer, _post_text text) OWNER TO postgres;

--
-- Name: create_user(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_user(_name character varying, _surname character varying, _username character varying, _password character varying, _email character varying) RETURNS TABLE(id integer, name character varying, surname character varying, username character varying, email character varying, password character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	IF _email IS NULL OR length(_email) = 0 THEN
		RAISE NOTICE 'Email is null or empty';
	END IF;
	IF _name IS NULL OR length(_name) = 0 THEN
		RAISE NOTICE 'Name is null or empty';
	END IF;
    IF _surname IS NULL OR length(_surname) = 0 THEN
		RAISE NOTICE 'Surname is null or empty';
	END IF;
	IF _password IS NULL or length(_password) = 0 THEN
		RAISE NOTICE 'Password is null or empty';
	END IF;

	INSERT INTO "User" (name, surname, username, password, email)
	VALUES 
	(_name, _surname, _username, _password, _email);
	insert into "Subscribe" (id_user, id_user_subscribe)
	values
	(get_user_id(_username), get_user_id(_username));
	RETURN QUERY 
		SELECT "User".id, "User".name, "User".surname, "User".username, "User".email, "User".password
		FROM public."User"
		WHERE "User".username = _username; 
END;
$$;


ALTER FUNCTION public.create_user(_name character varying, _surname character varying, _username character varying, _password character varying, _email character varying) OWNER TO postgres;

--
-- Name: delete_post(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_post(_post_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN
	DELETE from "Post" WHERE id = _post_id;
END

$$;


ALTER FUNCTION public.delete_post(_post_id integer) OWNER TO postgres;

--
-- Name: get_all_posts(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_posts(_logined_user integer) RETURNS TABLE(id integer, id_user integer, firstname character varying, surname character varying, username character varying, avatar_user text, content text, date timestamp without time zone, likes integer, comments integer, my_like boolean, my_comment boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY select "Post".id, 
 					 "Post".id_user, 
 					 "User".name,
 					 "User".surname, 
 					 "User".username, 
 					 "User".avatar_src, 
 					 "Post".content, 
 					 "Post".date, 
 					 get_count_likes_post("Post".id), 
 					 get_count_comments_post("Post".id), 
 					 like_exist("Post".id, _logined_user), 
 					 comment_exist("Post".id, _logined_user)
			  FROM "Post"
			  join "Subscribe" on ("Subscribe".id_user = _logined_user and "Post".id_user = "Subscribe".id_user_subscribe)
			  join "User" on ("User".id = "Post".id_user)
			  GROUP BY "Post".id, "User".id
			  order by "Post".date desc;
end;
$$;


ALTER FUNCTION public.get_all_posts(_logined_user integer) OWNER TO postgres;

--
-- Name: get_all_user_posts(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_user_posts(_current_user integer) RETURNS TABLE(id integer, content text, date timestamp without time zone, likes bigint, comments bigint, my_like boolean, my_comment boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT "Post".id, "Post".content, "Post".date, COUNT("Like".id), COUNT("Comment".id), CASE 
            	WHEN "Like".id_user = _current_user
               		THEN true
               		ELSE false 
       			END as my_like,
       			CASE 
            	WHEN "Comment".id_user = _current_user
               		THEN true
               		ELSE false 
       			END as my_comment
			  FROM "Post"
			  left join "Like" on ("Like".id_post = "Post".id)
			  left join "Comment" on ("Comment".id_post = "Post".id)
			  where "Post".id_user = _current_user
			  GROUP BY "Post".id, "Like".id_user, "Comment".id_user;
end;
$$;


ALTER FUNCTION public.get_all_user_posts(_current_user integer) OWNER TO postgres;

--
-- Name: get_all_user_posts(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_user_posts(_current_user character varying) RETURNS TABLE(id integer, content text, date timestamp without time zone, likes bigint, comments bigint, my_like boolean, my_comment boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT "Post".id, "Post".content, "Post".date, COUNT("Like".id), COUNT("Comment".id), CASE 
            	WHEN "Like".id_user = get_user_id(_current_user)
               		THEN true
               		ELSE false 
       			END as my_like,
       			CASE 
            	WHEN "Comment".id_user = get_user_id(_current_user)
               		THEN true
               		ELSE false 
       			END as my_comment
			  FROM "Post"
			  left join "Like" on ("Like".id_post = "Post".id)
			  left join "Comment" on ("Comment".id_post = "Post".id)
			  where "Post".id_user = get_user_id(_current_user)
			  GROUP BY "Post".id, "Like".id_user, "Comment".id_user;
end;
$$;


ALTER FUNCTION public.get_all_user_posts(_current_user character varying) OWNER TO postgres;

--
-- Name: get_all_user_posts(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_user_posts(_current_user character varying, _logined_user integer) RETURNS TABLE(id integer, content text, date timestamp without time zone, likes integer, comments integer, my_like boolean, my_comment boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT "Post".id, "Post".content, "Post".date, get_count_likes_post("Post".id), get_count_comments_post("Post".id), like_exist("Post".id, _logined_user), comment_exist("Post".id, _logined_user)
			  FROM "Post"
			  where "Post".id_user = get_user_id(_current_user)
			  order by "Post".date DESC;
end;
$$;


ALTER FUNCTION public.get_all_user_posts(_current_user character varying, _logined_user integer) OWNER TO postgres;

--
-- Name: get_count_comments_post(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_count_comments_post(_id_post integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
res integer;
BEGIN
	select count(*) from "Comment" into res where id_post=_id_post;
	return res;
end;
$$;


ALTER FUNCTION public.get_count_comments_post(_id_post integer) OWNER TO postgres;

--
-- Name: get_count_likes_post(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_count_likes_post(_id_post integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
res integer;
BEGIN
	select count(*) from "Like" into res where id_post=_id_post;
	return res;
end;
$$;


ALTER FUNCTION public.get_count_likes_post(_id_post integer) OWNER TO postgres;

--
-- Name: get_post_comments(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_post_comments(_post_id integer) RETURNS TABLE(id_comment integer, content text, date timestamp with time zone, id_user integer, firstname character varying, surname character varying, username character varying, email character varying, avatar_src text)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT "Comment".id, "Comment".content, "Comment".date, "Comment".id_user, "User".name, "User".surname, "User".username, "User".email, "User".avatar_src 
 from "Comment" 
 left join "User" on ("Comment".id_user = "User".id)
 where "Comment".id_post = _post_id;
END; $$;


ALTER FUNCTION public.get_post_comments(_post_id integer) OWNER TO postgres;

--
-- Name: get_user_id(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_id(_username character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
res integer;
begin
	select id from "User" into res where "User".username = _username;
	return res;
end
$$;


ALTER FUNCTION public.get_user_id(_username character varying) OWNER TO postgres;

--
-- Name: get_user_profile(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_profile(_username character varying) RETURNS TABLE(id integer, firstname character varying, surname character varying, username character varying, email character varying, password character varying, avatar_src text)
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
	RETURN QUERY 
		SELECT "User".id, "User".name, "User".surname, "User".username, "User".email, "User".password, "User".avatar_src
		FROM public."User"
		WHERE "User".username = _username; 
END; 
$$;


ALTER FUNCTION public.get_user_profile(_username character varying) OWNER TO postgres;

--
-- Name: get_user_profile_by_id(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_profile_by_id(_id integer) RETURNS TABLE(id integer, name character varying, surname character varying, username character varying, email character varying, password character varying, avatar_src text)
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
	RETURN QUERY 
		SELECT "User".id, "User".name, "User".surname, "User".username, "User".email, "User".password, "User".avatar_src
		FROM public."User"
		WHERE "User".id = _id; 
END; 
$$;


ALTER FUNCTION public.get_user_profile_by_id(_id integer) OWNER TO postgres;

--
-- Name: get_user_stats(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_stats(_username character varying) RETURNS TABLE(subscribtion integer, subscribes integer, posts integer, likes integer)
    LANGUAGE sql
    AS $$ 
	select count_subscribtion(_username), count_subscribers(_username), count_posts(_username), count_liked(_username);
$$;


ALTER FUNCTION public.get_user_stats(_username character varying) OWNER TO postgres;

--
-- Name: is_subscribe(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_subscribe(_current_username character varying, _username character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
res boolean;
begin
	SELECT EXISTS (SELECT id_user, id_user_subscribe from "Subscribe" where id_user = get_user_id(_current_username) and id_user_subscribe = get_user_id(_username)) into res;
	return res;
end;

$$;


ALTER FUNCTION public.is_subscribe(_current_username character varying, _username character varying) OWNER TO postgres;

--
-- Name: like(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."like"(_current_user integer, _post_like integer) RETURNS TABLE(id integer, id_user integer, id_user_subscribe integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

	INSERT INTO "Like" (id_user, id_post)
	VALUES 
	(_current_user, _post_like);

	RETURN QUERY 
		SELECT "Like".id, "Like".id_user, "Like".id_post
		FROM public."Like"
		WHERE "Like".id_user = _current_user and "Like".id_post = _post_like; 
END;
$$;


ALTER FUNCTION public."like"(_current_user integer, _post_like integer) OWNER TO postgres;

--
-- Name: like_exist(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.like_exist(_id_post integer, _logined_user integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
declare
count_row integer;
begin
	select count(*) from "Like" into count_row where id_post = _id_post and id_user = _logined_user;

	if(count_row = 0) then
		return false;
	else
		return true;
	end if;
end;
$$;


ALTER FUNCTION public.like_exist(_id_post integer, _logined_user integer) OWNER TO postgres;

--
-- Name: subscribe(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.subscribe(_current_user integer, _user_subscribe integer) RETURNS TABLE(id integer, id_user integer, id_user_subscribe integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

	INSERT INTO "Subscribe" (id_user, id_user_subscribe)
	VALUES 
	(_current_user, _user_subscribe);

	RETURN QUERY 
		SELECT "Subscribe".id, "Subscribe".id_user, "Subscribe".id_user_subscribe 
		FROM public."Subscribe"
		WHERE "Subscribe".id_user = _current_user and "Subscribe".id_user_subscribe = _user_subscribe; 
END;
$$;


ALTER FUNCTION public.subscribe(_current_user integer, _user_subscribe integer) OWNER TO postgres;

--
-- Name: unlike(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.unlike(_current_user_id integer, _post_like integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN
	DELETE from "Like" WHERE id_user = _current_user_id and id_post = _post_like;
end;

$$;


ALTER FUNCTION public.unlike(_current_user_id integer, _post_like integer) OWNER TO postgres;

--
-- Name: unsubscribe(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.unsubscribe(_current_user_id integer, _user_subscribe_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$

BEGIN
	DELETE from "Subscribe" WHERE id_user = _current_user_id and id_user_subscribe = _user_subscribe_id;
END

$$;


ALTER FUNCTION public.unsubscribe(_current_user_id integer, _user_subscribe_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Comment" (
    id integer NOT NULL,
    id_user integer,
    id_post integer,
    content text,
    date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public."Comment" OWNER TO postgres;

--
-- Name: Comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Comment_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Comment_id_seq" OWNER TO postgres;

--
-- Name: Comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Comment_id_seq" OWNED BY public."Comment".id;


--
-- Name: Like; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Like" (
    id integer NOT NULL,
    id_user integer,
    id_post integer
);


ALTER TABLE public."Like" OWNER TO postgres;

--
-- Name: Like_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Like_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Like_id_seq" OWNER TO postgres;

--
-- Name: Like_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Like_id_seq" OWNED BY public."Like".id;


--
-- Name: Poll; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Poll" (
    id integer NOT NULL,
    id_post integer,
    body json
);


ALTER TABLE public."Poll" OWNER TO postgres;

--
-- Name: Poll_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Poll_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Poll_id_seq" OWNER TO postgres;

--
-- Name: Poll_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Poll_id_seq" OWNED BY public."Poll".id;


--
-- Name: Post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Post" (
    id integer NOT NULL,
    id_user integer,
    content text,
    date timestamp without time zone DEFAULT now()
);


ALTER TABLE public."Post" OWNER TO postgres;

--
-- Name: Post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Post_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Post_id_seq" OWNER TO postgres;

--
-- Name: Post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Post_id_seq" OWNED BY public."Post".id;


--
-- Name: Subscribe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Subscribe" (
    id integer NOT NULL,
    id_user integer,
    id_user_subscribe integer
);


ALTER TABLE public."Subscribe" OWNER TO postgres;

--
-- Name: Subscribe_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Subscribe_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Subscribe_id_seq" OWNER TO postgres;

--
-- Name: Subscribe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Subscribe_id_seq" OWNED BY public."Subscribe".id;


--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id integer NOT NULL,
    name character varying,
    surname character varying,
    username character varying,
    password character varying,
    email character varying,
    avatar_src text DEFAULT 'img/users/default.png'::text
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."User_id_seq" OWNER TO postgres;

--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- Name: Vote; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Vote" (
    id integer NOT NULL,
    id_poll integer,
    id_user integer,
    answer integer
);


ALTER TABLE public."Vote" OWNER TO postgres;

--
-- Name: Vote_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Vote_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Vote_id_seq" OWNER TO postgres;

--
-- Name: Vote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Vote_id_seq" OWNED BY public."Vote".id;


--
-- Name: Comment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comment" ALTER COLUMN id SET DEFAULT nextval('public."Comment_id_seq"'::regclass);


--
-- Name: Like id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Like" ALTER COLUMN id SET DEFAULT nextval('public."Like_id_seq"'::regclass);


--
-- Name: Poll id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Poll" ALTER COLUMN id SET DEFAULT nextval('public."Poll_id_seq"'::regclass);


--
-- Name: Post id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Post" ALTER COLUMN id SET DEFAULT nextval('public."Post_id_seq"'::regclass);


--
-- Name: Subscribe id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Subscribe" ALTER COLUMN id SET DEFAULT nextval('public."Subscribe_id_seq"'::regclass);


--
-- Name: User id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- Name: Vote id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Vote" ALTER COLUMN id SET DEFAULT nextval('public."Vote_id_seq"'::regclass);


--
-- Data for Name: Comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Comment" (id, id_user, id_post, content, date) FROM stdin;
\.


--
-- Data for Name: Like; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Like" (id, id_user, id_post) FROM stdin;
\.


--
-- Data for Name: Poll; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Poll" (id, id_post, body) FROM stdin;
\.


--
-- Data for Name: Post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Post" (id, id_user, content, date) FROM stdin;
1	1	Мой первый пост	2019-01-09 18:18:09.58766
\.


--
-- Data for Name: Subscribe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Subscribe" (id, id_user, id_user_subscribe) FROM stdin;
1	1	1
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, name, surname, username, password, email, avatar_src) FROM stdin;
1	Денис	Цветков	Cvetkoff	$2a$08$JHstViuA.hof10MuUd9nruWyGNLHtvXEYenQQKolDgRUnaq6HVoGi	denis.tsvetkov59@gmail.com	img/users/_Cvetkoff.jpg
\.


--
-- Data for Name: Vote; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Vote" (id, id_poll, id_user, answer) FROM stdin;
\.


--
-- Name: Comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Comment_id_seq"', 1, false);


--
-- Name: Like_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Like_id_seq"', 1, false);


--
-- Name: Poll_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Poll_id_seq"', 1, false);


--
-- Name: Post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Post_id_seq"', 1, true);


--
-- Name: Subscribe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Subscribe_id_seq"', 1, true);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_id_seq"', 1, true);


--
-- Name: Vote_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Vote_id_seq"', 1, false);


--
-- Name: Comment Comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Comment"
    ADD CONSTRAINT "Comment_pkey" PRIMARY KEY (id);


--
-- Name: Like Like_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Like"
    ADD CONSTRAINT "Like_pkey" PRIMARY KEY (id);


--
-- Name: Poll Poll_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Poll"
    ADD CONSTRAINT "Poll_pkey" PRIMARY KEY (id);


--
-- Name: Post Post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_pkey" PRIMARY KEY (id);


--
-- Name: Subscribe Subscribe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Subscribe"
    ADD CONSTRAINT "Subscribe_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: Vote Vote_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Vote"
    ADD CONSTRAINT "Vote_pkey" PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

