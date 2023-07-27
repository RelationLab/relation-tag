insert
into
    web3_transaction_record_summary(address,
                                    total_transfer_volume,
                                    total_transfer_count,
                                    type,
                                    project,
                                    balance,
                                    recent_time_code)
select
    lower(address) as address,
    sum(total_transfer_volume) as total_transfer_volume ,
    sum(total_transfer_count) as total_transfer_count ,
    type ,
    project,
    sum(balance) as balance,
    '${recentTimeCode}' recent_time_code
from
    web3_transaction_record
    where web3_transaction_record.block_height >= ${recentTimeBlockHeight}
group by
    address,
    type ,
    project;
insert into tag_result(table_name,batch_date)  SELECT 'web3_transaction_record_summary_${recentTimeCode}' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

