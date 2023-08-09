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
    type,
    platform_large_code as project,
    sum(total_transfer_count) AS total_transfer_count,
    recent_time_code
FROM
    dex_tx_count_summary_temp  left join  platform_temp
        on (dex_tx_count_summary_temp.project=platform_temp.platform)
where platform_temp.platform_large_code is not null
GROUP BY
    address,
    project,
    recent_time_code,
    platform_large_code,
    type;

insert into tag_result(table_name,batch_date)  SELECT 'total_dex_tx_count_summary' as table_name,'${batchDate}'  as batch_date;
