-- public.combination_temp definition

-- Drop table

-- DROP TABLE public.combination_temp;
drop table if exists combination_temp;

CREATE TABLE public.combination_temp (
                                    asset varchar(100) NULL,
                                    project varchar(100) NULL,
                                    trade_type varchar(100) NULL,
                                    balance varchar(100) NULL,
                                    volume varchar(100) NULL,
                                    activity varchar(100) NULL,
                                    hold_time varchar(100) NULL,
                                    created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                    updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                    removed bool NULL DEFAULT false,
                                    label_name text NULL,
                                    asset_type varchar(50) NULL,
                                    label_category varchar(50) NULL,
                                    recent_time_code varchar(30) NULL
) with (appendonly='true', compresstype=zstd, compresslevel='5')
distributed by (label_name);
insert into tag_result(table_name,batch_date)  SELECT 'data_table_combination' as table_name,'${batchDate}'  as batch_date;
