DROP TABLE IF EXISTS address_labels_json_gin_temp_${tableSuffix} CASCADE;
CREATE TABLE address_labels_json_gin_temp_${tableSuffix}
(
    id      BIGSERIAL,
    address TEXT  NOT NULL,
    data    TEXT NOT NULL
) WITH (appendoptimized = true, orientation = column) DISTRIBUTED BY (address);
CREATE INDEX idx_address_labels_json_gin_temp_${tableSuffix}_id ON address_labels_json_gin_temp_${tableSuffix}(id);
truncate table address_labels_json_gin_temp_${tableSuffix};
vacuum address_labels_json_gin_temp_${tableSuffix};

INSERT INTO address_labels_json_gin_temp_${tableSuffix}(address, data)
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
           )::TEXT
FROM address_label_gp_temp_${tableSuffix}
         LEFT JOIN contract ON (address_label_gp_temp_${tableSuffix}.address = contract.contract_address)
GROUP BY (address_label_gp_temp_${tableSuffix}.address);

insert into tag_result(table_name,batch_date)  SELECT 'address_labels_json_gin_${tableSuffix}' as table_name,'${batchDate}'  as batch_date;
delete from  tag_result where  table_name='tagging';
delete from tag_result where batch_date<'${batchDate}';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;