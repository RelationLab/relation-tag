-- public."label_temp" definition

-- Drop table

-- DROP TABLE public."label_temp";
DROP TABLE if EXISTS  label_temp;
CREATE TABLE public."label_temp" (
                                "owner" varchar(512) NOT NULL DEFAULT '-1'::character varying,
                                "type" varchar(512) NOT NULL,
                                "name" varchar(1024) NOT NULL,
                                "source" varchar(100) NULL DEFAULT 'SYSTEM'::character varying,
                                visible_type varchar(256) NOT NULL DEFAULT 'PUBLIC'::character varying,
                                strategy varchar(512) NOT NULL,
                                "content" text NULL,
                                "rule" text NULL,
                                default_rule text NULL,
                                rule_type varchar(512) NULL,
                                rule_group varchar(1024) NULL,
                                value_type varchar(512) NULL DEFAULT 'RESULT'::character varying,
                                description text NULL,
                                run_order int4 NULL DEFAULT 999999,
                                created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                removed bool NULL DEFAULT false,
                                for_init bool NULL DEFAULT false,
                                error_msg text NULL,
                                status varchar(64) NULL DEFAULT 'SUCCESS'::character varying,
                                popular bool NULL DEFAULT false,
                                refresh_time int8 NULL DEFAULT 0,
                                mark_type varchar(2048) NULL,
                                ar_tx_hash varchar(256) NULL,
                                ar_status varchar(64) NULL DEFAULT 'PENDING'::character varying,
                                ar_error_msg text NULL,
                                ar_error_count int4 NULL DEFAULT 0,
                                api_level varchar(255) NULL,
                                personal int2 NULL DEFAULT 0,
                                wired_type varchar(128) NULL,
                                label_order int4 NULL DEFAULT 999,
                                one_wired_type varchar(100),
                                two_wired_type varchar(2),
                                time_type varchar(10) NULL,
                                sync_es_status varchar(20) NOT NULL DEFAULT 'WAITING'::character varying
) with (appendonly='true', compresstype=zstd, compresslevel='5')
distributed by ("name");
insert into tag_result(table_name,batch_date)  SELECT 'data_table_label' as table_name,'${batchDate}'  as batch_date;
