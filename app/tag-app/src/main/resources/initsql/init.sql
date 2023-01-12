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
     where pnh.token in (select nft_sync_address.address from nft_sync_address) or
             pnh.token='0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb');


insert into nft_transfer_holding (address, token, total_transfer_volume, total_transfer_count)
    (select nh.address,
            nh.token,
            nh.total_transfer_all_volume - nh.total_transfer_mint_volume - nh.total_transfer_burn_volume - COALESCE(nbsh.total_transfer_buy_volume,0) - COALESCE(nbsh.total_transfer_sell_volume,0),
            nh.total_transfer_all_count - nh.total_transfer_mint_count - nh.total_transfer_burn_count - COALESCE(nbsh.total_transfer_buy_count,0) - COALESCE(nbsh.total_transfer_sell_count,0)
     from nft_holding nh
              left join nft_buy_sell_holding nbsh
                        on nh.address = nbsh.address
                            and nh.token = nbsh.token);

    CREATE INDEX nft_activity_volume_address_gin_trgm ON public.nft_volume_count USING btree (address);
    CREATE INDEX nft_activity_volume_token_gin_trgm ON public.nft_volume_count USING btree (token);

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Mint', total_transfer_mint_volume, total_transfer_mint_count from nft_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Burn', total_transfer_burn_volume, total_transfer_burn_count from nft_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Buy', total_transfer_buy_volume, total_transfer_buy_count from nft_buy_sell_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Sale', total_transfer_sell_volume, total_transfer_sell_count from nft_buy_sell_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'ALL', total_transfer_all_volume, total_transfer_all_count from nft_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Transfer', total_transfer_volume, total_transfer_count from nft_transfer_holding;



insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
    select pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'Buy', pnvu.buy_volume_usd, pnh.total_transfer_to_count from
    platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token" and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform;


insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
    select pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'Sale', pnvu.sell_volume_usd, pnh.total_transfer_count from
    platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token" and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform;


insert into platform_nft_type_volume_count(address, platform_group, platform, quote_token, token, type, volume_usd, transfer_count)
    select pnvu.address, pnvu.platform_group, pnvu.platform, pnvu.quote_token, pnvu.token, 'ALL', pnvu.volume_usd, pnh.total_transfer_all_count from
    platform_nft_volume_usd pnvu inner join platform_nft_holding pnh on pnvu .address = pnh.address and pnvu."token" = pnh."token" and pnvu.quote_token = pnh.quote_token and pnvu.platform_group = pnh.platform_group and pnvu.platform = pnh.platform;


insert into token_holding_uni_cal(address
                                 ,token
                                 ,balance
                                 ,block_height
                                 ,total_transfer_volume
                                 ,total_transfer_count
                                 ,nft_token_id
                                 ,in_transfer_volume
                                 ,out_transfer_volume
                                 ,in_transfer_count
                                 ,out_transfer_count
                                 ,event
                                 ,first_updated_block_height
                                 ,transaction_hash
                                 ,price_token
                                 ,liquidity
                                 ,token0
                                 ,token1
                                 ,handle
                                 ,type) select address
                                             ,token
                                             ,balance
                                             ,block_height
                                             ,total_transfer_volume
                                             ,total_transfer_count
                                             ,nft_token_id
                                             ,in_transfer_volume
                                             ,out_transfer_volume
                                             ,in_transfer_count
                                             ,out_transfer_count
                                             ,event
                                             ,first_updated_block_height
                                             ,transaction_hash
                                             ,price_token
                                             ,liquidity
                                             ,token0
                                             ,token1
                                             ,handle
                                             ,type from token_holding_uni where type='swap';

