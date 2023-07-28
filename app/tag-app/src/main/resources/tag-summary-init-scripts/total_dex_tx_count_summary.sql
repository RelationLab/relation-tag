INSERT
INTO
    dex_tx_count_summary_temp(address,
                         token,
                         TYPE,
                         project,
                         total_transfer_count,
                         recent_time_code)
SELECT
    address,
    'ALL' AS token,
    'ALL' as TYPE,
    project,
    sum(total_transfer_count) AS total_transfer_count,
    recent_time_code
FROM
    dex_tx_count_summary_temp
GROUP BY
    address,
    project,
    recent_time_code;

insert into tag_result(table_name,batch_date)  SELECT 'total_dex_tx_count_summary' as table_name,'${batchDate}'  as batch_date;
