--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

-- Started on 2026-06-04 19:24:03

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

--
-- TOC entry 255 (class 1255 OID 17111)
-- Name: validachavepessoa(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validachavepessoa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE existe integer;

BEGIN
	existe = (SELECT COUNT (1) FROM pessoa_fisica WHERE id = NEW.pessoa_id);
	if(existe <= 0) then 
		existe = (SELECT COUNT (1) FROM pessoa_juridica WHERE id = NEW.pessoa_id);
	if(existe <= 0) then 
		RAISE EXCEPTION 'Não foi encontrado ID ou PK da pessoa para realizar a associação';
	 end if;
	end if;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.validachavepessoa() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16764)
-- Name: acesso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acesso (
    id bigint NOT NULL,
    descricao character varying(255) NOT NULL
);


ALTER TABLE public.acesso OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16952)
-- Name: avaliacao_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.avaliacao_produto (
    id bigint NOT NULL,
    descricao character varying(255),
    nota integer,
    pessoa_id bigint NOT NULL,
    produto_id bigint NOT NULL
);


ALTER TABLE public.avaliacao_produto OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16734)
-- Name: categoria_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria_produto (
    id bigint NOT NULL,
    nome_desc character varying(255)
);


ALTER TABLE public.categoria_produto OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16812)
-- Name: conta_pagar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conta_pagar (
    id bigint NOT NULL,
    dt_pagamento date,
    status_conta_receber character varying(255),
    valor_desconto numeric(19,2),
    pessoa_id bigint NOT NULL,
    descricao character varying(255) NOT NULL,
    dt_vencimento date NOT NULL,
    status character varying(255) NOT NULL,
    valor_total numeric(19,2) NOT NULL
);


ALTER TABLE public.conta_pagar OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16798)
-- Name: conta_receber; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conta_receber (
    id bigint NOT NULL,
    pessoa_id bigint NOT NULL,
    dt_pagamento date,
    valor_desconto numeric(19,2),
    descricao character varying(255) NOT NULL,
    dt_vencimento date NOT NULL,
    status_conta_receber character varying(255) NOT NULL,
    valor_total numeric(19,2) NOT NULL
);


ALTER TABLE public.conta_receber OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16820)
-- Name: cupom_desconto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cupom_desconto (
    id bigint NOT NULL,
    valor_porcent_desc numeric(19,2),
    valor_real_desc numeric(19,2),
    cod_desc character varying(255) NOT NULL,
    data_validade_cupom date NOT NULL
);


ALTER TABLE public.cupom_desconto OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 16963)
-- Name: endereco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.endereco (
    id bigint NOT NULL,
    bairro character varying(255) NOT NULL,
    cep character varying(255) NOT NULL,
    cidade character varying(255) NOT NULL,
    complemento character varying(255),
    numero character varying(255) NOT NULL,
    rua_logradouro character varying(255) NOT NULL,
    tipo_endereco character varying(255) NOT NULL,
    uf character varying(255) NOT NULL,
    pessoa_id bigint NOT NULL
);


ALTER TABLE public.endereco OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 25181)
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16806)
-- Name: forma_pagamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forma_pagamento (
    id bigint NOT NULL,
    descricao character varying(255) NOT NULL
);


ALTER TABLE public.forma_pagamento OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16837)
-- Name: imagem_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imagem_produto (
    id bigint NOT NULL,
    produto_id bigint NOT NULL,
    imagem_miniatura text NOT NULL,
    imagem_original text NOT NULL
);


ALTER TABLE public.imagem_produto OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16936)
-- Name: item_venda_loja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_venda_loja (
    id bigint NOT NULL,
    produto_id bigint NOT NULL,
    venda_compra_loja_virtual_id bigint NOT NULL,
    quantidade integer NOT NULL
);


ALTER TABLE public.item_venda_loja OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16723)
-- Name: marca_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marca_produto (
    id bigint NOT NULL,
    nome_desc character varying(255) NOT NULL
);


ALTER TABLE public.marca_produto OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16850)
-- Name: nota_fiscal_compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nota_fiscal_compra (
    id bigint NOT NULL,
    descricao_obs character varying(255),
    conta_pagar_id bigint NOT NULL,
    pessoa_id bigint NOT NULL,
    data_compra date NOT NULL,
    numero_nota character varying(255) NOT NULL,
    serie_nota character varying(255) NOT NULL,
    valor_icms numeric(19,2) NOT NULL,
    valor_total numeric(19,2) NOT NULL
);


