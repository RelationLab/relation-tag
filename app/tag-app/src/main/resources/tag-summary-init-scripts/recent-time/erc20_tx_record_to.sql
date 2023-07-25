insert
into
    erc20_tx_record_to(address,
                       token,
                       block_height,
                       total_transfer_volume,
                       total_transfer_count,
                       recent_time_code)
select
    to_address address,
    token,
    max(block_number) as block_height,
    sum(total_transfer_volume) as total_transfer_volume,
    0 as total_transfer_count,
    recent_time_code
from
    erc20_tx_record_filter
        inner join (
        select
            *
        from
            recent_time
        where
                recent_time.recent_time_code = '${recent_time_code}' ) recent_time on
        (erc20_tx_record_filter.block_number >= recent_time.block_height)
group by
    to_address,
    token,
    recent_time_code;

insert into tag_result(table_name,batch_date)  SELECT 'erc20_tx_record_to_${recent_time_code}' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

