DROP TABLE IF EXISTS public.nft_platform;
CREATE TABLE public.nft_platform (
                                       address varchar NOT NULL,
                                       platform varchar NOT NULL,
                                       platform_name varchar NULL,
                                       created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                       updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                       "removed" bool DEFAULT false
);
truncate table nft_platform;
vacuum nft_platform;

insert into nft_platform (address, platform,platform_name)
select
    platform_nft_tx_record.token,
    mp_nft_platform.platform,
    mp_nft_platform.platform_name_alis
from
    platform_nft_tx_record
        inner join mp_nft_platform on
        (platform_nft_tx_record.platform_address = mp_nft_platform.platform)
group by  platform_nft_tx_record.token,
          mp_nft_platform.platform,
          mp_nft_platform.platform_name_alis;
insert into tag_result(table_name,batch_date)  SELECT 'nft_platform' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
