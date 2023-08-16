DROP TABLE IF EXISTS address_labels_json_gin_temp_${tableSuffix} CASCADE;
CREATE TABLE address_labels_json_gin_temp_${tableSuffix}
(
    id      BIGSERIAL,
    address varchar(100) NOT NULL,
    l       TEXT         NOT NULL,
    d3l     TEXT         NOT NULL,
    d7l     TEXT         NOT NULL,
    d15l    TEXT         NOT NULL,
    m1l     TEXT         NOT NULL,
    m3l     TEXT         NOT NULL,
    m6l     TEXT         NOT NULL,
    y1l     TEXT         NOT NULL,
    y2l     TEXT         NOT NULL
        ls int8,
    d3ls    int8,
    d7ls    int8,
    d15ls   int8,
    m1ls    int8,
    m3ls    int8,
    m6ls    int8,
    y1ls    int8,
    y2ls    int8,
    uls     int8,----不理解
    opls    int8----不理解
) WITH (appendoptimized = true, orientation = column) DISTRIBUTED BY
(
    address
);
CREATE INDEX idx_address_labels_json_gin_temp_${tableSuffix}_id_${batchDateReplace} ON address_labels_json_gin_temp_${tableSuffix}(id);
truncate table address_labels_json_gin_temp_${tableSuffix};
vacuum
address_labels_json_gin_temp_
${tableSuffix};

INSERT INTO address_labels_json_gin_temp_${tableSuffix}(address,
                                                        l, d3l, d7l, d15l, m1l, m3l, m6l, y1l, y2l,
                                                        ls, d3ls, d7ls, d15ls, m1ls, m3ls, m6ls, y1ls, y2ls)
SELECT address,
       max(CASE WHEN recent_time_code = 'ALL' THEN data ELSE '' END)      AS l,
       max(CASE WHEN recent_time_code = '3d' THEN data ELSE '' END)       AS d3l,
       max(CASE WHEN recent_time_code = '7d' THEN data ELSE '' END)       AS d7l,
       max(CASE WHEN recent_time_code = '15d' THEN data ELSE '' END)      AS d15l,
       max(CASE WHEN recent_time_code = '1m' THEN data ELSE '' END)       AS m1l,
       max(CASE WHEN recent_time_code = '3m' THEN data ELSE '' END)       AS m3l,
       max(CASE WHEN recent_time_code = '6m' THEN data ELSE '' END)       AS m6l,
       max(CASE WHEN recent_time_code = '1y' THEN data ELSE '' END)       AS y1l,
       max(CASE WHEN recent_time_code = '2y' THEN data ELSE '' END)       AS y2l,
       max(CASE WHEN recent_time_code = 'ALL' THEN total_num ELSE '' END) AS ls,
       max(CASE WHEN recent_time_code = '3d' THEN total_num ELSE '' END)  AS d3ls,
       max(CASE WHEN recent_time_code = '7d' THEN total_num ELSE '' END)  AS d7ls,
       max(CASE WHEN recent_time_code = '15d' THEN total_num ELSE '' END) AS d15ls,
       max(CASE WHEN recent_time_code = '1m' THEN total_num ELSE '' END)  AS m1ls,
       max(CASE WHEN recent_time_code = '3m' THEN total_num ELSE '' END)  AS m3ls,
       max(CASE WHEN recent_time_code = '6m' THEN total_num ELSE '' END)  AS m6ls,
       max(CASE WHEN recent_time_code = '1y' THEN total_num ELSE '' END)  AS y1ls,
       max(CASE WHEN recent_time_code = '2y' THEN total_num ELSE '' END)  AS y2ls
FROM address_labels_json_gin_row_temp_${tableSuffix}
GROUP BY address;

insert into tag_result(table_name, batch_date)
SELECT 'address_labels_json_gin_${tableSuffix}' as table_name, '${batchDate}' as batch_date;
insert into tag_result(table_name, batch_date)
SELECT 'tagging' as table_name, '${batchDate}' as batch_date;
