drop table if exists address_label_gp;
CREATE TABLE public.address_label_gp
(
    "owner"    varchar(256) NULL,
    address    varchar(512) NULL,
    label_type varchar(512) NULL,
    label_name varchar(1024) NULL,
    "source"   varchar(100) NULL,
    updated_at timestamp(6) NULL
) ;

drop table if exists address_labels_json_gin;
create table address_labels_json_gin
(
    address    varchar(512),
    labels     json,
    updated_at timestamp
) distributed by (address);