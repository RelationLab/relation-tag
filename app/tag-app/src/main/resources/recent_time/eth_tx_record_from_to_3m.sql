insert into
    eth_tx_record_from_to(address,
                          block_height,
                          total_transfer_volume,
                          total_transfer_count,
                          recent_time_code)

select
    address,
    max(atb.block_height) as block_height,
    sum(total_transfer_volume) total_transfer_volume,
    sum(total_transfer_count) total_transfer_count,
    recent_time.recent_time_code as recent_time_code
from
    (
        select
            from_address address,
            max(block_number) as block_height,
            sum(amount) total_transfer_volume,
            sum(1) total_transfer_count
        from
            eth_tx_record etr
        where
            tx_type!='ETH_INTERNAL'
        group by
            from_address
        union all
        select
            to_address address,
            max(block_number) as block_height,
            sum(amount) as total_transfer_volume,
            0 as total_transfer_count
        from
            eth_tx_record etr
        where
            tx_type!='ETH_INTERNAL'
        group by
            to_address) atb
        left join (select * from  recent_time where recent_time.recent_time_code='3m' ) recent_time on
        (atb.block_height >= recent_time.block_height)
where address !=''
group by
    address,
    recent_time.recent_time_code;
insert into tag_result(table_name,batch_date)  SELECT 'eth_tx_record_from_to_3m' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

