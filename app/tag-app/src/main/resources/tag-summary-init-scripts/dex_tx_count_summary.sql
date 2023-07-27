INSERT
INTO
    dex_tx_count_summary(address,
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
    dex_tx_count_summary
GROUP BY
    address,
    project,
    recent_time_code;

insert into tag_result(table_name,batch_date)  SELECT 'dex_tx_count_summary' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
