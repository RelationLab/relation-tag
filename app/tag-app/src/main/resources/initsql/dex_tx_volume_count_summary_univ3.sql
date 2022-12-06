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
    token_holding_uni th
        inner join white_list_erc20 w on
            w.address = th.price_token
    where
    (th.balance >= 0
        and th.total_transfer_volume >= 0)
    group by
    th.address,
    th.token,
    th.type