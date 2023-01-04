insert into
    eth_holding_vol_count(address,
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
    (a1.total_transfer_volume + a2.total_transfer_volume) total_transfer_volume,
    (a1.total_transfer_count + a2.total_transfer_count) total_transfer_count,
    (a1.total_transfer_to_count + a2.total_transfer_to_count) as total_transfer_to_count,
    (a1.total_transfer_all_count + a2.total_transfer_all_count) as total_transfer_all_count,
    (a1.total_transfer_to_volume + a2.total_transfer_to_volume) as total_transfer_to_volume,
    (a1.total_transfer_all_volume + a2.total_transfer_all_volume) total_transfer_all_volume
from
    (
        select
            from_address address,
            token,
            sum(amount) total_transfer_volume,
            count(1) total_transfer_count,
            0 as total_transfer_to_count,
            sum(amount) total_transfer_all_count,
            0 as total_transfer_to_volume,
            count(1) total_transfer_all_volume
        from
            eth_tx_record where amount >0
        group by
            from_address,
            token ) a1

        left join (select
                       to_address address,
                       token,
                       0 as total_transfer_volume,
                       0 as total_transfer_count,
                       count(1) as total_transfer_to_count,
                       sum(amount) total_transfer_all_count,
                       sum(amount) as total_transfer_to_volume,
                       count(1) total_transfer_all_volume
                   from
                       eth_tx_record where amount >0
                   group by
                       to_address,
                       token ) a2 on (a1.address=a2.address and a1.token=a2.token)