ALTER TABLE public.nota_fiscal_compra OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16980)
-- Name: nota_fiscal_venda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nota_fiscal_venda (
    id bigint NOT NULL,
    numero character varying(255) NOT NULL,
    pdf text NOT NULL,
    serie character varying(255) NOT NULL,
    tipo character varying(255) NOT NULL,
    xml text NOT NULL,
    venda_compra_loja_virtual_id bigint
);


ALTER TABLE public.nota_fiscal_venda OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 16997)
-- Name: nota_item_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nota_item_produto (
    id bigint NOT NULL,
    quantidade double precision NOT NULL,
    nota_fiscal_compra_id bigint NOT NULL,
    produto_id bigint NOT NULL
);


ALTER TABLE public.nota_item_produto OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16739)
-- Name: pessoa_fisica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pessoa_fisica (
    id bigint NOT NULL,
    cpf character varying(255) NOT NULL,
    data_nascimento date,
    email character varying(255) NOT NULL,
    nome character varying(255) NOT NULL,
    telefone character varying(255) NOT NULL
);


ALTER TABLE public.pessoa_fisica OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 17024)
-- Name: pessoa_juridica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pessoa_juridica (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    nome character varying(255) NOT NULL,
    telefone character varying(255) NOT NULL,
    categoria character varying(255),
    cnpj character varying(255) NOT NULL,
    insc_estadual character varying(255) NOT NULL,
    insc_municipal character varying(255) NOT NULL,
    nome_fantasia character varying(255) NOT NULL,
    razao_social character varying(255) NOT NULL
);


ALTER TABLE public.pessoa_juridica OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17031)
-- Name: produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto (
    id bigint NOT NULL,
    alerta_qtd_estoque boolean,
    altura double precision NOT NULL,
    ativo boolean NOT NULL,
    descricao text NOT NULL,
    largura double precision NOT NULL,
    link_youtube character varying(255),
    nome character varying(255) NOT NULL,
    peso double precision NOT NULL,
    profundidade double precision NOT NULL,
    qtd_alerta_estoque integer,
    qtd_clique integer,
    qtd_estoque integer NOT NULL,
    tipo_unidade character varying(255) NOT NULL,
    valor_venda numeric(19,2) NOT NULL
);


ALTER TABLE public.produto OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16753)
-- Name: seq_acesso; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_acesso
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_acesso OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 16957)
-- Name: seq_avaliacao_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_avaliacao_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_avaliacao_produto OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16754)
-- Name: seq_categoria_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_categoria_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_categoria_produto OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16819)
-- Name: seq_conta_pagar; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_conta_pagar
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_conta_pagar OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16803)
-- Name: seq_conta_receber; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_conta_receber
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_conta_receber OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16827)
-- Name: seq_cupom_desconto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_cupom_desconto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_cupom_desconto OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16763)
-- Name: seq_endereco; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_endereco
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_endereco OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16811)
-- Name: seq_forma_pagamento; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_forma_pagamento
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_forma_pagamento OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16842)
-- Name: seq_imagem_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_imagem_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_imagem_produto OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16941)
-- Name: seq_item_venda_loja; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_item_venda_loja
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_item_venda_loja OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16728)
-- Name: seq_marca_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_marca_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_marca_produto OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16862)
-- Name: seq_nota_fiscal_compra; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_nota_fiscal_compra
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_nota_fiscal_compra OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16894)
-- Name: seq_nota_fiscal_venda; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_nota_fiscal_venda
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_nota_fiscal_venda OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16863)
-- Name: seq_nota_item_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_nota_item_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_nota_item_produto OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16833)
-- Name: seq_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_produto OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16884)
-- Name: seq_status_rastreio; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_status_rastreio
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_status_rastreio OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16783)
-- Name: seq_usuario; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_usuario
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_usuario OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16900)
-- Name: seq_venda_compra_loja_virtual; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_venda_compra_loja_virtual
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_venda_compra_loja_virtual OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16755)
-- Name: sqe_pessoa; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sqe_pessoa
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sqe_pessoa OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16879)
-- Name: status_rastreio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_rastreio (
    id bigint NOT NULL,
    centro_distribuicao character varying(255),
    cidade character varying(255),
    estado character varying(255),
    status character varying(255)
);


