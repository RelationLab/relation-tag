drop table if exists address_label_nft_volume_top;
CREATE TABLE public.address_label_nft_volume_top
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
    distributed by
(
    address,
    label_name,
    recent_time_code
);
truncate table public.address_label_nft_volume_top;
vacuum
address_label_nft_volume_top;

insert into public.address_label_nft_volume_top(address, label_type, label_name, data, wired_type, updated_at, "group",
                                                level, category, trade_type, project, asset, bus_type, recent_time_code)
select address,
       label_type,
       label_type || '5k' as label_name,
       rn                 as data,
       'NFT'              as wired_type,
       now()              as updated_at,
       'v'                as "group",
       'TOP'              as level,
       'top'              as category,
       t.type             as trade_type,
       ''                 as project,
       t.token_name       as asset,
       'volume'           as bus_type,
       recent_time_code
from (select s1.address,
             dptt.label_type   as label_type,
             dptt.type         as type,
             dptt.project_name as project_name,
             dptt.token_name   as token_name,
             rn,
             recent_time_code
      from (select a1.address,
                   seq_flag,
                   recent_time_code,
                   type,
                   -- 分组字段很关键
                   row_number() over( partition by seq_flag,recent_time_code,type
		order by
			transfer_volume desc,
			address asc) as rn
            from (select address,
                         seq_flag,
                         a2.type,
                         sum(transfer_volume) as transfer_volume,
                         recent_time_code
                  from (
                           -- project(null)+nft+type(null)
                           select address,
                                  token,
                                  '' as type,
                                  transfer_volume,
                                  recent_time_code
                           from nft_volume_count_temp
                           where transfer_volume >= 1
                             and address not in (select address from exclude_address)
                             and token in (select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')
                           union all
                           -- project(null)+nft(ALL)+type(null)
                           select address,
                                  'ALL' as token,
                                  ''    as type,
                                  transfer_volume,
                                  recent_time_code
                           from nft_volume_count_temp
                           where transfer_volume >= 1
                             and address not in (select address from exclude_address)
                             and token in (select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')
                           union all
                           -- project(null)+nft+type
                           select address,
                                  token,
                                  type,
                                  transfer_volume,
                                  recent_time_code
                           from nft_volume_count_temp
                           where transfer_volume >= 1
                             and address not in (select address from exclude_address)
                             and token in (select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')
                           union all
                           -- project(null)+nft+type(ALL)
                           select address,
                                  token,
                                  'ALL' as type,
                                  transfer_volume,
                                  recent_time_code
                           from nft_volume_count_temp
                           where transfer_volume >= 1
                             and address not in (select address from exclude_address)
                             and token in (select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')
                           union all
                           -- project(null)+nft（ALL）+type
                           select address,
                                  'ALL' as token,
                                  type,
                                  transfer_volume,
                                  recent_time_code
                           from nft_volume_count_temp
                           where transfer_volume >= 1
                             and address not in (select address from exclude_address)
                             and token in (select address from nft_sync_address_temp  where nft_sync_address_temp.type <> 'ERC1155')) tatola
                           inner join dim_project_token_type_temp a2
                                      on
                                                  tatola.token = a2.token
                                              and tatola.type = a2.type
                                              and a2.data_subject = 'volume_top'
                                            and a2.wired_type='NFT'
                                              and a2.recent_code = tatola.recent_time_code
                                                   and a2.project = ''
                  group by
                      address,
                      seq_flag,
                      a2.type,
                      recent_time_code) a1) s1
               inner join dim_project_token_type_temp dptt on (dptt.seq_flag = s1.seq_flag
          and dptt.type = s1.type
          and dptt.data_subject = 'volume_top'
         and dptt.wired_type='NFT'
                and dptt.project = '' and dptt.recent_code = s1.recent_time_code)
      where s1.rn <= 100) t;
insert into tag_result(table_name, batch_date)
SELECT 'address_label_nft_volume_top' as table_name, '${batchDate}' as batch_date;
