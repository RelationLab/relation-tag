insert into
    eth_tx_record_from_to(address,
                          block_height,
                          total_transfer_volume,
                          total_transfer_count,
                          recent_time_code)

select
    address,
    min(atb.block_height) as block_height,
    sum(total_transfer_volume) total_transfer_volume,
    sum(total_transfer_count) total_transfer_count,
    '${recentTimeCode}' recent_time_code
from
    (
        select
            from_address address,
            max(block_number) as block_height,
            sum(amount) total_transfer_volume,
            sum(1) total_transfer_count
        from
            eth_tx_record etr where block_number >=  ${recentTimeBlockHeight}
        group by
            from_address
        union all
        select
            to_address address,
            max(block_number) as block_height,
            sum(amount) as total_transfer_volume,
            0 as total_transfer_count
        from
            eth_tx_record etr where block_number >= ${recentTimeBlockHeight}
        group by
            to_address) atb
where address !=''
group by
    address;


insert into tag_result(table_name,batch_date)  SELECT 'eth_tx_record_from_to_${recentTimeCode}' as table_name,'${batchDate}'  as batch_date;

