--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.2)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.2)

-- Started on 2024-11-17 15:47:16 EET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 26490)
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    course_id integer NOT NULL,
    title character varying(100) NOT NULL,
    description text,
    teacher_id integer,
    status character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    price numeric(10,2) DEFAULT 0.00,
    CONSTRAINT courses_status_check CHECK (((status)::text = ANY ((ARRAY['published'::character varying, 'draft'::character varying])::text[])))
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 26489)
-- Name: courses_course_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.courses_course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.courses_course_id_seq OWNER TO postgres;

--
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 219
-- Name: courses_course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.courses_course_id_seq OWNED BY public.courses.course_id;


--
-- TOC entry 224 (class 1259 OID 26523)
-- Name: enrollments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrollments (
    enrollment_id integer NOT NULL,
    student_id integer,
    course_id integer,
    enrollment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20),
    completion_percentage numeric(5,2) DEFAULT 0.00,
    CONSTRAINT enrollments_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'completed'::character varying, 'dropped'::character varying])::text[])))
);


ALTER TABLE public.enrollments OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 26522)
-- Name: enrollments_enrollment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enrollments_enrollment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.enrollments_enrollment_id_seq OWNER TO postgres;

--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 223
-- Name: enrollments_enrollment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.enrollments_enrollment_id_seq OWNED BY public.enrollments.enrollment_id;


--
-- TOC entry 226 (class 1259 OID 26545)
-- Name: lesson_completion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson_completion (
    completion_id integer NOT NULL,
    student_id integer,
    lesson_id integer,
    is_completed boolean DEFAULT false NOT NULL,
    completion_date timestamp without time zone,
    last_accessed_date timestamp without time zone
);


ALTER TABLE public.lesson_completion OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 26544)
-- Name: lesson_completion_completion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_completion_completion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lesson_completion_completion_id_seq OWNER TO postgres;

--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 225
-- Name: lesson_completion_completion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_completion_completion_id_seq OWNED BY public.lesson_completion.completion_id;


--
-- TOC entry 222 (class 1259 OID 26507)
-- Name: lessons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lessons (
    lesson_id integer NOT NULL,
    title character varying(100) NOT NULL,
    description text,
    course_id integer,
    lesson_number integer NOT NULL,
    duration_minutes integer,
    content_type character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.lessons OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 26506)
-- Name: lessons_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lessons_lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lessons_lesson_id_seq OWNER TO postgres;

--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 221
-- Name: lessons_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lessons_lesson_id_seq OWNED BY public.lessons.lesson_id;


--
-- TOC entry 216 (class 1259 OID 26468)
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    student_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 26467)
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_student_id_seq OWNER TO postgres;

--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 215
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;


--
-- TOC entry 218 (class 1259 OID 26479)
-- Name: teachers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teachers (
    teacher_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.teachers OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 26478)
-- Name: teachers_teacher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teachers_teacher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teachers_teacher_id_seq OWNER TO postgres;

--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 217
-- Name: teachers_teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teachers_teacher_id_seq OWNED BY public.teachers.teacher_id;


--
-- TOC entry 3314 (class 2604 OID 26493)
-- Name: courses course_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses ALTER COLUMN course_id SET DEFAULT nextval('public.courses_course_id_seq'::regclass);


--
-- TOC entry 3321 (class 2604 OID 26526)
-- Name: enrollments enrollment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments ALTER COLUMN enrollment_id SET DEFAULT nextval('public.enrollments_enrollment_id_seq'::regclass);


--
-- TOC entry 3324 (class 2604 OID 26548)
-- Name: lesson_completion completion_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_completion ALTER COLUMN completion_id SET DEFAULT nextval('public.lesson_completion_completion_id_seq'::regclass);


--
-- TOC entry 3318 (class 2604 OID 26510)
-- Name: lessons lesson_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons ALTER COLUMN lesson_id SET DEFAULT nextval('public.lessons_lesson_id_seq'::regclass);


--
-- TOC entry 3308 (class 2604 OID 26471)
-- Name: students student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- TOC entry 3311 (class 2604 OID 26482)
-- Name: teachers teacher_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers ALTER COLUMN teacher_id SET DEFAULT nextval('public.teachers_teacher_id_seq'::regclass);


