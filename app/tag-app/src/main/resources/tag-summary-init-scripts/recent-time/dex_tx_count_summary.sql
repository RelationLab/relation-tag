INSERT
INTO
    dex_tx_count_summary(address,
                         token,
                         TYPE,
                         project,
                         total_transfer_count,
                         recent_time_code)
select
    address,
    'ALL' as token,
    type,
    project,
    sum(total_transfer_count) total_transfer_count,
    '${recentTimeCode}'  recent_time_code
from
    (
        select
            dex_tx_volume_count_record_filter.address,
            dex_tx_volume_count_record_filter.TYPE,
            dex_tx_volume_count_record_filter.project,
            max(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_record_filter
        where dex_tx_volume_count_record_filter.block_height >= ${recentTimeBlockHeight}
            and  triggered_flag = '1'
            and total_transfer_count = 1
        group by
            dex_tx_volume_count_record_filter.address,
            dex_tx_volume_count_record_filter.TYPE,
            dex_tx_volume_count_record_filter.project,
            dex_tx_volume_count_record_filter.transaction_hash) outt
group by
    address,
    type,
    project;

INSERT
INTO
    dex_tx_count_summary(address,
                         token,
                         TYPE,
                         project,
                         total_transfer_count,
                         recent_time_code)
select
    address,
    'ALL' token,
    type,
    '0xc36442b4a4522e871399cd717abdd847ab11fe88' project,
    sum(total_transfer_count),
    '${recentTimeCode}'  recent_time_code
from
    (
        select
            th.address,
            'ALL' as token,
            th.type as type,
            max(total_transfer_count) as total_transfer_count
        from
            token_holding_uni_filter th

        where th.block_height >= ${recentTimeBlockHeight} and triggered_flag = '1'
        group by
            th.address,
            th.type,
            th.transaction_hash) outt
group by
    address,
    type;

insert into tag_result(table_name,batch_date)  SELECT 'dex_tx_count_summary_${recentTimeCode}' as table_name,'${batchDate}'  as batch_date;
