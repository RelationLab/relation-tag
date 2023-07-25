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
    recent_time_code
from
    erc20_tx_record
        inner join (select * from top_token_1000 where holders >= 100 and removed <> 'true') top_token_1000
                   on(erc20_tx_record.token = top_token_1000.address)
        inner join (
        select
            *
        from
            recent_time
        where
                recent_time.recent_time_code = '1m' ) recent_time on
        (erc20_tx_record.block_number >= recent_time.block_height)
where to_address=sender
group by
    to_address,
    token,
    recent_time_code;

insert into tag_result(table_name,batch_date)  SELECT 'erc20_tx_record_to_${recent_time_code}' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