ALTER TABLE public.status_rastreio OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 17058)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id bigint NOT NULL,
    data_atual_senha date NOT NULL,
    login character varying(255) NOT NULL,
    senha character varying(255) NOT NULL,
    pessoa_id bigint NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16776)
-- Name: usuario_acesso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_acesso (
    usuario_id bigint NOT NULL,
    acesso_id bigint NOT NULL
);


ALTER TABLE public.usuario_acesso OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 17070)
-- Name: venda_compra_loja_virtual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venda_compra_loja_virtual (
    id bigint NOT NULL,
    data_entrega date NOT NULL,
    data_venda date NOT NULL,
    dia_entrega integer NOT NULL,
    valor_desconto numeric(19,2),
    valor_frete numeric(19,2) NOT NULL,
    valor_total numeric(19,2) NOT NULL,
    cupom_desconto_id bigint,
    endereco_cobranca_id bigint,
    endereco_entrega_id bigint,
    forma_pagamento_id bigint NOT NULL,
    nota_fiscal_venda_id bigint NOT NULL,
    pessoa_id bigint
);


ALTER TABLE public.venda_compra_loja_virtual OWNER TO postgres;

--
-- TOC entry 3503 (class 0 OID 16764)
-- Dependencies: 222
-- Data for Name: acesso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.acesso (id, descricao) FROM stdin;
1	ROLE_ADMIN
2	ROLE_ADMIN
3	ROLE_ADMIN
4	ROLE_ADMIN
5	ROLE_ADMIN
6	ROLE_ADMIN
9	ROLE_ADMIN
10	ROLE_ADMIN
11	ROLE_ADMIN
12	ROLE_ADMIN
15	ROLE_COMPRADOR
17	ROLE_COMPRADOR
19	ROLE_COMPRADOR
21	ROLE_COMPRADOR
22	ROLE_OBTER_ID
23	ROLE_OBTER_ID
\.


--
-- TOC entry 3526 (class 0 OID 16952)
-- Dependencies: 245
-- Data for Name: avaliacao_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.avaliacao_produto (id, descricao, nota, pessoa_id, produto_id) FROM stdin;
2	teste avaliacao 2	10	1	1
\.


--
-- TOC entry 3497 (class 0 OID 16734)
-- Dependencies: 216
-- Data for Name: categoria_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria_produto (id, nome_desc) FROM stdin;
\.


--
-- TOC entry 3510 (class 0 OID 16812)
-- Dependencies: 229
-- Data for Name: conta_pagar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conta_pagar (id, dt_pagamento, status_conta_receber, valor_desconto, pessoa_id, descricao, dt_vencimento, status, valor_total) FROM stdin;
\.


--
-- TOC entry 3506 (class 0 OID 16798)
-- Dependencies: 225
-- Data for Name: conta_receber; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.conta_receber (id, pessoa_id, dt_pagamento, valor_desconto, descricao, dt_vencimento, status_conta_receber, valor_total) FROM stdin;
\.


--
-- TOC entry 3512 (class 0 OID 16820)
-- Dependencies: 231
-- Data for Name: cupom_desconto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cupom_desconto (id, valor_porcent_desc, valor_real_desc, cod_desc, data_validade_cupom) FROM stdin;
\.


--
-- TOC entry 3528 (class 0 OID 16963)
-- Dependencies: 247
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.endereco (id, bairro, cep, cidade, complemento, numero, rua_logradouro, tipo_endereco, uf, pessoa_id) FROM stdin;
\.


--
-- TOC entry 3535 (class 0 OID 25181)
-- Dependencies: 254
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	<< Flyway Baseline >>	BASELINE	<< Flyway Baseline >>	\N	null	2026-06-04 19:15:35.860717	0	t
\.


--
-- TOC entry 3508 (class 0 OID 16806)
-- Dependencies: 227
-- Data for Name: forma_pagamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.forma_pagamento (id, descricao) FROM stdin;
\.


--
-- TOC entry 3515 (class 0 OID 16837)
-- Dependencies: 234
-- Data for Name: imagem_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.imagem_produto (id, produto_id, imagem_miniatura, imagem_original) FROM stdin;
\.


