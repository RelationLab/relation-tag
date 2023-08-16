drop table if exists address_label_crowd_nft_active_users;
CREATE TABLE public.address_label_crowd_nft_active_users
(
    address          varchar(512) NULL,
    data             numeric(250, 20) NULL,
    wired_type       varchar(20) NULL,
    label_type       varchar(512) NULL,
    label_name       varchar(1024) NULL,
    updated_at       timestamp(6) NULL,
    "group"          varchar(1) NULL,
    "level"          varchar(80) NULL,
    category         varchar(80) NULL,
    trade_type       varchar(80) NULL,
    project          varchar(80) NULL,
    asset            varchar(80) NULL,
    bus_type         varchar(20) NULL,
    recent_time_code varchar(30) NULL
) with (appendonly = 'true', compresstype = zstd, compresslevel = '5')
    DISTRIBUTED BY
(
    address
);
truncate table public.address_label_crowd_nft_active_users;
vacuum
address_label_crowd_nft_active_users;

insert into public.address_label_crowd_nft_active_users(address, label_type, label_name, data, wired_type, updated_at,
                                                        "group", level, category, trade_type, project, asset, bus_type)
select distinct a1.address,
                'crowd_nft_active_users' as label_type,
                'crowd_nft_active_users' as label_name,
                0                        as data,
                'CROWD'                  as wired_type,
                now()                    as updated_at,
                'g'                      as "group",
                'crowd_nft_active_users' as level,
                'other'                  as category,
                'ALL'                    as trade_type,
                'ALL'                    as project,
                'ALL'                    as asset,
                'CROWD'                  as bus_type
