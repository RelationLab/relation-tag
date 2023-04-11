drop table if exists address_label_nft_count_grade;
CREATE TABLE public.address_label_nft_count_grade (
                                                      address varchar(512) NULL,
                                                      data numeric(250, 20) NULL,
                                                      wired_type varchar(20) NULL,
                                                      label_type varchar(512) NULL,
                                                      label_name varchar(1024) NULL,
                                                      updated_at timestamp(6) NULL,
    "group" varchar(1) NULL,
    "level" varchar(80) NULL,
    category varchar(80) NULL,
    trade_type varchar(80) NULL,
    project varchar(80) NULL,
    asset varchar(80) NULL,
                                                      bus_type varchar(20) NULL
);
truncate table public.address_label_nft_count_grade;
vacuum address_label_nft_count_grade;

insert into public.address_label_nft_count_grade(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
 select
    address,
    label_type,
    label_type || '_' || case
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
        end as label_name,
    sum_count  as data,
    'NFT'  as wired_type,
    now() as updated_at,
    'c'  as "group",
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
end   as level,
    'grade' as category,
    t.type as trade_type,
    t.project_name as project,
    t.token_name as asset,
    'activity' as bus_type
    from
    (
        -- project(null)+nft+type
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name,
            sum(transfer_count) as sum_count
        from
            nft_volume_count a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.project = ''
                                   and a1.type = a2.type
                                   and a2.type != 'Transfer' and a2.type != 'Buy'  and a2.type != 'Sale'
		and
                                a2.data_subject = 'count'
		and a2.label_type like '%NFT%'
		and a2.label_type not like '%WEB3%'
        where a1.token in (select token_id from dim_project_token_type_rank dpttr)
        group by
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name
--             project(null)+nft（ALL）+type
        union all
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name,
            sum(transfer_count) as sum_count
        from
            nft_volume_count a1
            inner join dim_project_token_type a2
        on
            a2.token = 'ALL'
            and a2.project = ''
            and a1.type = a2.type
            and a2.type != 'Transfer' and a2.type != 'Buy'  and a2.type != 'Sale'
            and a2.data_subject = 'count'
            and a2.label_type like '%NFT%'
            and a2.label_type not like '%WEB3%'
            where a1.token in (select token_id from dim_project_token_type_rank dpttr)
        group by
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name
        ) t
    where
        sum_count >= 1 and address <>'0x000000000000000000000000000000000000dead';
