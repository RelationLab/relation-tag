---汇总UNIv3的LP数据
insert
into
    dex_tx_volume_count_summary_univ3(address,
                                      token,
                                      type,
                                      project,
                                      block_height,
                                      total_transfer_volume_usd,
                                      total_transfer_count,
                                      first_updated_block_height,
                                      balance_usd,
                                      recent_time_code)
select
    th.address,
    th.token as token,
    th.type as type,
    '0xc36442b4a4522e871399cd717abdd847ab11fe88' as project,
    max(th.block_height) as block_height,
    sum(th.total_transfer_volume) as total_transfer_volume_usd,
    sum(total_transfer_count) as total_transfer_count,
    min(first_updated_block_height) as first_updated_block_height,
    sum(balance) as balance_usd,
    '${recentTimeCode}' recent_time_code
from
    token_holding_uni_filter th
        where  th.block_height >= ${recentTimeBlockHeight}  and triggered_flag='1'
group by
    th.address,
    th.token,
    th.type;
insert into tag_result(table_name,batch_date)  SELECT 'dex_tx_volume_count_summary_univ3_${recentTimeCode}' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
