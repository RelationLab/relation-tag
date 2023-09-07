DROP TABLE IF EXISTS public.nft_platform_temp;
CREATE TABLE public.nft_platform_temp
(
    address       varchar NOT NULL,
    platform      varchar NOT NULL,
    platform_name varchar NULL,
    created_at    timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    "removed"     bool DEFAULT false
);
truncate table nft_platform_temp;
vacuum
nft_platform_temp;

insert
into nft_platform_temp(address,
                       platform,
                       platform_name)
select platform_nft_tx_record.token,
       mp_nft_platform_temp.platform,
       mp_nft_platform_temp.platform_name_alis
from (select token,
             case
                 when platform_address = '0x39da41747a83aee658334415666f3ef92dd0d541' or
                      platform_address = '0x000000000000ad05ccc4f10045630fb830b95127'
                     then '0x39da41747a83aee658334415666f3ef92dd0d541'
                 when platform_address = '0x00000000006c3852cbef3e08e8df289169ede581' or
                      platform_address = '0x7be8076f4ea4a4ad08075c2508e481d6c946d12b'
                     or platform_address = '0x7f268357a8c2552623316e2562d90e642bb538e5'
                     then '0x00000000006c3852cbef3e08e8df289169ede581'
                 else platform_address
                 end as platform_address
      from platform_nft_tx_record
      union all
      select token,
             '0x39da41747a83aee658334415666f3ef92dd0d541' as platform_address
      from platform_deposit_withdraw_tx_record
      union all
      select quote_token                                  as token,
             '0x39da41747a83aee658334415666f3ef92dd0d541' as platform_address
      from platform_deposit_withdraw_tx_record
      union all
      select lend_token                                   as token,
             '0x39da41747a83aee658334415666f3ef92dd0d541' as platform_address
      from platform_lend_tx_record
      union all
      select nft_token                                    as token,
             '0x39da41747a83aee658334415666f3ef92dd0d541' as platform_address
      from platform_bid_tx_record) platform_nft_tx_record
         inner join mp_nft_platform_temp on
    (platform_nft_tx_record.platform_address = mp_nft_platform_temp.platform)
group by platform_nft_tx_record.token,
         mp_nft_platform_temp.platform,
         mp_nft_platform_temp.platform_name_alis;

insert into tag_result(table_name, batch_date)
SELECT 'data_cal_nft_platform' as table_name, '${batchDate}' as batch_date;
