DROP TABLE IF EXISTS address_labels_json_gin_temp_${tableSuffix} CASCADE;
CREATE TABLE address_labels_json_gin_temp_${tableSuffix}
(
    id      BIGSERIAL,
    address varchar(80) NOT NULL,
    data    TEXT        NOT NULL
) WITH (appendoptimized = true, orientation = column) DISTRIBUTED BY
(
    address
);
CREATE INDEX idx_address_labels_json_gin_temp_${tableSuffix}_id_${batchDateReplace} ON address_labels_json_gin_temp_${tableSuffix}(id);
truncate table address_labels_json_gin_temp_${tableSuffix};
vacuum address_labels_json_gin_temp_${tableSuffix};

INSERT INTO address_labels_json_gin_temp_${tableSuffix}(address, data)
SELECT address,
       JSONB_BUILD_OBJECT(
               'a', address_labels_json_gin_row_temp_${tableSuffix}.address,
               'at', CASE WHEN COUNT(contract_address) > 0 THEN 'c' ELSE 'p' END,
               'l', (max(CASE WHEN recent_time_code = 'ALL' THEN data ELSE '[]' END))::JSONB,
               'd3l', (max(CASE WHEN recent_time_code = '3d' THEN data ELSE '[]' END))::JSONB,
               'd7l', (max(CASE WHEN recent_time_code = '7d' THEN data ELSE '[]' END))::JSONB,
               'd15l', (max(CASE WHEN recent_time_code = '15d' THEN data ELSE '[]' END))::JSONB,
               'm1l', (max(CASE WHEN recent_time_code = '1m' THEN data ELSE '[]' END))::JSONB,
               'm3l', (max(CASE WHEN recent_time_code = '3m' THEN data ELSE '[]' END))::JSONB,
               'm6l', (max(CASE WHEN recent_time_code = '6m' THEN data ELSE '[]' END))::JSONB,
               'y1l', (max(CASE WHEN recent_time_code = '1y' THEN data ELSE '[]' END))::JSONB,
               'y2l', (max(CASE WHEN recent_time_code = '2y' THEN data ELSE '[]' END))::JSONB,
               'ul', (max(CASE WHEN recent_time_code = 'ul' THEN data ELSE '[]' END))::JSONB,
               'opl', (max(CASE WHEN recent_time_code = 'opl' THEN data ELSE '[]' END))::JSONB,
               'ls', max(CASE WHEN recent_time_code = 'ALL' THEN total_num ELSE 0 END),
               'd3ls', max(CASE WHEN recent_time_code = '3d' THEN total_num ELSE 0 END),
               'd7ls', max(CASE WHEN recent_time_code = '7d' THEN total_num ELSE 0 END),
               'd15ls', max(CASE WHEN recent_time_code = '15d' THEN total_num ELSE 0 END),
               'm1ls', max(CASE WHEN recent_time_code = '1m' THEN total_num ELSE 0 END),
               'm3ls', max(CASE WHEN recent_time_code = '3m' THEN total_num ELSE 0 END),
               'm6ls', max(CASE WHEN recent_time_code = '6m' THEN total_num ELSE 0 END),
               'y1ls', max(CASE WHEN recent_time_code = '1y' THEN total_num ELSE 0 END),
               'y2ls', max(CASE WHEN recent_time_code = '2y' THEN total_num ELSE 0 END),
               'uls', max(CASE WHEN recent_time_code = 'ul' THEN total_num ELSE 0 END),
               'opls', max(CASE WHEN recent_time_code = 'opl' THEN total_num ELSE 0 END)
           )::TEXT
FROM address_labels_json_gin_row_temp_${tableSuffix}
         LEFT JOIN contract ON (address_labels_json_gin_row_temp_${tableSuffix}.address = contract.contract_address)
GROUP BY address;

insert into tag_result(table_name, batch_date)
SELECT 'address_labels_json_gin_${tableSuffix}' as table_name, '${batchDate}' as batch_date;
insert into tag_result(table_name, batch_date)
SELECT 'tagging' as table_name, '${batchDate}' as batch_date;