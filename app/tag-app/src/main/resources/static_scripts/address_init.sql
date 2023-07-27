DROP TABLE if EXISTS  tag_result${tableSuffix};
create table tag_result${tableSuffix}
(
    table_name  varchar(100) not null,
    batch_date  varchar(100) not null
);

DROP TABLE if EXISTS  address_init${tableSuffix};
create table address_init${tableSuffix}
(
    address  varchar(100) not null
) distributed by (address);
INSERT INTO address_init${tableSuffix} ${conditionData};
INSERT INTO tag_result${tableSuffix}(table_name,batch_date) select ('address_init${tableSuffix}') as table_name,'${batchDate}'  as batch_date;

