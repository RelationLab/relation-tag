DROP TABLE if EXISTS  static_asset_level_data;
create table static_asset_level_data
(
    static_code  varchar(200) not null,
    address_num numeric(250, 20) NULL,
    dimension_type varchar(100)  null,---维度类型:asset\project\action
    wired_type varchar(100)  null,---维度类型:token\project\action
    bus_type varchar(100)  null,---业务类型:vol balance activity
    "level" varchar(100)  null----级别类型 L1\L2....
) distributed by (static_code,dimension_type,wired_type,bus_type,level);
truncate table static_asset_level_data;
vacuum static_asset_level_data;

----按资产+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,wired_type,bus_type,level)
select
    case when asset is null  or asset='' or asset='ALL' then 'total' else  asset end   as static_code,
    count(1) as address_num,
    'asset' as dimension_type,
    case when lower(wired_type)='defi' then 'token' else lower(wired_type) end as wired_type,
    bus_type,
    level
from
    address_label_gp where (bus_type='balance' or bus_type='activity' or bus_type='volume') and category='grade'
                       and asset in(select distinct token_name from static_top_ten_token) and wired_type<>'WEB3'
group by asset,wired_type,bus_type,level;

----按平台+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,wired_type,bus_type,level)
select
    case
        when project is null
            or project = '' then 'total'
        else project
        end as static_code,
    count(1) as address_num,
    'platform' as dimension_type,
    case
        when lower(wired_type)= 'defi' then 'token'
        else lower(wired_type)
        end as wired_type,
    bus_type,
    level
from
    (
        select
            address,
            data,
            wired_type,
            label_type,
            label_name,
            updated_at,
            "group",
            level,
            category,
            trade_type,
            asset,
            bus_type,
            case
                when wired_type = 'WEB3' then asset
                else project
                end as project
        from
            address_label_gp) T

where
    ((bus_type = 'balance'
        and wired_type = 'WEB3')
        or bus_type = 'activity'
        or (bus_type = 'volume'
            and wired_type <> 'WEB3'))
  and category = 'grade'
group by
    project,
    wired_type,
    bus_type,
    level;

----按行为+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,wired_type,bus_type,level)
select
    case when trade_type is null or trade_type='' or trade_type='ALL' then 'total' else  trade_type end  as static_code,
    count(1) as address_num,
    'action' as dimension_type,
    case when lower(wired_type)='defi' then 'token' else lower(wired_type) end as wired_type,
    bus_type,
    level
from
    (
        select
            address,
            data,
            wired_type,
            label_type,
            label_name,
            updated_at,
            "group",
            level,
            category,
            trade_type,
            asset,
            bus_type,
            case
                when wired_type = 'WEB3' then asset
                else project
                end as project
        from
            address_label_gp) T where ((bus_type='balance' and wired_type = 'WEB3') or bus_type='activity' or (bus_type = 'volume'
                       and wired_type <> 'WEB3')) and category='grade'
group by trade_type,wired_type,bus_type,level;

------计算聚合级别数据（vol balance activity 聚合）
DROP TABLE if EXISTS  static_asset_level_data_json;
create table static_asset_level_data_json
(
    static_code  varchar(200) not null,
    dimension_type varchar(100)  null,---维度类型:asset\project\action
    wired_type varchar(100)  null,---维度类型:token\nft\web3
    bus_type varchar(100)  null,---业务类型:vol balance activity
    json_text text
);
insert
into
    static_asset_level_data_json(static_code,
                                 dimension_type,
                                 wired_type,
                                 bus_type,
                                 json_text)
select
    sald.static_code ,
    sald.dimension_type ,
    sald.wired_type ,
    sald.bus_type,
    '"'|| bus_type||'":'||json_agg(JSON_BUILD_OBJECT('level_name', level, 'level_address_num', address_num))
from
    static_asset_level_data sald
group by
    static_code,
    dimension_type,
    wired_type,
    bus_type;

------计算聚合项目数据（static_code聚合）
DROP TABLE if EXISTS  static_item_json;
create table static_item_json
(
    static_code  varchar(200) not null,
    dimension_type varchar(100)  null,---维度类型:asset\project\action
    wired_type varchar(100)  null,
    json_text jsonb
);
insert into static_item_json(static_code,dimension_type,wired_type,json_text)
select
    sald.static_code ,
    sald.dimension_type,
    sald.wired_type,
    JSON_BUILD_OBJECT('item_code',static_code, 'item_entity',('{'||string_agg(json_text,',')||'}')::jsonb)::jsonb
from
    static_asset_level_data_json sald
group by
    static_code,
    dimension_type,
    wired_type;

------计算聚合类型数据（dimension_type聚合）token\project\action
DROP TABLE if EXISTS  static_type_json;
create table static_type_json
(
    dimension_type varchar(100)  null,---维度类型:asset\project\action
    wired_type varchar(100)  null,---维度类型:token\nft\web3
    json_text text
);

insert into static_type_json
select
    sald.dimension_type,
    sald.wired_type,

    '"'||wired_type||'":'||(json_agg (json_text))
from
    static_item_json sald
group by
    dimension_type,wired_type;

------计算聚合类型数据（dimension_type聚合）token\project\action
DROP TABLE if EXISTS  static_category_json;
create table static_category_json
(
    dimension_type varchar(100)  null,---维度类型:token\project\action
    json_text text
);

insert into static_category_json
select
    sald.dimension_type,
    '"'||dimension_type||'":'||('{'||string_agg(json_text,',')||'}')::jsonb
from
    static_type_json sald
group by
    dimension_type;
insert into tag_result(table_name,batch_date)  SELECT 'static_asset_level_data' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
