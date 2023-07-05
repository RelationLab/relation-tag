update dex_tx_volume_count_record_cdc set project='0x1111111254fb6c44bac0bed2854e76f90643097d'
where project='0x1111111254fb6c44bAC0beD2854e76F90643097d';

update dex_tx_volume_count_record_cdc set token='eth'
where (project='0xae7ab96520de3a18e5e111b5eaab095312d7fe84'
    or project='0x4d05e3d48a938db4b7a9a59a802d5b45011bde58'
    or project='0xbafa44efe7901e04e39dad13167d089c559c1138')
  and token='0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2';

DROP TABLE IF EXISTS public.token_platform;
CREATE TABLE public.token_platform (
                                       address varchar NOT NULL,
                                       platform varchar NOT NULL,
                                       platform_name varchar NULL,
                                       created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                       updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                       "removed" bool DEFAULT false
);
truncate table token_platform;
vacuum token_platform;

insert into token_platform (address, platform)
select token, project from dex_tx_volume_count_record
group by token, project;
insert into tag_result(table_name,batch_date)  SELECT 'token_platform' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