--
-- TOC entry 3524 (class 0 OID 16936)
-- Dependencies: 243
-- Data for Name: item_venda_loja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_venda_loja (id, produto_id, venda_compra_loja_virtual_id, quantidade) FROM stdin;
\.


--
-- TOC entry 3495 (class 0 OID 16723)
-- Dependencies: 214
-- Data for Name: marca_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.marca_produto (id, nome_desc) FROM stdin;
\.


--
-- TOC entry 3517 (class 0 OID 16850)
-- Dependencies: 236
-- Data for Name: nota_fiscal_compra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nota_fiscal_compra (id, descricao_obs, conta_pagar_id, pessoa_id, data_compra, numero_nota, serie_nota, valor_icms, valor_total) FROM stdin;
\.


--
-- TOC entry 3529 (class 0 OID 16980)
-- Dependencies: 248
-- Data for Name: nota_fiscal_venda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nota_fiscal_venda (id, numero, pdf, serie, tipo, xml, venda_compra_loja_virtual_id) FROM stdin;
\.


--
-- TOC entry 3530 (class 0 OID 16997)
-- Dependencies: 249
-- Data for Name: nota_item_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nota_item_produto (id, quantidade, nota_fiscal_compra_id, produto_id) FROM stdin;
\.


--
-- TOC entry 3498 (class 0 OID 16739)
-- Dependencies: 217
-- Data for Name: pessoa_fisica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pessoa_fisica (id, cpf, data_nascimento, email, nome, telefone) FROM stdin;
1	27385920400	1999-10-10	lalala@gmail.com	Teste meu nome	2199999999
\.


--
-- TOC entry 3531 (class 0 OID 17024)
-- Dependencies: 250
-- Data for Name: pessoa_juridica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pessoa_juridica (id, email, nome, telefone, categoria, cnpj, insc_estadual, insc_municipal, nome_fantasia, razao_social) FROM stdin;
\.


--
-- TOC entry 3532 (class 0 OID 17031)
-- Dependencies: 251
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto (id, alerta_qtd_estoque, altura, ativo, descricao, largura, link_youtube, nome, peso, profundidade, qtd_alerta_estoque, qtd_clique, qtd_estoque, tipo_unidade, valor_venda) FROM stdin;
1	t	10	t	produto teste	50.2	rrrrr	nome produto teste	50	80	50	50	50	UN	50.00
\.


--
-- TOC entry 3520 (class 0 OID 16879)
-- Dependencies: 239
-- Data for Name: status_rastreio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_rastreio (id, centro_distribuicao, cidade, estado, status) FROM stdin;
\.


--
-- TOC entry 3533 (class 0 OID 17058)
-- Dependencies: 252
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id, data_atual_senha, login, senha, pessoa_id) FROM stdin;
\.


--
-- TOC entry 3504 (class 0 OID 16776)
-- Dependencies: 223
-- Data for Name: usuario_acesso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario_acesso (usuario_id, acesso_id) FROM stdin;
\.


--
-- TOC entry 3534 (class 0 OID 17070)
-- Dependencies: 253
-- Data for Name: venda_compra_loja_virtual; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venda_compra_loja_virtual (id, data_entrega, data_venda, dia_entrega, valor_desconto, valor_frete, valor_total, cupom_desconto_id, endereco_cobranca_id, endereco_entrega_id, forma_pagamento_id, nota_fiscal_venda_id, pessoa_id) FROM stdin;
\.


--
-- TOC entry 3541 (class 0 OID 0)
-- Dependencies: 218
-- Name: seq_acesso; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_acesso', 56, true);


--
-- TOC entry 3542 (class 0 OID 0)
-- Dependencies: 246
-- Name: seq_avaliacao_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_avaliacao_produto', 1, false);


--
-- TOC entry 3543 (class 0 OID 0)
-- Dependencies: 219
-- Name: seq_categoria_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_categoria_produto', 1, false);


--
-- TOC entry 3544 (class 0 OID 0)
-- Dependencies: 230
-- Name: seq_conta_pagar; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_conta_pagar', 1, false);


--
-- TOC entry 3545 (class 0 OID 0)
-- Dependencies: 226
-- Name: seq_conta_receber; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_conta_receber', 1, false);


