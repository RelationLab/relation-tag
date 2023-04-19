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
    distributed by (address);
truncate table total_volume_usd;
vacuum total_volume_usd;

insert into total_volume_usd(address, volume_usd)
    (select address,  sum(round(volume_usd,3)) from token_volume_usd where address is not null group by address);
insert into tag_result(table_name,batch_date)  SELECT 'total_volume_usd' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
