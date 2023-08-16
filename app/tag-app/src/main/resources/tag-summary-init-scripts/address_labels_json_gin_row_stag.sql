DROP TABLE IF EXISTS address_labels_json_gin_row_temp_${tableSuffix} CASCADE;
CREATE TABLE address_labels_json_gin_row_temp_${tableSuffix}
(
    address TEXT  NOT NULL,
    data    TEXT NOT NULL,
    total_num int8,
    recent_time_code varchar(30) NULL
) WITH (appendoptimized = true, orientation = column) DISTRIBUTED BY (address,recent_time_code);
truncate table address_labels_json_gin_row_temp_${tableSuffix};
vacuum address_labels_json_gin_row_temp_${tableSuffix};

INSERT INTO address_labels_json_gin_row_temp_${tableSuffix}(address, data,recent_time_code,total_num)
SELECT address_label_gp_temp_${tableSuffix}.address,
       JSONB_BUILD_OBJECT(
               'address', address_label_gp_temp_${tableSuffix}.address,
               'address_type', CASE WHEN COUNT(contract_address) > 0 THEN 'c' ELSE 'p' END,
               'labels', JSONB_AGG(
                       JSONB_BUILD_OBJECT(
                               'type', label_type,
                               'name', label_name,
                               'wired_type', wired_type,
                               'data', data :: TEXT,
                               'group', "group",
                               'level', level,
                               'category', category,
                               'trade_type', trade_type,
                               'project', project,
                               'asset', asset
                           )
                           ORDER BY label_type DESC
                   ),
               'updated_at', CURRENT_TIMESTAMP
           )::TEXT,
        address_label_gp_temp_${tableSuffix}.recent_time_code,
       sum(1) as total_num
FROM address_label_gp_temp_${tableSuffix}
LEFT JOIN contract ON (address_label_gp_temp_${tableSuffix}.address = contract.contract_address)
GROUP BY (address_label_gp_temp_${tableSuffix}.address,address_label_gp_temp_${tableSuffix}.recent_time_code) ;
insert into tag_result(table_name,batch_date)  SELECT 'address_labels_json_gin_row_${tableSuffix}' as table_name,'${batchDate}'  as batch_date;
