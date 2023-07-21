drop table if exists dex_tx_count_summary;
CREATE TABLE public.dex_tx_count_summary (
                                             address varchar(256) NOT NULL,
                                             "token" varchar(256) NOT NULL,
                                             total_transfer_count int8 DEFAULT 0,
                                             transaction_hash varchar(100) NULL,
                                             created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                             removed bool NULL DEFAULT FALSE,
                                             "type" varchar(10) NULL,
                                             project varchar(100) NULL,
                                             recent_time_code varchar(30)  NULL
) DISTRIBUTED BY (address);
truncate table dex_tx_count_summary;
vacuum dex_tx_count_summary;

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
    recent_time_code
from
    (
        select
            dex_tx_volume_count_record_filterate.address,
            dex_tx_volume_count_record_filterate.TYPE,
            dex_tx_volume_count_record_filterate.project,
            max(total_transfer_count) as total_transfer_count,
            recent_time_code
        from
            dex_tx_volume_count_record_filterate
                inner join (select * from recent_time where recent_time.recent_time_code = '${recent_time_code}') recent_time
                           on
                               (dex_tx_volume_count_record_filterate.block_height >= recent_time.block_height)
        where
                triggered_flag = '1'
          and total_transfer_count = 1
        group by
            dex_tx_volume_count_record_filterate.address,
            dex_tx_volume_count_record_filterate.TYPE,
            dex_tx_volume_count_record_filterate.project,
            dex_tx_volume_count_record_filterate.transaction_hash,
            recent_time_code) outt
group by
    address,
    type,
    project,
    recent_time_code;

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
    recent_time_code
from
    (
        select
            th.address,
            'ALL' as token,
            th.type as type,
            max(total_transfer_count) as total_transfer_count,
            recent_time_code
        from
            token_holding_uni_filterate th
                inner join (select * from recent_time where recent_time.recent_time_code = '${recent_time_code}') recent_time
                           on
                               (th.block_height >= recent_time.block_height)
        where triggered_flag = '1'
        group by
            th.address,
            th.type,
            th.transaction_hash,
            recent_time_code) outt
group by
    address,
    type,
    recent_time_code;


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

insert into tag_result(table_name,batch_date)  SELECT 'dex_tx_count_summary_${recent_time_code}' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
