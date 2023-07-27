DROP TABLE if EXISTS public.platform_nft_volume_usd;
create table platform_nft_volume_usd
(
    id              bigserial,
    address         varchar(512) not null,
    platform_group  varchar(256),
    platform        varchar(512) not null,
    quote_token     varchar(512) not null,
    token           varchar(512) not null,
    volume_usd      numeric(128, 30),
    created_at      timestamp default CURRENT_TIMESTAMP,
    updated_at      timestamp default CURRENT_TIMESTAMP,
    removed         boolean   default false,
    buy_volume_usd  numeric(128, 30),
    recent_time_code varchar(30)  null,
    sell_volume_usd numeric(128, 30)
);
truncate table platform_nft_volume_usd;
vacuum platform_nft_volume_usd;

insert into platform_nft_volume_usd(recent_time_code,address, platform_group, platform, quote_token, token, volume_usd, buy_volume_usd,
                                    sell_volume_usd)
    (select pnh.recent_time_code,
            pnh.address,
            platform_group,
            platform,
            quote_token,
            token,
            total_transfer_all_volume * price,
            total_transfer_to_volume * price,
            total_transfer_volume * price
     from platform_nft_holding pnh
              inner join white_list_erc20 w on (pnh.quote_token = w.address)
     where pnh.token in (select nft_sync_address.address from nft_sync_address) or
         pnh.token='0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb');

insert into tag_result(table_name,batch_date)  SELECT 'platform_nft_volume_usd' as table_name,'${batchDate}'  as batch_date;
