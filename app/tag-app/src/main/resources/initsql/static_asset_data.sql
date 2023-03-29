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
    case when asset is null or asset='' then 'total' else  asset end   as static_code,
    count(1) as address_num,
    'defi' as dimension_type,
     bus_type,
     level
from
    address_label_gp where (bus_type='balance' or bus_type='activity' or bus_type='volume') and category='grade'
                       and asset in(select distinct token_name from top_ten_token where token_type='defi')
group by asset,bus_type,level;

----按资产+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,bus_type,level)
select
    case when asset is null  or asset='' then 'total' else  asset end   as static_code,
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
    case when project is null  or project='' then 'total' else  project end  as static_code,
    count(1) as address_num,
    'platorm' as dimension_type,
    bus_type,
    level
from
    address_label_gp where (bus_type='balance' or bus_type='activity' or bus_type='volume') and category='grade'
group by project,bus_type,level;


----按行为+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,bus_type,level)
select
    case when trade_type is null or trade_type='' then 'total' else  trade_type end  as static_code,
    count(1) as address_num,
    'action' as dimension_type,
    bus_type,
    level
from
    address_label_gp where (bus_type='balance' or bus_type='activity' or bus_type='volume') and category='grade'
group by trade_type,bus_type,level;



------计算聚合级别数据（vol balance activity 聚合）
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
    JSON_BUILD_OBJECT(bus_type, json_agg(JSON_BUILD_OBJECT('level_name', level, 'level_address_num', address_num)))
from
    static_asset_level_data sald
group by
    static_code,
    dimension_type,
    bus_type;

------计算聚合项目数据（static_code聚合）
DROP TABLE if EXISTS  static_item_json;
create table static_item_json
(
    static_code  varchar(200) not null,
    dimension_type varchar(50)  null,---维度类型:token\project\action
    json_text text
);
insert into static_item_json(static_code,dimension_type,json_text)
select
    sald.static_code ,
    sald.dimension_type,
    JSON_BUILD_OBJECT('item_code',static_code, 'item_entity',json_agg(json_text::jsonb))
from
    static_asset_level_data_json sald
group by
    static_code,
    dimension_type;

------计算聚合类型数据（dimension_type聚合）token\project\action
DROP TABLE if EXISTS  static_type_json;
create table static_type_json
(
    dimension_type varchar(50)  null,---维度类型:token\project\action
    json_text text
);

insert into static_type_json
select
    sald.dimension_type,
    JSON_BUILD_OBJECT(dimension_type, json_agg(json_text::jsonb))
from
    static_item_json sald
group by
    dimension_type;

------计算聚合类型数据（dimension_type聚合）token\project\action
DROP TABLE if EXISTS  static_category_json;
create table static_category_json
(
    dimension_type varchar(50)  null,---维度类型:token\project\action
    json_text text
);

insert into static_category_json
select
    sald.dimension_type,
    JSON_BUILD_OBJECT(dimension_type, json_agg(json_text::jsonb))
from
    (select     case when dimension_type='defi' or dimension_type='nft' then 'asset' else  dimension_type end as
                    dimension_type,json_text from static_type_json ) sald
group by
    dimension_type;

update static_category_json set json_text =subquery.json_text from
 (select * from static_type_json) as subquery where static_category_json.dimension_type<>'defi'  and
    static_category_json.dimension_type = subquery.dimension_type;







