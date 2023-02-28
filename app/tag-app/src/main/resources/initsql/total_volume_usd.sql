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

insert into total_volume_usd(address, volume_usd)
    (select address,  sum(volume_usd) from token_volume_usd where address is not null group by address);