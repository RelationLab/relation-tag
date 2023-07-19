drop table if exists address_label_nft_transfer_volume_grade;
CREATE TABLE public.address_label_nft_transfer_volume_grade (
                                                                address varchar(512) NULL,
                                                                data numeric(250, 20) NULL,
                                                                wired_type varchar(100) NULL,
                                                                label_type varchar(512) NULL,
                                                                label_name varchar(1024) NULL,
                                                                updated_at timestamp(6) NULL,
                                                                "group" varchar(1) NULL,
                                                                "level" varchar(100) NULL,
                                                                category varchar(100) NULL,
                                                                trade_type varchar(100) NULL,
                                                                project varchar(100) NULL,
                                                                asset varchar(100) NULL,
                                                                bus_type varchar(100) NULL
);
truncate table public.address_label_nft_transfer_volume_grade;
vacuum address_label_nft_transfer_volume_grade;

insert into public.address_label_nft_transfer_volume_grade(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
select
    address,
    label_type,
    label_type || '_' || case
                             when volume >= 1
                                 and volume <= 2 then 'L1'
                             when volume >= 3
                                 and volume <= 6 then 'L2'
                             when volume >= 7
                                 and volume <= 20 then 'L3'
                             when volume >= 21
                                 and volume <= 100 then 'L4'
                             when volume >= 101
                                 and volume <= 200 then 'L5'
                             when volume >= 201 then 'L6'
        end as label_name,
    volume  as data,
    'NFT'  as wired_type,
    now() as updated_at,
    'v'  as "group",
    case
    when volume >= 1
    and volume <= 2 then 'L1'
    when volume >= 3
    and volume <= 6 then 'L2'
    when volume >= 7
    and volume <= 20 then 'L3'
    when volume >= 21
    and volume <= 100 then 'L4'
    when volume >= 101
    and volume <= 200 then 'L5'
    when volume >= 201 then 'L6' end      as level,
    'grade' as category,
    t.type as trade_type,
    '' as project,
    t.token_name as asset,
    'volume' as bus_type
    from
    (
        -- project(null)+nft+type
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name,
            sum(total_transfer_volume) as volume,
            recent_time_code
        from
            nft_transfer_holding a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and
                                       a2.type = 'Transfer'
                                   and
                                       a2.data_subject = 'volume_grade'
                                   and a2.label_type like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
                                   and (a2.project = '' or a2.project = 'ALL' )
                                   and  a1.recent_time_code = a2.recent_code
        group by
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name,
            recent_time_code
        union all
        -- project(null)+nft（ALL）+type
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name,
            sum(total_transfer_volume) as volume,
            recent_time_code
        from
            nft_transfer_holding a1
                inner join dim_project_token_type a2
                           on
                                       a2.token = 'ALL'
                                   and
                                       a2.type = 'Transfer'
                                   and
                                       a2.data_subject = 'volume_grade'
                                   and a2.label_type like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
                                   and (a2.project = '' or a2.project = 'ALL')
                                   and  a1.recent_time_code = a2.recent_code
        where a1.token in (select token_id from dim_project_token_type_rank dpttr)
        group by
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name,
            recent_time_code) t
    where
        volume >= 1 and address not in (select address from exclude_address);
insert into tag_result(table_name,batch_date)  SELECT 'address_label_nft_transfer_volume_grade' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;