--
-- TOC entry 3546 (class 0 OID 0)
-- Dependencies: 232
-- Name: seq_cupom_desconto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_cupom_desconto', 1, false);


--
-- TOC entry 3547 (class 0 OID 0)
-- Dependencies: 221
-- Name: seq_endereco; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_endereco', 1, false);


--
-- TOC entry 3548 (class 0 OID 0)
-- Dependencies: 228
-- Name: seq_forma_pagamento; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_forma_pagamento', 1, false);


--
-- TOC entry 3549 (class 0 OID 0)
-- Dependencies: 235
-- Name: seq_imagem_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_imagem_produto', 1, false);


--
-- TOC entry 3550 (class 0 OID 0)
-- Dependencies: 244
-- Name: seq_item_venda_loja; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_item_venda_loja', 1, false);


--
-- TOC entry 3551 (class 0 OID 0)
-- Dependencies: 215
-- Name: seq_marca_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_marca_produto', 1, false);


--
-- TOC entry 3552 (class 0 OID 0)
-- Dependencies: 237
-- Name: seq_nota_fiscal_compra; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_nota_fiscal_compra', 1, false);


--
-- TOC entry 3553 (class 0 OID 0)
-- Dependencies: 241
-- Name: seq_nota_fiscal_venda; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_nota_fiscal_venda', 1, false);


--
-- TOC entry 3554 (class 0 OID 0)
-- Dependencies: 238
-- Name: seq_nota_item_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_nota_item_produto', 1, false);


--
-- TOC entry 3555 (class 0 OID 0)
-- Dependencies: 233
-- Name: seq_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_produto', 1, false);


--
-- TOC entry 3556 (class 0 OID 0)
-- Dependencies: 240
-- Name: seq_status_rastreio; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_status_rastreio', 1, false);


--
-- TOC entry 3557 (class 0 OID 0)
-- Dependencies: 224
-- Name: seq_usuario; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_usuario', 1, false);


--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 242
-- Name: seq_venda_compra_loja_virtual; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_venda_compra_loja_virtual', 1, false);


--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 220
-- Name: sqe_pessoa; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sqe_pessoa', 1, false);


--
-- TOC entry 3284 (class 2606 OID 16768)
-- Name: acesso acesso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acesso
    ADD CONSTRAINT acesso_pkey PRIMARY KEY (id);


--
-- TOC entry 3306 (class 2606 OID 16956)
-- Name: avaliacao_produto avaliacao_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacao_produto
    ADD CONSTRAINT avaliacao_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3280 (class 2606 OID 16738)
-- Name: categoria_produto categoria_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_produto
    ADD CONSTRAINT categoria_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3294 (class 2606 OID 16818)
-- Name: conta_pagar conta_pagar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conta_pagar
    ADD CONSTRAINT conta_pagar_pkey PRIMARY KEY (id);


--
-- TOC entry 3290 (class 2606 OID 16802)
-- Name: conta_receber conta_receber_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conta_receber
    ADD CONSTRAINT conta_receber_pkey PRIMARY KEY (id);


--
-- TOC entry 3296 (class 2606 OID 16826)
-- Name: cupom_desconto cupom_desconto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupom_desconto
    ADD CONSTRAINT cupom_desconto_pkey PRIMARY KEY (id);


--
-- TOC entry 3308 (class 2606 OID 16969)
-- Name: endereco endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- TOC entry 3322 (class 2606 OID 25188)
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- TOC entry 3292 (class 2606 OID 16810)
-- Name: forma_pagamento forma_pagamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forma_pagamento
    ADD CONSTRAINT forma_pagamento_pkey PRIMARY KEY (id);


--
-- TOC entry 3298 (class 2606 OID 16841)
-- Name: imagem_produto imagem_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagem_produto
    ADD CONSTRAINT imagem_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3304 (class 2606 OID 16940)
-- Name: item_venda_loja item_venda_loja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_venda_loja
    ADD CONSTRAINT item_venda_loja_pkey PRIMARY KEY (id);


--
-- TOC entry 3278 (class 2606 OID 16727)
-- Name: marca_produto marca_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marca_produto
    ADD CONSTRAINT marca_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3300 (class 2606 OID 16856)
