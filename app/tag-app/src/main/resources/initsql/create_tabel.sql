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



-- public.token_volume_usd definition

-- Drop table





