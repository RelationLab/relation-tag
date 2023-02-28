drop table if exists eth_holding_vol_count_tmp;
ALTER TABLE public.eth_holding_vol_count RENAME TO eth_holding_vol_count_tmp;
create table eth_holding_vol_count as select * from eth_holding_vol_count_tmp limit 1;
truncate table eth_holding_vol_count;
insert
into
    eth_holding_vol_count(address,
                          block_height,
                          total_transfer_volume,
                          total_transfer_count,
                          total_transfer_to_count,
                          total_transfer_all_count,
                          total_transfer_to_volume,
                          total_transfer_all_volume)
select
    address,
    max(block_height) as block_height,
    sum(total_transfer_volume) total_transfer_volume,
    sum(total_transfer_count) total_transfer_count,
    sum(total_transfer_to_count) as total_transfer_to_count,
    sum(total_transfer_all_count) as total_transfer_all_count,
    sum(total_transfer_to_volume) as total_transfer_to_volume,
    sum(total_transfer_all_volume) total_transfer_all_volume
from
    (
        select
            address,
            max(block_height) as block_height,
            sum(total_transfer_volume) total_transfer_volume,
            sum(total_transfer_count) total_transfer_count,
            sum(total_transfer_to_count)  total_transfer_to_count,
            sum(total_transfer_all_count) total_transfer_all_count,
            sum(total_transfer_to_volume)  total_transfer_to_volume,
            sum(total_transfer_all_volume)  total_transfer_all_volume
        from
            eth_holding_vol_count_tmp
        group by
            address
        union  all
        select
            from_address address,
            max(block_number) as block_height,
            sum(amount) total_transfer_volume,
            sum(1) total_transfer_count,
            0 as total_transfer_to_count,
            sum(1) total_transfer_all_count,
            0 as total_transfer_to_volume,
            sum(amount) total_transfer_all_volume
        from
            eth_tx_record
        where
                amount>0
        group by
            from_address
        union all
        select
            to_address address,
            max(block_number) as block_height,
            0 as total_transfer_volume,
            0 as total_transfer_count,
            sum(1) as total_transfer_to_count,
            sum(1) total_transfer_all_count,
            sum(amount) as total_transfer_to_volume,
            sum(amount) total_transfer_all_volume
        from
            eth_tx_record
        where
                amount>0
        group by
            to_address) atb where address !=''
group by
    address;


insert into
    eth_holding_vol_count_tmp(address,
                          block_height,
                          total_transfer_volume,
                          total_transfer_count,
                          total_transfer_to_count,
                          total_transfer_all_count,
                          total_transfer_to_volume,
                          total_transfer_all_volume) select address,
                                                            block_height,
                                                            total_transfer_volume,
                                                            total_transfer_count,
                                                            total_transfer_to_count,
                                                            total_transfer_all_count,
                                                            total_transfer_to_volume,
                                                            total_transfer_all_volume
from eth_holding_vol_count limit 10;


