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
    case when asset is null then '' else  asset end   as static_code,
    count(1) as address_num,
    'token' as dimension_type,
     bus_type,
     level
from
    address_label_gp where (bus_type='balance' or bus_type='activity' or bus_type='volume') and category='grade'
                       and asset in(select distinct token_name from top_ten_token where token_type='token')
group by asset,bus_type,level;

----按资产+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,bus_type,level)
select
    case when asset is null then '' else  asset end   as static_code,
    count(1) as address_num,
    'nft' as dimension_type,
    bus_type,
    level
from
    address_label_gp where (bus_type='balance' or bus_type='activity' or bus_type='volume') and category='grade'
                       and asset in(select distinct token_name from top_ten_token where token_type='nft')
group by asset,bus_type,level;

----按平台+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,bus_type,level)
select
    case when project is null then '' else  project end  as static_code,
    count(1) as address_num,
    'project' as dimension_type,
    bus_type,
    level
from
    address_label_gp where (bus_type='balance' or bus_type='activity' or bus_type='volume') and category='grade'
group by project,bus_type,level;


----按行为+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,bus_type,level)
select
    case when trade_type is null then '' else  trade_type end  as static_code,
    count(1) as address_num,
    'action' as dimension_type,
    bus_type,
    level
from
    address_label_gp where (bus_type='balance' or bus_type='activity' or bus_type='volume') and category='grade'
group by trade_type,bus_type,level;



DROP TABLE if EXISTS  static_asset_level_data_json;
create table static_asset_level_data_json
(
    static_code  varchar(200) not null,
    dimension_type varchar(50)  null,---维度类型:token\project\action
    bus_type varchar(50)  null,---业务类型:vol balance activity
    json_text text
);

insert
into
    static_asset_level_data_json(static_code,
                                 dimension_type,
                                 bus_type,
                                 json_text)
select
    sald.static_code ,
    sald.dimension_type ,
    sald.bus_type,
    '{' || '"symbol":"'||sald.static_code||'",'  || string_agg('"' || level || '":' || address_num, ',')|| '}'
from
    static_asset_level_data sald
group by
    static_code,
    dimension_type,
    bus_type;


DROP TABLE if EXISTS  static_asset_data_json;
create table static_asset_data_json
(
    dimension_type varchar(50)  null,---维度类型:token\project\action
    bus_type varchar(50)  null,---业务类型:vol balance activity
    json_text jsonb
);

insert into static_asset_data_json(dimension_type,bus_type,json_text)
select
    dimension_type,
    bus_type,
    json_agg(json_text::jsonb)
from
    static_asset_level_data_json group by
                                     dimension_type,
                                     bus_type;







