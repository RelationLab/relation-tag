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
    sum(amount) as total_transfer_volume,
    0 as total_transfer_count,
    '${recentTimeCode}' recent_time_code
from
    erc20_tx_record
where     erc20_tx_record.block_number >= ${recentTimeBlockHeight}
group by
    to_address,
    token;

insert into tag_result(table_name,batch_date)  SELECT 'erc20_tx_record_to_${recentTimeCode}' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