insert into token_holding_uni_cal(address
                                 ,token
                                 ,balance
                                 ,block_height
                                 ,total_transfer_volume
                                 ,total_transfer_count
                                 ,nft_token_id
                                 ,in_transfer_volume
                                 ,out_transfer_volume
                                 ,in_transfer_count
                                 ,out_transfer_count
                                 ,first_updated_block_height
                                 ,price_token
                                 ,liquidity
                                 ,type)

    select
    address
     ,token
     ,case  when liquidity<=0 THEN 0 ELSE balance end balance
     ,block_height
     ,total_transfer_volume
     ,total_transfer_count
     ,nft_token_id
     ,in_transfer_volume
     ,out_transfer_volume
     ,in_transfer_count
     ,out_transfer_count
     ,first_updated_block_height
     ,price_token
     ,liquidity
     ,type
    from (
         select address
              ,token
              ,sum(balance) balance
              ,max(block_height) block_height
              ,sum(total_transfer_volume) total_transfer_volume
              ,sum(total_transfer_count) total_transfer_count
              ,nft_token_id
              ,sum(in_transfer_volume) in_transfer_volume
              ,sum(out_transfer_volume) out_transfer_volume
              ,sum(in_transfer_count) in_transfer_count
              ,sum(out_transfer_count) out_transfer_count
              ,max(first_updated_block_height) first_updated_block_height
              ,price_token
              ,sum(liquidity) liquidity
              ,max(type) as type from token_holding_uni where type='lp'
         group by address,token,nft_token_id,price_token ) tb1 ;


insert into token_balance_volume_usd(address, token, balance_usd, volume_usd)
    select distinct eh.address as address, 'eth' as token, eh.balance * price asbalance_usd , eh.total_transfer_all_volume* price as volume_usd from eth_holding eh
                                                                                                                                                     inner join white_list_erc20 wle on symbol='WETH' where eh.balance > 0 or eh.total_transfer_all_volume>0;
insert into token_balance_volume_usd(address, token, balance_usd, volume_usd)
    select distinct th.address, token, th.balance * price as balance_usd, total_transfer_all_volume* price as volume_usd from token_holding th
                                                                                                                              inner join white_list_erc20 wle  on th.token = wle.address and ignored = false where
    (th.balance > 0 or th.total_transfer_all_volume>0) and th.token in (select token_id from dim_rank_token);




insert into total_balance_volume_usd(address, balance_usd, volume_usd)
    (select address, sum(balance_usd), sum(volume_usd) from token_balance_volume_usd where address is not null group by address);

insert
    into
    dex_tx_volume_count_summary(address,
                                token,
                                type,
                                project,
                                block_height,
                                total_transfer_volume_usd,
                                total_transfer_count,
                                first_updated_block_height,
                                balance_usd)
    select
    dtvcr.address,
    token,
    type,
    project,
    max(block_height) block_height,
    sum(total_transfer_volume * w.price) total_transfer_volume_usd,
    sum(total_transfer_count) total_transfer_count,
    min(first_updated_block_height) first_updated_block_height,
    sum(balance * w.price) balance_usd
    from
    dex_tx_volume_count_record dtvcr
        inner join white_list_erc20 w on
            w.address = dtvcr."token"
    group by
    dtvcr.address,
    token,
    type,
    project;

insert
    into
    dex_tx_volume_count_summary (address,
                                 token,
                                 type,
                                 project,
                                 block_height,
                                 total_transfer_volume_usd,
                                 total_transfer_count,
                                 first_updated_block_height,
                                 balance_usd)
    select
    th.address,
    th.token,
    th.type as type,
    '0xc36442b4a4522e871399cd717abdd847ab11fe88' as project,
    max(th.block_height) as block_height,
    sum(th.total_transfer_volume * w.price) as total_transfer_volume_usd,
    sum(total_transfer_count) as total_transfer_count,
    min(first_updated_block_height) as first_updated_block_height,
    sum(th.balance * w.price) as balance_usd
    from
    token_holding_uni_cal th
        inner join white_list_erc20 w on
            w.address = th.price_token
    where
    (th.balance >= 0
        and th.total_transfer_volume >= 0)
    group by
    th.address,
    th.token,
    th.type;


insert
    into
    web3_transaction_record_summary(address,
                                    total_transfer_volume,
                                    total_transfer_count,
                                    type,
                                    project,
                                    balance)
    select
    address,
    sum(total_transfer_volume) as total_transfer_volume ,
    sum(total_transfer_count) as total_transfer_count ,
    type ,
    project,
    sum(balance) as balance
    from
    web3_transaction_record
    group by
    address,
    type ,
    project;

