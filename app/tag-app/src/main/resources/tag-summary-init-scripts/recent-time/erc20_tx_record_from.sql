insert into
    erc20_tx_record_from(address,
                         token,
                         block_height,
                         total_transfer_volume,
                         total_transfer_count,
                         recent_time_code)
select
    from_address address,
    token,
    max(block_number) as block_height,
    sum(amount) total_transfer_volume,
    sum(case
            when sender = from_address then 1
            else 0
        end ) total_transfer_count,
    '${recentTimeCode}' recent_time_code
from erc20_tx_record
where erc20_tx_record.block_number >= ${recentTimeBlockHeight}
group by
    from_address,
    sender,
    token;
insert into tag_result(table_name,batch_date)  SELECT 'erc20_tx_record_from_${recentTimeCode}' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