-- Name: nota_fiscal_compra nota_fiscal_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_compra
    ADD CONSTRAINT nota_fiscal_compra_pkey PRIMARY KEY (id);


--
-- TOC entry 3310 (class 2606 OID 16986)
-- Name: nota_fiscal_venda nota_fiscal_venda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_venda
    ADD CONSTRAINT nota_fiscal_venda_pkey PRIMARY KEY (id);


--
-- TOC entry 3312 (class 2606 OID 17001)
-- Name: nota_item_produto nota_item_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_item_produto
    ADD CONSTRAINT nota_item_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3282 (class 2606 OID 16745)
-- Name: pessoa_fisica pessoa_fisica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa_fisica
    ADD CONSTRAINT pessoa_fisica_pkey PRIMARY KEY (id);


--
-- TOC entry 3314 (class 2606 OID 17030)
-- Name: pessoa_juridica pessoa_juridica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa_juridica
    ADD CONSTRAINT pessoa_juridica_pkey PRIMARY KEY (id);


--
-- TOC entry 3316 (class 2606 OID 17037)
-- Name: produto produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3302 (class 2606 OID 16883)
-- Name: status_rastreio status_rastreio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_rastreio
    ADD CONSTRAINT status_rastreio_pkey PRIMARY KEY (id);


--
-- TOC entry 3286 (class 2606 OID 16797)
-- Name: usuario_acesso uk_fhwpg5wu1u5p306q8gycxn9ky; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_acesso
    ADD CONSTRAINT uk_fhwpg5wu1u5p306q8gycxn9ky UNIQUE (acesso_id);


--
-- TOC entry 3288 (class 2606 OID 16782)
-- Name: usuario_acesso unique_acesso_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_acesso
    ADD CONSTRAINT unique_acesso_user UNIQUE (usuario_id, acesso_id);


--
-- TOC entry 3318 (class 2606 OID 17064)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 3320 (class 2606 OID 17074)
-- Name: venda_compra_loja_virtual venda_compra_loja_virtual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT venda_compra_loja_virtual_pkey PRIMARY KEY (id);


--
-- TOC entry 3323 (class 1259 OID 25189)
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- TOC entry 3345 (class 2620 OID 17112)
-- Name: avaliacao_produto validachavepessoaavaliacaoproduto; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoaavaliacaoproduto BEFORE UPDATE ON public.avaliacao_produto FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3346 (class 2620 OID 17113)
-- Name: avaliacao_produto validachavepessoaavaliacaoproduto2; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoaavaliacaoproduto2 BEFORE INSERT ON public.avaliacao_produto FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3341 (class 2620 OID 17115)
-- Name: conta_pagar validachavepessoacontapagarinsertpessoaid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoacontapagarinsertpessoaid BEFORE INSERT ON public.conta_pagar FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3342 (class 2620 OID 17116)
-- Name: conta_pagar validachavepessoacontapagarupdatepessoaid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoacontapagarupdatepessoaid BEFORE UPDATE ON public.conta_pagar FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3339 (class 2620 OID 17118)
-- Name: conta_receber validachavepessoacontareceberinsertpessoaid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoacontareceberinsertpessoaid BEFORE INSERT ON public.conta_receber FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3340 (class 2620 OID 17117)
-- Name: conta_receber validachavepessoacontareceberupdatepessoaid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoacontareceberupdatepessoaid BEFORE UPDATE ON public.conta_receber FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3347 (class 2620 OID 17120)
-- Name: endereco validachavepessoaenderecoinsertpessoaid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoaenderecoinsertpessoaid BEFORE INSERT ON public.endereco FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3348 (class 2620 OID 17119)
-- Name: endereco validachavepessoaenderecoupdatepessoaid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoaenderecoupdatepessoaid BEFORE UPDATE ON public.endereco FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3343 (class 2620 OID 17122)
-- Name: nota_fiscal_compra validachavepessoanotafiscalcomprainsertpessoaid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoanotafiscalcomprainsertpessoaid BEFORE INSERT ON public.nota_fiscal_compra FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3344 (class 2620 OID 17121)
-- Name: nota_fiscal_compra validachavepessoanotafiscalcompraupdatepessoaid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoanotafiscalcompraupdatepessoaid BEFORE UPDATE ON public.nota_fiscal_compra FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3349 (class 2620 OID 17124)
-- Name: usuario validachavepessoausuarioinsertpessoaid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoausuarioinsertpessoaid BEFORE INSERT ON public.usuario FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3350 (class 2620 OID 17123)
-- Name: usuario validachavepessoausuarioupdatepessoaid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoausuarioupdatepessoaid BEFORE UPDATE ON public.usuario FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3351 (class 2620 OID 17126)
-- Name: venda_compra_loja_virtual validachavepessoavendacomprainsertpessoaid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoavendacomprainsertpessoaid BEFORE INSERT ON public.venda_compra_loja_virtual FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3352 (class 2620 OID 17125)
-- Name: venda_compra_loja_virtual validachavepessoavendacompraupdatepessoaid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoavendacompraupdatepessoaid BEFORE UPDATE ON public.venda_compra_loja_virtual FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3324 (class 2606 OID 16784)
-- Name: usuario_acesso acesso_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_acesso
    ADD CONSTRAINT acesso_fk FOREIGN KEY (acesso_id) REFERENCES public.acesso(id);


