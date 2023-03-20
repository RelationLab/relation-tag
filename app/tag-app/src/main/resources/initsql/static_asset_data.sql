DROP TABLE if EXISTS  static_asset_data;
create table static_asset_data
(
    code  varchar(200) not null,
    balance_address_num numeric(250, 20) NULL,
    volume_address_num numeric(250, 20) NULL,
    activity_address_num numeric(250, 20) NULL,
    code_type  varchar(10)  null
);