DROP TABLE if EXISTS  static_asset_level_data;
create table static_asset_level_data
(
    static_code  varchar(200) not null,
    address_num numeric(250, 20) NULL,
    dimension_type varchar(50)  null,---维度类型:token\project\action
    bus_type varchar(50)  null,---业务类型:vol balance activity
    "level" varchar(50)  null----级别类型 L1\L2....
);


----按资产+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,bus_type,level)
select
    asset as static_code,
    count(1) as address_num,
    'token' as dimension_type,
     bus_type,
     level
from
    address_label_gp where (bus_type='balance' or bus_type='activity' or bus_type='volume')
                       and asset in(select distinct token_name from top_ten_token)
group by asset,bus_type,level;

----按平台+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,bus_type,level)
select
    project as static_code,
    count(1) as address_num,
    'project' as dimension_type,
    bus_type,
    level
from
    address_label_gp where (bus_type='balance' or bus_type='activity' or bus_type='volume')
group by project,bus_type,level;


----按行为+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,bus_type,level)
select
    trade_type as static_code,
    count(1) as address_num,
    'action' as dimension_type,
    bus_type,
    level
from
    address_label_gp where bus_type='balance' or bus_type='activity' or bus_type='volume'
group by trade_type,bus_type,level;





