drop table if exists address_label_nft_balance_grade;
CREATE TABLE public.address_label_nft_balance_grade
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
truncate table public.address_label_nft_balance_grade;
vacuum
address_label_nft_balance_grade;

insert into public.address_label_nft_balance_grade(address, label_type, label_name, data, wired_type, updated_at,
                                                   "group", level, category, trade_type, project, asset, bus_type)
select address
        ,
       label_type
        ,
       label_type || case
                         when balance = 1 then '4a'
                         when balance >= 2
                             and balance < 4 then '4b'
                         when balance >= 4
                             and balance < 11 then '4c'
                         when balance >= 11
                             and balance < 51 then '4d'
                         when balance >= 51
                             and balance < 101 then '4e'
                         when balance >= 101 then '4f'
           end                               as label_name,
       balance                               as data,
       'NFT'                                 as wired_type,
       now()                                 as updated_at,
       'b'                                   as "group",
       case
           when balance = 1 then 'L1'
           when balance >= 2
               and balance < 4 then 'L2'
           when balance >= 4
               and balance < 11 then 'L3'
           when balance >= 11
               and balance < 51 then 'L4'
           when balance >= 51
               and balance < 101 then 'L5'
           when balance >= 101 then 'L6' end as level,
       'grade'                               as category,
       t.type                                as trade_type,
       ''                                    as project,
       t.token_name                          as asset,
       'balance'                             as bus_type
from (
         -- project(null)+nft+type(null)
         select a1.address,
                a2.label_type,
                a2.token_name,
                a2.project_name,
                a2.type,
                sum(balance) as balance
         from nft_holding_temp a1
                  inner join dim_project_token_type_temp a2
                             on a1.token = a2.token and a2.project = '' and (a2.type = '' OR a2.type = 'ALL') and
                                a2.data_subject = 'balance_grade' and a2.wired_type='NFT'
         where a1.recent_time_code = 'ALL'
         group by a1.address,
                  a2.label_type,
                  a2.token_name,
                  a2.project_name,
                  a2.type
         union all
         -- project(null)+nft(ALL)+type(null)
         select a1.address,
                a2.label_type,
                a2.token_name,
                a2.project_name,
                a2.type,
                sum(balance) as balance
         from nft_holding_temp a1
                  inner join dim_project_token_type_temp a2
                             on a2.token = 'ALL' and a2.project = '' and (a2.type = '' OR a2.type = 'ALL') and
                                a2.data_subject = 'balance_grade' and a2.wired_type='NFT'
         where a1.recent_time_code = 'ALL'
         group by a1.address,
                  a2.label_type,
                  a2.token_name,
                  a2.project_name,
                  a2.type) t
where balance >= 1
  and address not in (select address from exclude_address);
insert into tag_result(table_name, batch_date)
SELECT 'address_label_nft_balance_grade' as table_name, '${batchDate}' as batch_date;
