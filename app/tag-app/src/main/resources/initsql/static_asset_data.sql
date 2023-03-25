

DROP TABLE if EXISTS  token_address_activity;
create table token_address_activity
(
    address  varchar(200) not null,
    token  varchar(200) not null,
    activity_num numeric(250, 20) NULL,
    code_type varchar(10) not null
);
truncate table token_address_activity;
insert
into
    token_address_activity(activity_num,
                           address,
                           token,
                           code_type)
select
    sum(activity_num),
    address,
    token,
    code_type
from
    (
        select
            sum(total_transfer_count) as activity_num,
            address,
            token,
            'DEFI' as code_type
        from
            token_holding_vol_count
        group by
            address,
            token
        union all
        select
            sum(total_transfer_all_count) as activity_num,
            address,
            token,
            'NFT' as code_type
        from
            nft_holding
        group by
            address,
            token)
        out_t
group by
    address,
    token,
    code_type;


code_type varchar(50) not null
);

DROP TABLE if EXISTS  token_address_activity;
create table token_address_activity
(
    address  varchar(200) not null,
    token  varchar(200) not null,
    activity_num numeric(250, 20) NULL,
    code_type varchar(10) not null
);

truncate table token_address_activity;
insert
into
    token_address_activity(activity_num,
                           address,
                           token,
                           code_type)
select
    sum(activity_num),
    address,
    token,
    code_type
from
    (
        select
            sum(total_transfer_count) as activity_num,
            address,
            token,
            'DEFI' as code_type
        from
            token_holding_vol_count
        group by
            address,
            token
        union all
        select
            sum(total_transfer_all_count) as activity_num,
            address,
            token,
            'NFT' as code_type
        from
            nft_holding
        group by
            address,
            token)
        out_t
group by
    address,
    token,
    code_type;

DROP TABLE if EXISTS  static_asset_data;
create table static_asset_data
(
    code  varchar(200) not null,
    balance_address_num numeric(250, 20) NULL,
    volume_address_num numeric(250, 20) NULL,
    activity_address_num numeric(250, 20) NULL,
    code_type varchar(50) not null
);
insert into static_asset_data  (code,volume_address_num,balance_address_num,activity_address_num,code_type)
select
    token,
    count(1) as volume_address_num,
    "token" code_type
from
    token_volume_usd
group by token,select
    token,
    count(1) as balance_address_num,
    "token" code_type
from
    total_balance_volume_usd
group by token,
    select
   token,
   count(1) as activity_address_num,
   "token" code_type
from
    token_address_activity
group by token;