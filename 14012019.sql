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
-- Name: count_votes(integer, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.count_votes(_id_poll integer, _poll_body json) RETURNS integer[]
    LANGUAGE plpgsql
    AS $$

declare
i integer;
res int[];
count_votes integer;
begin
if _poll_body is null then
	return res;
end if;
 FOR i IN 0 .. json_array_length(_poll_body)-1
   LOOP
      select count(*) from "Vote" into count_votes where id_poll = _id_poll and answer = i;
   	res := array_append(res, count_votes);
   END LOOP;
 return res;
end;

$$;


ALTER FUNCTION public.count_votes(_id_poll integer, _poll_body json) OWNER TO postgres;

--
-- Name: create_poll(integer, json); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_poll(_post_id integer, _poll_body json) RETURNS integer
    LANGUAGE plpgsql
    AS $$

DECLARE
_poll_id INTEGER;
BEGIN
	IF _poll_body IS NULL THEN
		RAISE 'Post content is null or empty';
	END IF;
	
	INSERT INTO "Poll" (id_post, body) VALUES (_post_id, _poll_body) RETURNING "Poll".id INTO _poll_id;
	RETURN _poll_id;
EXCEPTION
	WHEN foreign_key_violation THEN RAISE 'poll not exist';
END

$$;


ALTER FUNCTION public.create_poll(_post_id integer, _poll_body json) OWNER TO postgres;

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

CREATE FUNCTION public.get_all_posts(_logined_user integer) RETURNS TABLE(id integer, id_user integer, firstname character varying, surname character varying, username character varying, avatar_user text, content text, date timestamp without time zone, likes integer, comments integer, my_like boolean, my_comment boolean, poll_id integer, poll_body json, my_vote integer, votes integer[])
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
 					 comment_exist("Post".id, _logined_user),
 					 "Poll".id,
 					 "Poll".body,
 					 vote_exist("Poll".id, _logined_user),
 					 count_votes("Poll".id, "Poll".body)
			  FROM "Post"
			  join "Subscribe" on ("Subscribe".id_user = _logined_user and "Post".id_user = "Subscribe".id_user_subscribe)
			  join "User" on ("User".id = "Post".id_user)
			  left join "Poll" on "Poll".id_post = "Post".id
			  GROUP BY "Post".id, "User".id, "Poll".id
			  order by "Post".date desc;
end;
$$;


ALTER FUNCTION public.get_all_posts(_logined_user integer) OWNER TO postgres;

--
-- Name: get_all_user_posts(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_user_posts(_current_user character varying, _logined_user integer) RETURNS TABLE(id integer, content text, date timestamp without time zone, likes integer, comments integer, my_like boolean, my_comment boolean, poll_id integer, poll_body json, my_vote integer, votes integer[])
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT "Post".id,
 					 "Post".content,
 					 "Post".date,
 					 get_count_likes_post("Post".id),
 					 get_count_comments_post("Post".id),
 					 like_exist("Post".id, _logined_user),
 					 comment_exist("Post".id, _logined_user),
 					 "Poll".id,
 					 "Poll".body,
 					 vote_exist("Poll".id, _logined_user),
 					 count_votes("Poll".id, "Poll".body)
			  FROM "Post"
			  left join "Poll" on "Poll".id_post = "Post".id
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

--
-- Name: vote(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.vote(_logined_user integer, _id_poll integer, _answer integer) RETURNS TABLE(id integer, id_poll integer, id_user integer, answer integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

	INSERT INTO "Vote" (id_poll, id_user, answer)
	VALUES 
	(_id_poll, _logined_user, _answer);

	RETURN QUERY 
		SELECT "Vote".id, "Vote".id_poll, "Vote".id_user, "Vote".answer
		FROM public."Vote"
		WHERE "Vote".id_user = _logined_user and "Vote".id_poll = _id_poll; 
END;
$$;


ALTER FUNCTION public.vote(_logined_user integer, _id_poll integer, _answer integer) OWNER TO postgres;

--
-- Name: vote_exist(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.vote_exist(_id_poll integer, _logined_user integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
res_answer integer;
begin
	select answer from "Vote" into res_answer where id_poll = _id_poll and id_user = _logined_user;
	return res_answer;
end;
$$;


ALTER FUNCTION public.vote_exist(_id_poll integer, _logined_user integer) OWNER TO postgres;

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
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
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
1	30	["PHP","JavaScript"]
2	31	["Рисование","Музыка","Спорт"]
3	32	["Рикардо","Милос","Рикардо Милос"]
5	38	["1","2"]
6	39	["1"]
\.


--
-- Data for Name: Post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Post" (id, id_user, content, date) FROM stdin;
20	1	должно работать	2019-01-13 14:04:59.526277
21	1	Голосование, славяне	2019-01-13 14:06:42.030111
22	1	ухух	2019-01-13 14:08:38.086062
23	1	Работает, славяне	2019-01-13 14:11:09.78668
24	1	Контрольная проверка, славяне	2019-01-13 14:12:35.183443
25	1	тест	2019-01-13 14:55:18.904385
26	1	тест2	2019-01-13 14:56:04.969836
27	1	тест3	2019-01-13 14:57:13.996845
28	1	Тест, славяне	2019-01-13 15:02:46.666795
29	1	тест 2, славяне	2019-01-13 15:04:04.884872
30	1	Тест 3, славяне	2019-01-13 15:04:41.55737
31	1	Проверка	2019-01-13 18:45:45.09843
32	1	Кто самый крутой?	2019-01-13 20:30:42.505526
33	4	Чек	2019-01-13 21:23:16.105074
34	4	чек2	2019-01-13 21:24:15.767356
35	4	чек2	2019-01-13 21:26:15.806304
36	2	чек	2019-01-13 21:28:36.243728
37	2	чек2	2019-01-13 21:28:49.932294
38	2	чек2	2019-01-13 21:29:12.645104
39	2	чекк	2019-01-13 21:31:11.975602
\.


--
-- Data for Name: Subscribe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Subscribe" (id, id_user, id_user_subscribe) FROM stdin;
1	1	1
2	2	2
3	3	3
4	4	4
5	4	1
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, name, surname, username, password, email, avatar_src) FROM stdin;
1	Денис	Цветков	Cvetkoff	$2a$08$JHstViuA.hof10MuUd9nruWyGNLHtvXEYenQQKolDgRUnaq6HVoGi	denis.tsvetkov59@gmail.com	img/users/_Cvetkoff.jpg
2	Савелий	Вепрев	nakazan	$2a$08$LsFtexSSDoGXjBtom/d2m.AMWgSuaFEMq1xNqwRrhX5K6cV1iikAO	nakazan@gmail.com	img/users/default.png
3	Светлана	Цветкова	svetlana	$2a$08$tJOwdv44S8x0LZQqXl9DT.g5Hs28YGZbaUw8IrTHL3pKjXrBhoucO	sv-cv@mail.ru	img/users/default.png
4	Максим	Хохряков	max	$2a$08$e2sGNKFBcaWXBhRelioBp.a1tnD3cJYkIW523nyBERWZj1NUbTglq	max@gmail.com	img/users/default.png
\.


--
-- Data for Name: Vote; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Vote" (id, id_poll, id_user, answer) FROM stdin;
1	1	1	1
2	2	1	1
3	2	2	0
4	1	2	0
5	3	1	2
6	3	3	0
7	3	2	1
8	2	4	1
9	3	4	2
10	6	2	0
11	6	1	0
\.


--
-- Name: Comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Comment_id_seq"', 1, false);


--
-- Name: Like_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Like_id_seq"', 2, true);


--
-- Name: Poll_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Poll_id_seq"', 6, true);


--
-- Name: Post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Post_id_seq"', 39, true);


--
-- Name: Subscribe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Subscribe_id_seq"', 5, true);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_id_seq"', 4, true);


--
-- Name: Vote_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Vote_id_seq"', 11, true);


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

