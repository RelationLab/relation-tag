DROP TABLE IF EXISTS public.token_platform;
CREATE TABLE public.token_platform (
                                       address varchar NOT NULL,
                                       platform varchar NOT NULL,
                                       platform_name varchar NULL,
                                       created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
                                       updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
                                       "removed" bool DEFAULT false,
                                       CONSTRAINT token_platform_un UNIQUE (address, platform)
);
truncate table token_platform;
vacuum token_platform;

insert into token_platform (address, platform)
select token, project from dex_tx_volume_count_record
group by token, project;