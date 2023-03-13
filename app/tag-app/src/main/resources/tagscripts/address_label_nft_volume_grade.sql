drop table if exists address_label_nft_volume_grade;
CREATE TABLE public.address_label_nft_volume_grade (
                                                       address varchar(512) NULL,
                                                       data numeric(250, 20) NULL,
                                                       wired_type varchar(20) NULL,
                                                       label_type varchar(512) NULL,
                                                       label_name varchar(1024) NULL,
                                                       updated_at timestamp(6) NULL,
    "group" varchar(1) NULL,
    "level" varchar(50) NULL,
    category varchar(50) NULL,
    trade_type varchar(50) NULL,
    project varchar(50) NULL,
    asset varchar(50) NULL
);
truncate table public.address_label_nft_volume_grade;
insert into public.address_label_nft_volume_grade(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset)
select
    address,
    label_type,
    label_type || '_' || case
                             when volume_usd >= 1
                                 and volume_usd < 3 then 'L1'
                             when volume_usd >= 3
                                 and volume_usd < 7 then 'L2'
                             when volume_usd >= 7
                                 and volume_usd < 21 then 'L3'
                             when volume_usd >= 21
                                 and volume_usd < 101 then 'L4'
                             when volume_usd >= 101
                                 and volume_usd < 201 then 'L5'
                             when volume_usd >= 201 then 'L6'
        end as label_name,
    volume_usd  as data,
    'NFT'  as wired_type,
    now() as updated_at,
    'v'  as "group",
    case
    when volume_usd >= 1
    and volume_usd < 3 then 'L1'
    when volume_usd >= 3
    and volume_usd < 7 then 'L2'
    when volume_usd >= 7
    and volume_usd < 21 then 'L3'
    when volume_usd >= 21
    and volume_usd < 101 then 'L4'
    when volume_usd >= 101
    and volume_usd < 201 then 'L5'
    when volume_usd >= 201 then 'L6' end     as level,
    'grade' as category,
    t.type as trade_type,
    t.project_name as project,
    t.token_name as asset
    from
    (
        -- project(null)+nft+type
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name,
            sum(transfer_volume) as volume_usd
        from
            nft_volume_count a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and (a2.project = ''
                                   or a2.project = 'ALL')
                                   and a1.type = a2.type
                                   and a2.type != 'Transfer'
		and
                                a2.data_subject = 'volume_grade'
        group by
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name
        union all
        -- project(null)+nft（ALL）+type
        select
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name,
            sum(transfer_volume) as volume_usd
        from
            nft_volume_count a1
            inner join dim_project_token_type a2
        on
            a2.token = 'ALL'
            and (a2.project = ''
            or a2.project = 'ALL')
            and a1.type = a2.type
            and a2.type != 'Transfer'
            and
            a2.data_subject = 'volume_grade'
            and a2.label_type like '%NFT%'
            and a2.label_type not like '%WEB3%'
        where a1.token in (select token_id from dim_project_token_type_rank dpttr)
        group by
            a1.address,
            a2.label_type,
            a2.type,
            a2.project_name ,
            a2.token_name) t
    where
        volume_usd >= 1 and address <>'0x000000000000000000000000000000000000dead';