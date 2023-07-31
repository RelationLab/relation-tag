drop table if exists address_label_token_project_type_volume_grade;
CREATE TABLE public.address_label_token_project_type_volume_grade (
                                                                      address varchar(512) NULL,
                                                                      data numeric(250, 20) NULL,
                                                                      wired_type varchar(20) NULL,
                                                                      label_type varchar(512) NULL,
                                                                      label_name varchar(1024) NULL,
                                                                      updated_at timestamp(6) NULL,
                                                                      "group" varchar(1) NULL,
                                                                      "level" varchar(100) NULL,
                                                                      category varchar(100) NULL,
                                                                      trade_type varchar(100) NULL,
                                                                      project varchar(100) NULL,
                                                                      asset varchar(100) NULL,
                                                                      bus_type varchar(20) NULL,
                                                                      recent_time_code varchar(30) NULL
);
truncate table public.address_label_token_project_type_volume_grade;
vacuum address_label_token_project_type_volume_grade;

insert into public.address_label_token_project_type_volume_grade(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
    select
    address,
    label_type,
    label_type || '_' || case
                             when total_transfer_volume_usd >= 100
                                 and total_transfer_volume_usd < 1000 then 'L1'
                             when total_transfer_volume_usd >= 1000
                                 and total_transfer_volume_usd < 10000 then 'L2'
                             when total_transfer_volume_usd >= 10000
                                 and total_transfer_volume_usd < 50000 then 'L3'
                             when total_transfer_volume_usd >= 50000
                                 and total_transfer_volume_usd < 100000 then 'L4'
                             when total_transfer_volume_usd >= 100000
                                 and total_transfer_volume_usd < 500000 then 'L5'
                             when total_transfer_volume_usd >= 500000
                                 and total_transfer_volume_usd < 1000000 then 'L6'
                             when total_transfer_volume_usd >= 1000000
                                 and total_transfer_volume_usd < 1000000000 then 'Million'
                             when total_transfer_volume_usd >= 1000000000 then 'Billion'
        end as label_name,
    total_transfer_volume_usd  as data,
    'DEFI'  as wired_type,
    now() as updated_at,
    'v'  as "group",
    case
    when total_transfer_volume_usd >= 100
    and total_transfer_volume_usd < 1000 then 'L1'
    when total_transfer_volume_usd >= 1000
    and total_transfer_volume_usd < 10000 then 'L2'
    when total_transfer_volume_usd >= 10000
    and total_transfer_volume_usd < 50000 then 'L3'
    when total_transfer_volume_usd >= 50000
    and total_transfer_volume_usd < 100000 then 'L4'
    when total_transfer_volume_usd >= 100000
    and total_transfer_volume_usd < 500000 then 'L5'
    when total_transfer_volume_usd >= 500000
    and total_transfer_volume_usd < 1000000 then 'L6'
    when total_transfer_volume_usd >= 1000000
    and total_transfer_volume_usd < 1000000000 then 'Million'
    when total_transfer_volume_usd >= 1000000000 then 'Billion' end   as level,
    'grade' as category,
    t.type as trade_type,
    t.project_name as project,
    t.token_name as asset,
    'volume' as bus_type
    from
    (
        -- project-token-type
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary_temp a1
                inner join dim_project_token_type_temp a2
                           on
                                       a1.token = a2.token
                                   and a1.project = a2.project
                                   and a1.type = a2.type
                                   and a2.data_subject = 'volume_grade'
                                   and a2.label_type not like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
                                   and a1.recent_time_code = a2.recent_code
        where a1.token in (select distinct token from dim_project_token_type_temp)
        group by
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name
            -- project(ALL)-token-type
        union all
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name,
            sum(round(total_transfer_volume_usd,8)) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary_temp a1
                inner join dim_project_token_type_temp a2
                           on
                                       a1.token = a2.token
                                   and a2.project = 'ALL'
                                   and a1.type = a2.type
                                   and a2.data_subject = 'volume_grade'
                                   and a2.label_type not like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
                                   and a1.recent_time_code = a2.recent_code
        where a1.token in (select distinct token from dim_project_token_type_temp)
        group by
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name
    ) t where
        total_transfer_volume_usd >= 100 and address not in (select address from exclude_address);
insert into tag_result(table_name,batch_date)  SELECT 'address_label_token_project_type_volume_grade' as table_name,'${batchDate}'  as batch_date;
