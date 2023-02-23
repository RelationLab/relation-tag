drop table if exists address_label_token_volume_grade_all;
CREATE TABLE public.address_label_token_volume_grade_all (

                                                             address varchar(512) NULL,
                                                             data numeric(250, 20) NULL,
                                                             wired_type varchar(20) NULL,
                                                             label_type varchar(512) NULL,
                                                             label_name varchar(1024) NULL,
                                                             updated_at timestamp(6) NULL,
                                                             "group" varchar(1) NULL,
                                                             "level" varchar(20) NULL,
                                                             category varchar(20) NULL,
                                                             trade_type varchar(30) NULL,
                                                             project varchar(50) NULL,
                                                             asset varchar(50) NULL
);
truncate table public.address_label_token_volume_grade_all;
insert into public.address_label_token_volume_grade_all(address,label_type,label_name,data,wired_type,updated_at,group,level,category,trade_type,project,asset)
    select
    a1.address,
    a2.label_type,
    a2.label_type || '_' || case
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
                                when volume_usd >= 500000
                                    and volume_usd < 1000000 then 'L6'
                                when volume_usd >= 1000000
                                    and volume_usd < 1000000000 then 'Million'
                                when volume_usd >= 1000000000 then 'Billion'
        end as label_name,
    volume_usd  as data,
    'DEFI'  as wired_type,
    now() as updated_at,
    'v'  as group,
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
    when volume_usd >= 500000
    and volume_usd < 1000000 then 'L6'
    when volume_usd >= 1000000
    and volume_usd < 1000000000 then 'Million'
    when volume_usd >= 1000000000 then 'Billion' end  as level,
    'grade'  as category,
    'all' trade_type,
    'all' as project,
    'all' as asset
    from
    (
        select
            address,
            'ALL' as token ,
            volume_usd as volume_usd
        from
            total_volume_usd tbvu
    )
        a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
    where
        a1.volume_usd >= 100
  and a2.data_subject = 'volume_grade'
  and a2.token_type = 'token' and address <>'0x000000000000000000000000000000000000dead';