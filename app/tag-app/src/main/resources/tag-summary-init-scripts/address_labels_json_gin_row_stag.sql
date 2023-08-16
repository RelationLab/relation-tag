DROP TABLE IF EXISTS address_labels_json_gin_row_temp_${tableSuffix} CASCADE;
CREATE TABLE address_labels_json_gin_row_temp_${tableSuffix}
(
    address          TEXT NOT NULL,
    recent_time_code varchar(30) NULL,
    data             text NULL,
    total_num        int8
) WITH (appendoptimized = true, orientation = column) DISTRIBUTED BY
(
    address,
    recent_time_code
);
truncate table address_labels_json_gin_row_temp_${tableSuffix};
vacuum address_labels_json_gin_row_temp_${tableSuffix};

INSERT INTO address_labels_json_gin_row_temp_${tableSuffix}(address, data, recent_time_code, total_num)
SELECT address_label_gp_temp_${tableSuffix}.address,
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
                   ) ORDER BY label_type DESC
           )::text,
        address_label_gp_temp_${tableSuffix}.recent_time_code,
       sum(1) as total_num
FROM address_label_gp_temp_${tableSuffix}
GROUP BY (address_label_gp_temp_${tableSuffix}.address, address_label_gp_temp_${tableSuffix}.recent_time_code);
insert into tag_result(table_name, batch_date)
SELECT 'address_labels_json_gin_row_${tableSuffix}' as table_name, '${batchDate}' as batch_date;
