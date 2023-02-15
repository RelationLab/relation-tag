






drop table if exists dex_tx_volume_count_summary;
CREATE TABLE public.dex_tx_volume_count_summary (
                                                    address varchar(256) NOT NULL,
                                                    "token" varchar(256) NOT NULL,
                                                    block_height int8 NOT NULL,
                                                    total_transfer_volume_usd numeric(125, 30) DEFAULT 0,
                                                    total_transfer_count int8 DEFAULT 0,
                                                    created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                    updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                    removed bool NULL DEFAULT false,
                                                    first_updated_block_height int8 NOT NULL DEFAULT 99999999,
                                                    transaction_hash varchar(100) NULL,
                                                    router varchar(150) NULL,
                                                    "type" varchar(10) NULL,
                                                    project varchar(100) NULL,
                                                    in_transfer_volume numeric(125, 30) NULL,
                                                    out_transfer_volume numeric(125, 30) NULL,
                                                    in_transfer_count int8 NULL,
                                                    out_transfer_count int8 NULL,
                                                    balance_usd numeric(125, 30) DEFAULT 0
);

drop table if exists dim_project_token_type;
create table dim_project_token_type
(
    project  varchar(100)
    ,token    varchar(100)
    ,type   varchar(100)
    ,label_type   varchar(100)
    ,label_name  varchar(100)
    ,content   varchar(100)
    ,operate_type   varchar(100)
    ,seq_flag varchar(100)
    ,data_subject varchar(100)
    ,etl_update_time timestamp
);

drop table if exists dim_project_type;
create table dim_project_type
(
    project  varchar(100)
    ,type   varchar(100)
    ,label_type   varchar(100)
    ,label_name  varchar(100)
    ,content   varchar(100)
    ,operate_type   varchar(100)
    ,seq_flag varchar(100)
    ,data_subject varchar(100)
    ,etl_update_time timestamp
);

drop table if exists dim_rank_token;
create table dim_rank_token
(
    token_id   varchar(512),
    asset_type varchar(10)
);

drop table if exists dim_rule_content;
create table dim_rule_content
(
    rule_code    varchar(50),
    token        varchar(300),
    label_type   varchar(300),
    operate_type varchar(300),
    data_subject varchar(20),
    create_time  timestamp,
    token_name   varchar(20),
    token_type   varchar(20)
);

drop table if exists dim_rule_sql_content;
CREATE TABLE public.dim_rule_sql_content (
                                             rule_name varchar(100) NULL,
                                             rule_sql text NULL,
                                             rule_order int8 NULL
);

DROP TABLE if EXISTS public.nft_transfer_holding;
create table nft_transfer_holding
(
    id                    bigserial,
    address               varchar(512) not null,
    token                 varchar(512) not null,
    total_transfer_volume bigint       not null,
    total_transfer_count  bigint,
    created_at            timestamp default CURRENT_TIMESTAMP,
    updated_at            timestamp default CURRENT_TIMESTAMP,
    removed               boolean   default false
);

DROP TABLE if EXISTS public.nft_volume_count;
CREATE TABLE public.nft_volume_count (
                                         address varchar(512) NOT NULL,
                                         "token" varchar(512) NOT NULL,
                                         type varchar(20) NOT NULL,
                                         transfer_volume int8 NOT NULL,
                                         transfer_count int8 NULL,
                                         created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                         updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                         removed bool NULL DEFAULT false,
                                         CONSTRAINT uk_nvc_address_token UNIQUE (address, token, type)
);

DROP TABLE if exists public.platform_nft_type_volume_count;
CREATE TABLE public.platform_nft_type_volume_count (
                                                       address varchar(512) NOT NULL,
                                                       platform_group varchar(256) NULL,
                                                       platform varchar(512) NOT NULL,
                                                       quote_token varchar(512) NOT NULL,
                                                       "token" varchar(512) NOT NULL,
                                                       type varchar(20) NOT NULL,
                                                       volume_usd numeric(128, 30) NULL,
                                                       transfer_count int8 null,
                                                       created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                       updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                       removed bool NULL DEFAULT false,
                                                       CONSTRAINT uk_pntvu_address_token_type_platform UNIQUE (address, token, type, quote_token, platform, platform_group)
);

DROP TABLE if EXISTS public.platform_nft_volume_usd;
create table platform_nft_volume_usd
(
    id              bigserial,
    address         varchar(512) not null,
    platform_group  varchar(256),
    platform        varchar(512) not null,
    quote_token     varchar(512) not null,
    token           varchar(512) not null,
    volume_usd      numeric(128, 30),
    created_at      timestamp default CURRENT_TIMESTAMP,
    updated_at      timestamp default CURRENT_TIMESTAMP,
    removed         boolean   default false,
    buy_volume_usd  numeric(128, 30),
    sell_volume_usd numeric(128, 30)
);

drop table if exists token_balance_volume_usd;
create table public.token_balance_volume_usd
(
    address varchar(512) not null,
    token varchar(512) not null,
    balance_usd numeric,
    volume_usd numeric,
    created_at timestamp default CURRENT_TIMESTAMP,
    updated_at timestamp default now(),
    removed boolean default false
);

drop table if exists total_balance_volume_usd;

CREATE TABLE public.total_balance_volume_usd (
                                                 address varchar(512) NOT NULL,
                                                 balance_usd numeric(250, 20) NULL,
                                                 volume_usd numeric(250, 20) NULL,
                                                 created_at timestamp(6) NULL,
                                                 updated_at timestamp(6) NULL,
                                                 removed bool NULL
);

