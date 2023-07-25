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

insert
into
    nft_platform (address,
                  platform,
                  platform_name)
select
    platform_nft_tx_record.token,
    mp_nft_platform.platform,
    mp_nft_platform.platform_name_alis
from
    (
        select
            token,
            platform_address
        from
            platform_nft_tx_record
        union all
        select
            token,
            '0x39da41747a83aee658334415666f3ef92dd0d541' as platform_address
        from
            platform_deposit_withdraw_tx_record
        union all
        select
            lend_token as token,
            '0x39da41747a83aee658334415666f3ef92dd0d541' as platform_address
        from
            platform_lend_tx_record
        union all
        select
            nft_token as token,
            '0x39da41747a83aee658334415666f3ef92dd0d541' as platform_address
        from
            platform_bid_tx_record
    ) platform_nft_tx_record
        inner join mp_nft_platform on
        (platform_nft_tx_record.platform_address = mp_nft_platform.platform)
group by
    platform_nft_tx_record.token,
    mp_nft_platform.platform,
    mp_nft_platform.platform_name_alis;

delete from nft_sync_address where address='0x0000000000a39bb272e79075ade125fd351887ac' and (platform='Blur' or platform='Blur Pool Token') and "type"='ERC721';
insert into nft_sync_address (id,	address ,platform ,"type")
select -1,'0x0000000000a39bb272e79075ade125fd351887ac' as address ,'Blur Pool Token' as platform ,'ERC721' as "type";

insert into tag_result(table_name,batch_date)  SELECT 'nft_platform' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
