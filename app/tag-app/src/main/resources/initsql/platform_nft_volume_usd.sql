DROP TABLE if EXISTS public.platform_nft_volume_usd;

truncate table platform_nft_volume_usd;
insert into platform_nft_volume_usd(address, platform_group, platform, quote_token, token, volume_usd, buy_volume_usd,
                                    sell_volume_usd)
    (select pnh.address,
            platform_group,
            platform,
            quote_token,
            token,
            total_transfer_all_volume * price,
            total_transfer_to_volume * price,
            total_transfer_volume * price
     from platform_nft_holding pnh
              inner join white_list_erc20 w on pnh.quote_token = w.address
     where pnh.token in (select nft_sync_address.address from nft_sync_address));