--
-- TOC entry 3502 (class 0 OID 26490)
-- Dependencies: 220
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (course_id, title, description, teacher_id, status, created_at, updated_at, price) FROM stdin;
2	Python Programming	Learn Python from scratch	1	published	2024-11-17 14:12:12.322726	2024-11-17 14:12:12.322726	99.99
3	Web Development	Full-stack web development course	2	published	2024-11-17 14:12:12.322726	2024-11-17 14:12:12.322726	149.99
4	Data Science Basics	Introduction to Data Science	1	published	2024-11-17 14:12:12.322726	2024-11-17 14:12:12.322726	199.99
5	JavaScript Advanced	Advanced JavaScript concepts	3	published	2024-11-17 14:12:12.322726	2024-11-17 14:12:12.322726	129.99
\.


--
-- TOC entry 3506 (class 0 OID 26523)
-- Dependencies: 224
-- Data for Name: enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enrollments (enrollment_id, student_id, course_id, enrollment_date, status, completion_percentage) FROM stdin;
1	1	5	2024-11-17 14:52:36.480637	active	66.67
2	1	2	2024-11-17 14:52:36.480637	active	33.33
3	2	5	2024-11-17 14:52:36.480637	completed	100.00
4	3	3	2024-11-17 14:52:36.480637	active	66.67
5	4	2	2024-11-17 14:52:36.480637	dropped	33.33
6	5	4	2024-11-17 14:52:36.480637	active	50.00
7	2	3	2024-11-17 14:52:36.480637	active	25.00
\.


--
-- TOC entry 3508 (class 0 OID 26545)
-- Dependencies: 226
-- Data for Name: lesson_completion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson_completion (completion_id, student_id, lesson_id, is_completed, completion_date, last_accessed_date) FROM stdin;
25	1	13	t	\N	\N
26	1	14	t	\N	\N
27	1	15	f	\N	\N
28	2	13	t	\N	\N
29	2	14	t	\N	\N
30	2	15	t	\N	\N
31	3	17	t	\N	\N
32	3	18	t	\N	\N
33	3	19	f	\N	\N
34	4	14	t	\N	\N
35	4	15	f	\N	\N
36	4	16	f	\N	\N
\.


--
-- TOC entry 3504 (class 0 OID 26507)
-- Dependencies: 222
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lessons (lesson_id, title, description, course_id, lesson_number, duration_minutes, content_type, created_at, updated_at) FROM stdin;
13	Python Basics	Introduction to Python	2	1	60	video	2024-11-17 14:48:14.180871	2024-11-17 14:48:14.180871
14	Variables and Data Types	Understanding Python data types	2	2	45	video	2024-11-17 14:48:14.180871	2024-11-17 14:48:14.180871
15	Control Structures	If statements and loops	2	3	90	video	2024-11-17 14:48:14.180871	2024-11-17 14:48:14.180871
16	HTML Fundamentals	Basic HTML structure	3	1	60	video	2024-11-17 14:48:14.180871	2024-11-17 14:48:14.180871
17	CSS Styling	Styling web pages	3	2	75	video	2024-11-17 14:48:14.180871	2024-11-17 14:48:14.180871
18	JavaScript Basics	Introduction to JavaScript	3	3	90	video	2024-11-17 14:48:14.180871	2024-11-17 14:48:14.180871
19	Intro to Data Science	Overview of Data Science	4	1	60	video	2024-11-17 14:48:14.180871	2024-11-17 14:48:14.180871
20	Python for Data Science	Using Python in Data Science	4	2	90	video	2024-11-17 14:48:14.180871	2024-11-17 14:48:14.180871
21	Basic Statistics	Statistical concepts	4	3	120	video	2024-11-17 14:48:14.180871	2024-11-17 14:48:14.180871
22	Advanced Functions	Closures and Callbacks	5	1	90	video	2024-11-17 14:48:14.180871	2024-11-17 14:48:14.180871
23	Promises & Async	Asynchronous JavaScript	5	2	120	video	2024-11-17 14:48:14.180871	2024-11-17 14:48:14.180871
24	Design Patterns	JavaScript Patterns	4	3	150	video	2024-11-17 14:48:14.180871	2024-11-17 14:48:14.180871
\.


