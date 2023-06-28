DROP TABLE IF EXISTS public.token_platform;
CREATE TABLE public.token_platform (
                                       address varchar NOT NULL,
                                       platform varchar NOT NULL,
                                       platform_name varchar NULL,
                                       created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                       updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                       "removed" bool DEFAULT false,
                                       CONSTRAINT token_platform_un UNIQUE (address, platform)
);
truncate table token_platform;
vacuum token_platform;

insert into token_platform (address, platform)
select token, project from dex_tx_volume_count_record
group by token, project;
insert into tag_result(table_name,batch_date)  SELECT 'token_platform' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
