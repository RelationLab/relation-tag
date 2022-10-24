drop table if exists dim_rule_sql_content;
create table address_labels_json_gin
(
    address    varchar(512),
    labels     json,
    updated_at timestamp
);