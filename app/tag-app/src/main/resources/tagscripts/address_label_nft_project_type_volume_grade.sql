drop table if exists address_label_nft_project_type_volume_grade;
CREATE TABLE public.address_label_nft_project_type_volume_grade (
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
                                                                    bus_type varchar(20) NULL
);
truncate table public.address_label_nft_project_type_volume_grade;
vacuum address_label_nft_project_type_volume_grade;

insert into public.address_label_nft_project_type_volume_grade(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
select
    address,
    label_type,
    label_type||'_'||case
                         when volume_usd >= 100
                             and volume_usd < 1000 then 'L1'
                         when volume_usd >= 1000
                             and volume_usd < 10000 then 'L2'
                         when volume_usd >= 10000
                             and volume_usd < 50000 then 'L3'
                         when volume_usd >= 50000
                             and volume_usd < 100000 then 'L4'
                         when volume_usd >= 100000
                             and volume_usd < 500000 then 'L5'
                         when volume_usd >= 500000 then 'L6'
        end as label_name,
    volume_usd  as data,
    'NFT'  as wired_type,
    now() as updated_at,
    'v'  as "group",
    case
    when volume_usd >= 100
    and volume_usd < 1000 then 'L1'
    when volume_usd >= 1000
    and volume_usd < 10000 then 'L2'
    when volume_usd >= 10000
    and volume_usd < 50000 then 'L3'
    when volume_usd >= 50000
    and volume_usd < 100000 then 'L4'
    when volume_usd >= 100000
    and volume_usd < 500000 then 'L5'
    when volume_usd >= 500000 then 'L6' end   as level,
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
            sum( round(volume_usd,3)) as volume_usd
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
            on a1.token=a2.token and a1.platform_group=a2.project and a1.type=a2.type and a2.data_subject = 'volume_grade'
        and a1.token in (select token_id from dim_project_token_type_rank dpttr)
        group by
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name
    -- project-token(ALL)-type
        union all
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name,
            sum( round(volume_usd,3)) as volume_usd
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
        on a2.token='ALL' and a1.platform_group=a2.project and a1.type=a2.type and a2.data_subject = 'volume_grade'
        where a1.token in (select token_id from dim_project_token_type_rank dpttr)
        group by
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name
        -- project(ALL)-token(ALL)-type
        union all
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name,
            sum( round(volume_usd,3)) as volume_usd
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
                                                          on a2.token='ALL' and a2.project='ALL' and a1.type=a2.type and a2.data_subject = 'volume_grade'
        where a1.token in (select token_id from dim_project_token_type_rank dpttr)
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
            sum( round(volume_usd,3)) as volume_usd
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
                                                          on a2.token=a1.token and a2.project='ALL' and a1.type=a2.type and a2.data_subject = 'volume_grade'
        where a1.token in (select token_id from dim_project_token_type_rank dpttr)
        group by
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name
    ) t where volume_usd >= 100 and address not in (select address from exclude_address) 		and label_type not like '%_DEX_%' ;
insert into tag_result(table_name,batch_date)  SELECT 'address_label_nft_project_type_volume_grade' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
