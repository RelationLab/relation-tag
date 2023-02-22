drop table if exists token_holding_vol_count_tmp;
create table token_holding_vol_count_tmp as select * from token_holding_vol_count;
truncate table token_holding_vol_count;
insert into
    token_holding_vol_count(address,
                            block_height,
                            token,
                            total_transfer_volume,
                            total_transfer_count,
                            total_transfer_to_count,
                            total_transfer_all_count,
                            total_transfer_to_volume,
                            total_transfer_all_volume)
select
    address,
    max(block_height) as block_height,
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
            address,
            max(block_height) as block_height,
            token,
            sum(total_transfer_volume) total_transfer_volume,
            sum(total_transfer_count) total_transfer_count,
            sum(total_transfer_to_count) as total_transfer_to_count,
            sum(total_transfer_all_count) total_transfer_all_count,
            sum(total_transfer_to_volume) as total_transfer_to_volume,
            sum(total_transfer_all_volume) total_transfer_all_volume
        from
            token_holding_vol_count_tmp thvc
        group by
            address,
            token
            union all
        select
            from_address address,
            max(block_height) as block_height,
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
                      max(block_height) as block_height,
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
            token ) atb where address !='' group by  address,token;




