drop table if exists address_label_nft_count_grade;
CREATE TABLE public.address_label_nft_count_grade
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
    distributed by
(
    address,
    label_name,
    recent_time_code
);
truncate table public.address_label_nft_count_grade;
vacuum
address_label_nft_count_grade;

insert into public.address_label_nft_count_grade(address, label_type, label_name, data, wired_type, updated_at, "group",
                                                 level, category, trade_type, project, asset, bus_type,
                                                 recent_time_code)
select address,
       label_type,
       label_type || case
                         when sum_count >= 1
                             and sum_count < 10 then '6a'
                         when sum_count >= 10
                             and sum_count < 40 then '6b'
                         when sum_count >= 40
                             and sum_count < 80 then '6c'
                         when sum_count >= 80
                             and sum_count < 120 then '6d'
                         when sum_count >= 120
                             and sum_count < 160 then '6e'
                         when sum_count >= 160
                             and sum_count < 200 then '6f'
                         when sum_count >= 200
                             and sum_count < 400 then '6g'
                         when sum_count >= 400
                             and sum_count < 619 then '6h'
                         when sum_count >= 619 then '6i'
           end      as label_name,
       sum_count    as data,
       'NFT'        as wired_type,
       now()        as updated_at,
       'c'          as "group",
       case
           when sum_count >= 1
               and sum_count < 10 then 'L1'
           when sum_count >= 10
               and sum_count < 40 then 'L2'
           when sum_count >= 40
               and sum_count < 80 then 'L3'
           when sum_count >= 80
               and sum_count < 120 then 'L4'
           when sum_count >= 120
               and sum_count < 160 then 'L5'
           when sum_count >= 160
               and sum_count < 200 then 'L6'
           when sum_count >= 200
               and sum_count < 400 then 'Low'
           when sum_count >= 400
               and sum_count < 619 then 'Medium'
           when sum_count >= 619 then 'High'
           end      as level,
       'grade'      as category,
       t.type       as trade_type,
       ''           as project,
       t.token_name as asset,
       'activity'   as bus_type,
       recent_time_code
from (
         -- project(null)+nft+type
         select a1.address,
                a2.label_type,
                a2.type,
                a2.project_name,
                a2.token_name,
                sum(transfer_count) as sum_count,
                recent_time_code
         from nft_volume_count_temp a1
                  inner join dim_project_token_type_temp a2
                             on
                                         a1.token = a2.token
                                     and a2.project = ''
                                     and a1.type = a2.type
                                     and a2.type != 'Transfer'
                                   and  a1.recent_time_code = a2.recent_code
		and
                                a2.data_subject = 'count'
	and a2.wired_type='NFT'
         where a1.token in (select token_id from dim_project_token_type_rank_temp dpttr)
         group by
             a1.address,
             a2.label_type,
             a2.type,
             a2.project_name,
             a2.token_name,
             recent_time_code
--             project(null)+nft（ALL）+type
         union all
         select
             a1.address, a2.label_type, a2.type, a2.project_name, a2.token_name, sum (transfer_count) as sum_count, recent_time_code
         from
             nft_volume_count_temp a1
             inner join dim_project_token_type_temp a2
         on
             a2.token = 'ALL'
             and a2.project = ''
             and a1.type = a2.type
             and a2.type != 'Transfer'
             and a2.data_subject = 'count'
            and a2.wired_type='NFT'
             and a1.recent_time_code = a2.recent_code
         where a1.token in (select token_id from dim_project_token_type_rank_temp dpttr)
         group by
             a1.address,
             a2.label_type,
             a2.type,
             a2.project_name,
             a2.token_name,
             recent_time_code) t
where sum_count >= 1
  and address not in (select address from exclude_address);
insert into tag_result(table_name, batch_date)
SELECT 'address_label_nft_count_grade' as table_name, '${batchDate}' as batch_date;
