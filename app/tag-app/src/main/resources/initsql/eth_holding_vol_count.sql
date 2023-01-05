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
            to_address) atb group by  address

