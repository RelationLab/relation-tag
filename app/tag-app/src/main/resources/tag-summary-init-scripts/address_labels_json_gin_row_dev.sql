DROP TABLE IF EXISTS address_labels_json_gin_row_temp_${tableSuffix} CASCADE;
CREATE TABLE address_labels_json_gin_row_temp_${tableSuffix}
(
    address          TEXT NOT NULL,
    address_type     varchar(2) NULL,
    data             jsonb NULL,
    total_num        int8,
    recent_time_code varchar(30) NULL
) WITH (appendoptimized = true, orientation = column) DISTRIBUTED BY
(
    address,
    recent_time_code
);
truncate table address_labels_json_gin_row_temp_${tableSuffix};
vacuum
address_labels_json_gin_row_temp_
${tableSuffix};

INSERT INTO address_labels_json_gin_row_temp_${tableSuffix}(address, address_type, data, recent_time_code, total_num)
SELECT address_label_gp_temp_${tableSuffix}.address,
       CASE WHEN COUNT(contract_address) > 0 THEN 'c' ELSE 'p' END as address_type,
       JSONB_AGG(
               JSONB_BUILD_OBJECT(
                       't', label_type,
                       'nm', label_name,
                       'wt', wired_type,
                       'dt', data :: TEXT,
                       'gp', "group",
                       'lv', level,
                       'cat', category,
                       'tdt', trade_type,
                       'pf', project,
                       'ast', asset
                       'owt', ''----如何取值
                       'twt', ''----如何取值
                   ) ORDER BY label_type DESC
           ),
       address_label_gp_temp_${tableSuffix}.recent_time_code,
       sum(1)                                                      as total_num
FROM address_label_gp_temp_${tableSuffix}
         LEFT JOIN contract ON (address_label_gp_temp_${tableSuffix}.address = contract.contract_address)
GROUP BY (address_label_gp_temp_${tableSuffix}.address, address_label_gp_temp_${tableSuffix}.recent_time_code);
insert into tag_result(table_name, batch_date)
SELECT 'address_labels_json_gin_row_${tableSuffix}' as table_name, '${batchDate}' as batch_date;