--
-- TOC entry 3327 (class 2606 OID 16864)
-- Name: nota_fiscal_compra conta_pagar_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_compra
    ADD CONSTRAINT conta_pagar_fk FOREIGN KEY (conta_pagar_id) REFERENCES public.conta_pagar(id);


--
-- TOC entry 3334 (class 2606 OID 17085)
-- Name: venda_compra_loja_virtual cupom_desconto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT cupom_desconto_fk FOREIGN KEY (cupom_desconto_id) REFERENCES public.cupom_desconto(id);


--
-- TOC entry 3335 (class 2606 OID 17090)
-- Name: venda_compra_loja_virtual endereco_cobranca_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT endereco_cobranca_fk FOREIGN KEY (endereco_cobranca_id) REFERENCES public.endereco(id);


--
-- TOC entry 3336 (class 2606 OID 17095)
-- Name: venda_compra_loja_virtual endereco_entrega_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT endereco_entrega_fk FOREIGN KEY (endereco_entrega_id) REFERENCES public.endereco(id);


--
-- TOC entry 3337 (class 2606 OID 17100)
-- Name: venda_compra_loja_virtual forma_pagamento_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT forma_pagamento_fk FOREIGN KEY (forma_pagamento_id) REFERENCES public.forma_pagamento(id);


--
-- TOC entry 3332 (class 2606 OID 17002)
-- Name: nota_item_produto nota_fiscal_compra_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_item_produto
    ADD CONSTRAINT nota_fiscal_compra_fk FOREIGN KEY (nota_fiscal_compra_id) REFERENCES public.nota_fiscal_compra(id);


--
-- TOC entry 3338 (class 2606 OID 17105)
-- Name: venda_compra_loja_virtual nota_fiscal_venda_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT nota_fiscal_venda_fk FOREIGN KEY (nota_fiscal_venda_id) REFERENCES public.nota_fiscal_venda(id);


--
-- TOC entry 3330 (class 2606 OID 17038)
-- Name: avaliacao_produto produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacao_produto
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 3326 (class 2606 OID 17043)
-- Name: imagem_produto produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagem_produto
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 3328 (class 2606 OID 17048)
-- Name: item_venda_loja produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_venda_loja
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 3333 (class 2606 OID 17053)
-- Name: nota_item_produto produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_item_produto
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 3325 (class 2606 OID 17065)
-- Name: usuario_acesso usuario_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_acesso
    ADD CONSTRAINT usuario_fk FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 3329 (class 2606 OID 17075)
-- Name: item_venda_loja venda_compra_loja_virtual_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_venda_loja
    ADD CONSTRAINT venda_compra_loja_virtual_fk FOREIGN KEY (venda_compra_loja_virtual_id) REFERENCES public.venda_compra_loja_virtual(id);


--
-- TOC entry 3331 (class 2606 OID 17080)
-- Name: nota_fiscal_venda venda_compra_loja_virtual_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_venda
    ADD CONSTRAINT venda_compra_loja_virtual_fk FOREIGN KEY (venda_compra_loja_virtual_id) REFERENCES public.venda_compra_loja_virtual(id);


-- Completed on 2026-06-04 19:24:03

--
-- PostgreSQL database dump complete
--

