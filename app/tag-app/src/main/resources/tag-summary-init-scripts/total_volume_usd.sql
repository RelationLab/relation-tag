-- public.total_volume_usd definition
-- Drop table
-- DROP TABLE public.total_volume_usd;
DROP TABLE IF EXISTS public.total_volume_usd;
CREATE TABLE public.total_volume_usd (
                                         address varchar(512) NULL,
                                         volume_usd numeric(250, 20) NULL,
                                         created_at timestamp(6) NULL,
                                         updated_at timestamp(6) NULL,
                                         recent_time_code varchar(30) NULL
)with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by (address,recent_time_code);
truncate table total_volume_usd;
vacuum total_volume_usd;

insert into total_volume_usd(address, volume_usd,recent_time_code)
    (select address, sum(round(volume_usd,8)) , recent_time_code from token_volume_usd_temp where address is not null group by address,recent_time_code);
insert into tag_result(table_name,batch_date)  SELECT 'total_volume_usd' as table_name,'${batchDate}'  as batch_date;