from address_label_nft_count_grade a1
where (label_name = 'no0cg6g' or label_name = 'no0cg6h' or label_name = 'no0cg6i')
--     (label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_Low'
--     or label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_Medium'
--     or label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_High')
  and address not in (select address from exclude_address);

drop table if exists address_label_crowd_active_users;
CREATE TABLE public.address_label_crowd_active_users
(
    address          varchar(512) NULL,
    data             numeric(250, 20) NULL,
    wired_type       varchar(20) NULL,
    label_type       varchar(512) NULL,
    label_name       varchar(1024) NULL,
    updated_at       timestamp(6) NULL,
    "group"          varchar(1) NULL,
    "level"          varchar(100) NULL,
    category         varchar(100) NULL,
    trade_type       varchar(100) NULL,
    project          varchar(100) NULL,
    asset            varchar(100) NULL,
    bus_type         varchar(20) NULL,
    recent_time_code varchar(30) NULL
) with (appendonly = 'true', compresstype = zstd, compresslevel = '5')
    DISTRIBUTED BY
(
    address
);
truncate table public.address_label_crowd_active_users;
vacuum
address_label_crowd_active_users;

insert into public.address_label_crowd_active_users(address, label_type, label_name, data, wired_type, updated_at,
                                                    "group", level, category, trade_type, project, asset, bus_type)
select distinct a1.address,
                'crowd_active_users' as label_type,
                'crowd_active_users' as label_name,
                0                    as data,
                'CROWD'              as wired_type,
                now()                as updated_at,
                'g'                  as "group",
                'crowd_active_users' as level,
                'other'              as category,
                'ALL'                   trade_type,
                'ALL'                as project,
                'ALL'                as asset,
                'CROWD'              as bus_type
from (select address
      from address_label_nft_count_grade
      where label_name = 'no0cg6i'
--           label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_High'
      union all
      select address
      from address_label_web3_type_count_grade
      where label_name = 'w0o2cg9i'
--           label_name = 'WEB3_ALL_NFTRecipient_ACTIVITY_High'
      union all
      select address
      from address_label_token_count_grade
      where label_name = 'cg2i'
--           label_name = 'ALL_ALL_ALL_ACTIVITY_High'
     ) a1
where address not in (select address from exclude_address);

drop table if exists address_label_crowd_elite;
CREATE TABLE public.address_label_crowd_elite
(
    address          varchar(512) NULL,
    data             numeric(250, 20) NULL,
    wired_type       varchar(20) NULL,
    label_type       varchar(512) NULL,
    label_name       varchar(1024) NULL,
    updated_at       timestamp(6) NULL,
    "group"          varchar(1) NULL,
    "level"          varchar(80) NULL,
    category         varchar(80) NULL,
    trade_type       varchar(80) NULL,
    project          varchar(80) NULL,
    asset            varchar(80) NULL,
    bus_type         varchar(20) NULL,
    recent_time_code varchar(30) NULL
) with (appendonly = 'true', compresstype = zstd, compresslevel = '5')
    DISTRIBUTED BY
(
    address
);
truncate table public.address_label_crowd_elite;
vacuum
address_label_crowd_elite;

insert into public.address_label_crowd_elite(address, label_type, label_name, data, wired_type, updated_at, "group",
                                             level, category, trade_type, project, asset, bus_type)
select distinct a1.address,
                'crowd_elite' as label_type,
                'crowd_elite' as label_name,
                0             as data,
                'CROWD'       as wired_type,
                now()         as updated_at,
                'g'           as "group",
                'crowd_elite'    level,
                'other'       as category,
                'ALL'            trade_type,
                'ALL'         as project,
                'ALL'         as asset,
                'CROWD'       as bus_type
from (select address
      from address_label_nft_volume_count_rank
      where label_name = 'no0ve'
--           label_name = 'ALL_ALL_ALL_NFT_VOLUME_ELITE_ELITE_NFT_TRADER'
      union all
      select address
      from address_label_token_volume_rank_all
      where label_name = 'vr1k'
--           label_name = 'ALL_ALL_ALL_VOLUME_RANK_ELITE'
     ) a1
where address not in (select address from exclude_address);

DROP TABLE if EXISTS address_label_gp_temp_${tableSuffix};
create table address_label_gp_temp_${tableSuffix}
(
    "owner"          varchar(256) NULL,
    address          varchar(512) NULL,
    "data"           numeric(250, 20) NULL,
    wired_type       varchar(100) NULL,
    label_type       varchar(512) NULL,
    label_name       varchar(1024) NULL,
    "source"         varchar(100) NULL,
    updated_at       timestamp(6) NULL,
    "group"          varchar(1) NULL,
    "level"          varchar(80) NULL,
    category         varchar(80) NULL,
    trade_type       varchar(80) NULL,
    project          varchar(80) NULL,
    asset            varchar(80) NULL,
    bus_type         varchar(100) NULL,
    id               int8,
    recent_time_code varchar(30) NULL
) with (appendonly = 'true', compresstype = zstd, compresslevel = '5')
    DISTRIBUTED BY
(
    address
);


truncate table address_label_gp_temp_${tableSuffix};
vacuum
address_label_gp_temp_${tableSuffix};

insert into public.address_label_gp_temp_${tableSuffix}(id, address, label_type, label_name, wired_type, data,
                                                        updated_at, owner, source, "group", level, category, trade_type,
                                                        project, asset, bus_type,
                                                        recent_time_code)
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_eth_count_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_project_type_count_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_project_type_volume_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_project_type_volume_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_project_type_count_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_project_type_volume_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_project_type_volume_count_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_project_type_volume_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_project_type_volume_top
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_balance_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_count_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_time_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_volume_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_balance_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_balance_top
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_time_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_time_top
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_volume_count_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_volume_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_volume_top
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_transfer_count_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_transfer_volume_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_transfer_volume_count_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_transfer_volume_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_transfer_volume_top
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_balance_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_count_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_time_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_volume_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_eth_balance_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_eth_volume_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_time_special
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_balance_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_balance_top
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_volume_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_usdt_balance_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_usdt_volume_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_web3_type_balance_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_web3_type_count_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_web3_type_balance_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_web3_type_balance_top
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_balance_provider
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_balance_staked
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_time_first_lp
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_time_first_stake
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_eth_time_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_eth_time_special
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_balance_grade_all
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_volume_grade_all
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_balance_rank_all
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_balance_top_all
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_token_volume_rank_all
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_univ3_balance_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_univ3_count_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_univ3_volume_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_univ3_balance_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_univ3_balance_top
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_univ3_volume_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_crowd_active_users
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_crowd_defi_active_users
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_crowd_defi_high_demander
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_crowd_elite
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_crowd_long_term_holder
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_crowd_nft_active_users
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_crowd_nft_high_demander
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_crowd_nft_whale
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_crowd_token_whale
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_crowd_web3_active_users
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_univ3_balance_provider
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_balance_usd_grade
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_balance_usd_rank
union all
select mod(to_number(address, '9999999999'), 50000),
       address,
       label_type,
       label_name,
       wired_type,
       round(data, 6)                                                          as data,
       updated_at,
       '-1'                                                                    as owner,
       'SYSTEM'                                                                as source,
       "group",
       level,
       category,
       trade_type,
       project,
       asset,
       bus_type,
       case when recent_time_code is null then 'ALL' else recent_time_code end as recent_time_code
from address_label_nft_balance_usd_top;

insert into tag_result(table_name, batch_date)
SELECT 'address_label_gp_${tableSuffix}' as table_name, ' ${batchDate}' as batch_date;



