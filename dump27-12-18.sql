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
	return res;
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
	return res;
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
-- Name: get_all_user_posts(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_user_posts(_username character varying) RETURNS TABLE(id integer, content text, date timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT "Post".id, "Post".content, "Post".date FROM "Post" where id_user = get_user_id(_username) ORDER by date DESC;
END; $$;


ALTER FUNCTION public.get_all_user_posts(_username character varying) OWNER TO postgres;

--
-- Name: get_all_users(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_users() RETURNS TABLE(id integer, name character varying, surname character varying, login character varying, password character varying, email character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN QUERY SELECT id, name, surname, login, password, email FROM "User";
END; $$;


ALTER FUNCTION public.get_all_users() OWNER TO postgres;

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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Comment" (
    id integer NOT NULL,
    id_user integer,
    id_post integer,
    content text
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

COPY public."Comment" (id, id_user, id_post, content) FROM stdin;
\.


--
-- Data for Name: Like; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Like" (id, id_user, id_post) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
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
15	1	Первый пост	2018-12-17 21:11:03.838471
16	1	Здорова бандиты	2018-12-17 21:21:09.002066
18	1	Привет мир	2018-12-19 20:39:08.351285
23	15	ухуху	2018-12-26 20:50:27.503256
24	16	Первый пост. Я сделал выход из системы	2018-12-26 23:18:41.708455
25	17	Тестируем	2018-12-26 23:46:43.60598
\.


--
-- Data for Name: Subscribe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Subscribe" (id, id_user, id_user_subscribe) FROM stdin;
1	1	2
2	1	3
3	1	4
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, name, surname, username, password, email, avatar_src) FROM stdin;
16	Денис	Цветков	Cvetkoff	$2a$08$RzKa/f7iu9yr8TlW2mv4gOpH8a3weTMjv0rgB/8rdwO6ycOQ/FMue	denis.tsvetkov59@gmail.com	img/users/default.png
17	Савелий	Вепрев	nakazan	$2a$08$crJCln4o1LHeB1VBCNaFpuuFN2l9DJzrqQOw92sWDzVO5Y1fhaXU6	nakazan@gmail.com	img/users/default.png
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

SELECT pg_catalog.setval('public."Like_id_seq"', 4, true);


--
-- Name: Poll_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Poll_id_seq"', 1, false);


--
-- Name: Post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Post_id_seq"', 25, true);


--
-- Name: Subscribe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Subscribe_id_seq"', 3, true);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_id_seq"', 17, true);


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