DROP TABLE IF EXISTS public.web3_transaction_record_summary;

CREATE TABLE  public.web3_transaction_record_summary
(
    address character varying(256) COLLATE pg_catalog."default" NOT NULL,
    total_transfer_volume numeric(125,30) NOT NULL DEFAULT 0,
    total_transfer_count bigint NOT NULL DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    removed boolean DEFAULT false,
    type character varying(50) COLLATE pg_catalog."default",
    project character varying(100) COLLATE pg_catalog."default",
    balance numeric(125,30) NOT NULL DEFAULT 0
);

-- public.token_holding_vol_count definition

-- Drop table

-- DROP TABLE public.token_holding_vol_count;
-- DROP TABLE IF EXISTS public.token_holding_vol_count;
-- CREATE TABLE public.token_holding_vol_count (
--                                                 address varchar(256) NULL,
--                                                 "token" varchar(256) NULL,
--                                                 balance numeric(125, 30) NULL,
--                                                 block_height bigint NULL,
--                                                 total_transfer_volume numeric(125, 30) NULL,
--                                                 total_transfer_count bigint NULL,
--                                                 count_level varchar(30) NULL,
--                                                 status varchar(128) NULL,
--                                                 created_at timestamp NULL,
--                                                 updated_at timestamp NULL,
--                                                 removed bool NULL,
--                                                 fail_count int4 NULL,
--                                                 error_code int4 NULL,
--                                                 error_message text NULL,
--                                                 node_name varchar(512) NULL,
--                                                 total_transfer_to_count bigint NULL,
--                                                 total_transfer_all_count bigint NULL,
--                                                 total_transfer_to_volume numeric(120, 30) NULL,
--                                                 total_transfer_all_volume numeric(120, 30) NULL
-- );

-- public.eth_holding_vol_count.sql definition

-- Drop table

-- DROP TABLE public.eth_holding_vol_count.sql;
-- DROP TABLE IF EXISTS public.eth_holding_vol_count;
-- CREATE TABLE public.eth_holding_vol_count (
--                                               address varchar(256) NULL,
--                                               balance numeric(125, 30) NULL,
--                                               total_transfer_count int8 NULL,
--                                               block_height int8 NULL,
--                                               total_transfer_volume numeric(120, 30) NULL,
--                                               status varchar(128) NULL,
--                                               created_at timestamp NULL,
--                                               updated_at timestamp NULL,
--                                               removed bool NULL,
--                                               fail_count int4 NULL,
--                                               error_code int4 NULL,
--                                               error_message text NULL,
--                                               node_name varchar(512) NULL,
--                                               total_transfer_to_count int8 NULL,
--                                               total_transfer_all_count int8 NULL,
--                                               total_transfer_to_volume numeric(120, 30) NULL,
--                                               total_transfer_all_volume numeric(120, 30) NULL
-- );

-- public.token_holding_uni_cal definition

-- Drop table

-- DROP TABLE public.token_holding_uni_cal;
DROP TABLE IF EXISTS public.token_holding_uni_cal;
CREATE TABLE public.token_holding_uni_cal (
                                              address varchar(256) NULL,
                                              "token" varchar(256) NULL,
                                              balance numeric(125, 30) NULL,
                                              block_height int8 NULL,
                                              total_transfer_volume numeric(125, 30) NULL,
                                              total_transfer_count int8 NULL,
                                              status varchar(128) NULL,
                                              created_at timestamp NULL,
                                              updated_at timestamp NULL,
                                              removed bool NULL,
                                              fail_count int4 NULL,
                                              error_code int4 NULL,
                                              error_message text NULL,
                                              node_name varchar(512) NULL,
                                              nft_token_id varchar(150) NULL,
                                              in_transfer_volume numeric(125, 30) NULL,
                                              out_transfer_volume numeric(125, 30) NULL,
                                              in_transfer_count int8 NULL,
                                              out_transfer_count int8 NULL,
                                              "event" varchar(10) NULL,
                                              first_updated_block_height int8 NULL,
                                              transaction_hash varchar(100) NULL,
                                              price_token varchar(150) NULL,
                                              liquidity numeric(125, 30) NULL,
                                              token0 varchar(150) NULL,
                                              token1 varchar(150) NULL,
                                              handle bool NULL,
                                              "type" varchar(30) NULL
);

-- public.token_volume_usd definition

-- Drop table

-- DROP TABLE public.token_volume_usd;
DROP TABLE IF EXISTS public.token_volume_usd;
CREATE TABLE public.token_volume_usd (
                                         address varchar(512) NULL,
                                         "token" varchar(512) NULL,
                                         volume_usd numeric NULL,
                                         created_at timestamp NULL,
                                         updated_at timestamp NULL,
                                         removed bool NULL
)
    DISTRIBUTED RANDOMLY;

-- public.total_volume_usd definition
-- Drop table
-- DROP TABLE public.total_volume_usd;
DROP TABLE IF EXISTS public.total_volume_usd;
CREATE TABLE public.total_volume_usd (
                                         address varchar(512) NULL,
                                         volume_usd numeric(250, 20) NULL,
                                         created_at timestamp(6) NULL,
                                         updated_at timestamp(6) NULL,
                                         removed bool NULL
)
    DISTRIBUTED RANDOMLY;

-- public.dms_syn_block definition

-- Drop table

-- DROP TABLE public.dms_syn_block;
DROP TABLE IF EXISTS public.dms_syn_block;
CREATE TABLE public.dms_syn_block (
                                      syn_type varchar(20) NOT NULL,
                                      block_height int8 NULL
);