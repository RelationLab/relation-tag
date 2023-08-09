DROP TABLE IF EXISTS address_labels_json_gin_temp_${tableSuffix} CASCADE;
CREATE TABLE address_labels_json_gin_temp_${tableSuffix}
(
    id       BIGSERIAL,
    address  TEXT NOT NULL,
    data     TEXT NOT NULL,
    data_3d  TEXT NOT NULL,
    data_7d  TEXT NOT NULL,
    data_15d TEXT NOT NULL,
    data_1m  TEXT NOT NULL,
    data_3m  TEXT NOT NULL,
    data_6m  TEXT NOT NULL,
    data_1y  TEXT NOT NULL,
    data_2y  TEXT NOT NULL
) WITH (appendoptimized = true, orientation = column) DISTRIBUTED BY
(
    address
);
CREATE INDEX idx_address_labels_json_gin_temp_${tableSuffix}_id_${batchDateReplace} ON address_labels_json_gin_temp_${tableSuffix}(id);
truncate table address_labels_json_gin_temp_${tableSuffix};
vacuum address_labels_json_gin_temp_${tableSuffix};

INSERT INTO address_labels_json_gin_temp_${tableSuffix}(address, data, data_3d, data_7d, data_15d, data_1m, data_3m,
                                                        data_6m, data_1y, data_2y)
SELECT address,
       max(CASE WHEN recent_time_code = 'ALL' THEN data ELSE '' END) AS data,
       max ( CASE WHEN recent_time_code = '3d' THEN data ELSE '' END) AS data_3d,
       max ( CASE WHEN recent_time_code = '7d' THEN data ELSE '' END) AS data_7d,
       max ( CASE WHEN recent_time_code = '15d' THEN data ELSE '' END) AS data_15d,
       max ( CASE WHEN recent_time_code = '1m' THEN data ELSE '' END) AS data_1m,
       max ( CASE WHEN recent_time_code = '3m' THEN data ELSE '' END) AS data_3m,
       max ( CASE WHEN recent_time_code = '6m' THEN data ELSE '' END) AS data_6m,
       max ( CASE WHEN recent_time_code = '1y' THEN data ELSE '' END) AS data_1y,
       max ( CASE WHEN recent_time_code = '2y' THEN data ELSE '' END) AS data_2y
FROM
    address_labels_json_gin_row_temp_${tableSuffix}
GROUP BY address;

insert into tag_result(table_name, batch_date)
SELECT 'address_labels_json_gin_${tableSuffix}' as table_name, '${batchDate}' as batch_date;
insert into tag_result(table_name, batch_date)
SELECT 'tagging' as table_name, '${batchDate}' as batch_date;