update web3_transaction_record_summary set type ='mint' where type='Mint';
update web3_transaction_record_summary set type ='write' where type='Write';

insert into
    eth_holding_vol_count(address,
                          total_transfer_volume,
                          total_transfer_count,
                          total_transfer_to_count,
                          total_transfer_all_count,
                          total_transfer_to_volume,
                          total_transfer_all_volume)
    select
    address,
    sum(total_transfer_volume) total_transfer_volume,
    sum(total_transfer_count) total_transfer_count,
    sum(total_transfer_to_count) as total_transfer_to_count,
    sum(total_transfer_all_count) as total_transfer_all_count,
    sum(total_transfer_to_volume) as total_transfer_to_volume,
    sum(total_transfer_all_volume) total_transfer_all_volume
    from
    (
        select
            from_address address,
            sum(amount) total_transfer_volume,
            sum(1) total_transfer_count,
            0 as total_transfer_to_count,
            sum(1) total_transfer_all_count,
            0 as total_transfer_to_volume,
            sum(amount) total_transfer_all_volume
        from
            eth_tx_record where amount>0
        group by
            from_address

        union all select
                      to_address address,
                      0 as total_transfer_volume,
                      0 as total_transfer_count,
                      sum(1) as total_transfer_to_count,
                      sum(1) total_transfer_all_count,
                      sum(amount) as total_transfer_to_volume,
                      sum(amount) total_transfer_all_volume
        from
            eth_tx_record where amount>0
        group by
            to_address) atb group by  address;

insert into
    token_holding_vol_count(address,
                            token,
                            total_transfer_volume,
                            total_transfer_count,
                            total_transfer_to_count,
                            total_transfer_all_count,
                            total_transfer_to_volume,
                            total_transfer_all_volume)
    select
    address,
    token,
    sum(total_transfer_volume) total_transfer_volume,
    sum(total_transfer_count) total_transfer_count,
    sum(total_transfer_to_count) as total_transfer_to_count,
    sum(total_transfer_all_count) as total_transfer_all_count,
    sum(total_transfer_to_volume) as total_transfer_to_volume,
    sum(total_transfer_all_volume) total_transfer_all_volume
    from
    (
        select
            from_address address,
            token,
            sum(amount) total_transfer_volume,
            sum(1) total_transfer_count,
            0 as total_transfer_to_count,
            sum(1) total_transfer_all_count,
            0 as total_transfer_to_volume,
            sum(amount) total_transfer_all_volume
        from
            erc20_tx_record
        group by
            from_address,
            token

        union all select
                      to_address address,
                      token,
                      0 as total_transfer_volume,
                      0 as total_transfer_count,
                      sum(1) as total_transfer_to_count,
                      sum(1) total_transfer_all_count,
                      sum(amount) as total_transfer_to_volume,
                      sum(amount) total_transfer_all_volume
        from
            erc20_tx_record
        group by
            to_address,
            token ) atb group by  address,token;

insert
    into
    token_volume_usd(address,
                     token,
                     volume_usd)
    select
    distinct eh.address as address,
             'eth' as token,
             eh.total_transfer_all_volume * wle.price  as volume_usd
    from
    eth_holding_vol_count eh
        inner join white_list_erc20 wle on
            symbol = 'WETH'
    where
        eh.balance > 0
   or eh.total_transfer_all_volume>0;
insert
    into
    token_volume_usd(address,
                     token,
                     volume_usd)
    select
    distinct th.address,
             token,
             total_transfer_all_volume * wle.price as volume_usd
    from
    token_holding_vol_count th
        inner join white_list_erc20 wle on
                th.token = wle.address
            and ignored = false
    where
    (th.balance > 0
        or th.total_transfer_all_volume>0)
  and th.token in (
    select
        token_id
    from
        dim_rank_token);



insert into total_volume_usd(address, volume_usd)
    (select address,  sum(volume_usd) from token_volume_usd where address is not null group by address);






