DROP TABLE if EXISTS  static_asset_level_data;
create table static_asset_level_data
(
    static_code  varchar(200) not null,
    address_num numeric(250, 20) NULL,
    dimension_type varchar(100)  null,---维度类型:asset\project\action
    wired_type varchar(100)  null,---维度类型:token\project\action
    bus_type varchar(100)  null,---业务类型:vol balance activity
    "level" varchar(100)  null,----级别类型 L1\L2....
    rownumber numeric(250, 20) NULL
) distributed by (static_code,dimension_type,wired_type,bus_type,level);
truncate table static_asset_level_data;
vacuum static_asset_level_data;

----按资产+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,wired_type,bus_type,level,rownumber)
select
    case
        when asset is null
            or asset = ''
            or asset = 'ALL' then 'total'
        else asset
        end as static_code,
    count(1) as address_num,
    'asset' as dimension_type,
    case
        when lower(wired_type)= 'defi' then 'token'
        else lower(wired_type)
        end as wired_type,
    alg.bus_type,
    level,
    sttt.rownumber
from
    (
        select
            case
                when asset = 'undefined' then 'ALL'
                else asset
                end asset,
            wired_type,
            bus_type,
            level,
            category,
            trade_type
        from
            address_label_gp
        where
            (trade_type = 'ALL' and project = '' and wired_type='DEFI')
           or (trade_type = '' and project is null and wired_type='NFT' and bus_type = 'balance' )
           or (trade_type = 'ALL' and project='ALL' and wired_type='NFT' and (bus_type = 'volume' or bus_type = 'activity'))  ) alg
        inner join static_top_ten_token sttt on
        (alg.asset = sttt.token_name
            and alg.bus_type = sttt.bus_type
            and lower(alg.wired_type)= sttt.token_type )
where
    (alg.bus_type = 'balance'
        or alg.bus_type = 'activity'
        or alg.bus_type = 'volume')
  and category = 'grade'
  and wired_type <> 'WEB3'
group by
    asset,
    wired_type,
    alg.bus_type,
    level,
    sttt.rownumber;

----按平台+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,wired_type,bus_type,level,rownumber)
select
    case
        when project = 'ALL' then 'total'
        else project
        end as static_code,
    count(1) as address_num,
    'platform' as dimension_type,
    case
        when lower(wired_type)= 'defi' then 'token'
        else lower(wired_type)
        end as wired_type,
    alg.bus_type,
    level,
    sttt.rownumber
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
            address_label_gp WHERE category = 'grade' and ((
                        (project is not null or project <> '') and ((trade_type='ALL' and asset='ALL') or project='Frax' or project='RocketPool' or project='Lido' )
                        and  (bus_type = 'activity' or bus_type = 'volume') and wired_type <> 'WEB3')
                        or ((bus_type = 'balance' or bus_type = 'activity' ) and wired_type = 'WEB3' and (trade_type='NFT Recipient' OR trade_type='ALL')))) alg
        inner join static_top_ten_platform sttt
            on(alg.project=sttt.token_name and alg.bus_type=sttt.bus_type and lower(alg.wired_type)=sttt.token_type )
group by
    project,
    wired_type,
    alg.bus_type,
    level,sttt.rownumber;

----按行为+级别
insert into static_asset_level_data(static_code,address_num,dimension_type,wired_type,bus_type,level,rownumber)
select
    case when  trade_type='ALL' then 'total' else  trade_type end  as static_code,
    count(1) as address_num,
    'action' as dimension_type,
    case when lower(wired_type)='defi' then 'token' else lower(wired_type) end as wired_type,
    alg.bus_type,
    level,
    sttt.rownumber
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
            address_label_gp where
                category='grade' and
                project in('Lido','Frax','RocketPool','ALL' ) and asset='ALL'   and (bus_type='activity'  or (bus_type = 'volume' and wired_type <> 'WEB3') )))  alg
        inner join static_top_ten_action sttt
       on(alg.trade_type=sttt.token_name and alg.bus_type=sttt.bus_type and lower(alg.wired_type)=sttt.token_type )
group by trade_type,wired_type,alg.bus_type,level,
         sttt.rownumber;

------计算聚合级别数据（vol balance activity 聚合）
DROP TABLE if EXISTS  static_asset_level_data_json;
create table static_asset_level_data_json
(
    static_code  varchar(200) not null,
    dimension_type varchar(100)  null,---维度类型:asset\project\action
    wired_type varchar(100)  null,---维度类型:token\nft\web3
    bus_type varchar(100)  null,---业务类型:vol balance activity
    json_text text,
    rownumber numeric(250, 20) NULL
);
insert
into
    static_asset_level_data_json(static_code,
                                 dimension_type,
                                 wired_type,
                                 bus_type,
                                 json_text,rownumber)
select
    sald.static_code ,
    sald.dimension_type ,
    sald.wired_type ,
    sald.bus_type,
    '"'|| bus_type||'":'||json_agg(JSON_BUILD_OBJECT('level_name', level, 'level_address_num', address_num)),
    sald.rownumber
from
    static_asset_level_data sald
group by
    static_code,
    dimension_type,
    wired_type,
    bus_type,
    sald.rownumber;

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
