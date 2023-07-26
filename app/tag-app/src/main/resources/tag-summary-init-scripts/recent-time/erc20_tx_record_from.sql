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
    1 total_transfer_count,
    recent_time_code
from erc20_tx_record
         inner join (select * from  recent_time where recent_time.recent_time_code='${recent_time_code}' ) recent_time on
        (erc20_tx_record.block_number >= recent_time.block_height)
        and from_address=sender
group by
    from_address,
    sender,
    token,
    hash,
    recent_time_code;
insert into tag_result(table_name,batch_date)  SELECT 'erc20_tx_record_from_${recent_time_code}' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

