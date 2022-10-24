drop table if exists address_labels_json_gin;
create table address_labels_json_gin
(
    address    varchar(512),
    labels     json,
    updated_at timestamp
);