--
-- TOC entry 3498 (class 0 OID 26468)
-- Dependencies: 216
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (student_id, first_name, last_name, email, created_at, updated_at) FROM stdin;
1	Elsaeed	Ahmed	elsaeedahmed@email.com	2024-11-17 14:08:07.94347	2024-11-17 14:08:07.94347
2	Ahmed	Mohammed	ahmedmohammedh@email.com	2024-11-17 14:08:07.94347	2024-11-17 14:08:07.94347
3	Ahmed	Omar	omarahmed@email.com	2024-11-17 14:08:07.94347	2024-11-17 14:08:07.94347
4	Ibrahim	Elhussieny	ibrahim95@email.com	2024-11-17 14:08:07.94347	2024-11-17 14:08:07.94347
5	Ahmed	Aly	ahmedaly@email.com	2024-11-17 14:08:07.94347	2024-11-17 14:08:07.94347
\.


--
-- TOC entry 3500 (class 0 OID 26479)
-- Dependencies: 218
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teachers (teacher_id, first_name, last_name, email, created_at, updated_at) FROM stdin;
1	Ammar	Ahmed	testahmed12@email.com	2024-11-17 14:09:21.464983	2024-11-17 14:09:21.464983
2	Omar	Mohammed	ahmedmohammedh12@email.com	2024-11-17 14:09:21.464983	2024-11-17 14:09:21.464983
3	Saeed	Omar	omarahmed12@email.com	2024-11-17 14:09:21.464983	2024-11-17 14:09:21.464983
4	Ibrahim	mohamed	ibrahim9512@email.com	2024-11-17 14:09:21.464983	2024-11-17 14:09:21.464983
5	Aly	Ahmed	ahmedaly12@email.com	2024-11-17 14:09:21.464983	2024-11-17 14:09:21.464983
\.


--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 219
-- Name: courses_course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.courses_course_id_seq', 5, true);


--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 223
-- Name: enrollments_enrollment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enrollments_enrollment_id_seq', 7, true);


--
-- TOC entry 3522 (class 0 OID 0)
-- Dependencies: 225
-- Name: lesson_completion_completion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_completion_completion_id_seq', 36, true);


--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 221
-- Name: lessons_lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lessons_lesson_id_seq', 24, true);


--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 215
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_student_id_seq', 5, true);


--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 217
-- Name: teachers_teacher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teachers_teacher_id_seq', 5, true);


--
-- TOC entry 3337 (class 2606 OID 26500)
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- TOC entry 3341 (class 2606 OID 26531)
-- Name: enrollments enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_pkey PRIMARY KEY (enrollment_id);


--
-- TOC entry 3343 (class 2606 OID 26533)
-- Name: enrollments enrollments_student_id_course_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_student_id_course_id_key UNIQUE (student_id, course_id);


--
-- TOC entry 3345 (class 2606 OID 26551)
-- Name: lesson_completion lesson_completion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_completion
    ADD CONSTRAINT lesson_completion_pkey PRIMARY KEY (completion_id);


--
-- TOC entry 3347 (class 2606 OID 26553)
-- Name: lesson_completion lesson_completion_student_id_lesson_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_completion
    ADD CONSTRAINT lesson_completion_student_id_lesson_id_key UNIQUE (student_id, lesson_id);


--
-- TOC entry 3339 (class 2606 OID 26516)
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (lesson_id);


--
-- TOC entry 3329 (class 2606 OID 26477)
-- Name: students students_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_email_key UNIQUE (email);


--
-- TOC entry 3331 (class 2606 OID 26475)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- TOC entry 3333 (class 2606 OID 26488)
-- Name: teachers teachers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_email_key UNIQUE (email);


--
-- TOC entry 3335 (class 2606 OID 26486)
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (teacher_id);


--
-- TOC entry 3348 (class 2606 OID 26501)
-- Name: courses courses_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teachers(teacher_id);


--
-- TOC entry 3350 (class 2606 OID 26539)
-- Name: enrollments enrollments_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id);


--
-- TOC entry 3351 (class 2606 OID 26534)
-- Name: enrollments enrollments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- TOC entry 3352 (class 2606 OID 26559)
-- Name: lesson_completion lesson_completion_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_completion
    ADD CONSTRAINT lesson_completion_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(lesson_id);


--
-- TOC entry 3353 (class 2606 OID 26554)
-- Name: lesson_completion lesson_completion_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_completion
    ADD CONSTRAINT lesson_completion_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(student_id);


--
-- TOC entry 3349 (class 2606 OID 26517)
-- Name: lessons lessons_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(course_id);


-- Completed on 2024-11-17 15:47:16 EET

--
-- PostgreSQL database dump complete
--

