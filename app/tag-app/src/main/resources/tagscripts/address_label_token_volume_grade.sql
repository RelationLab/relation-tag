drop table if exists address_label_token_volume_grade;
CREATE TABLE public.address_label_token_volume_grade (
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
truncate table public.address_label_token_volume_grade;
vacuum address_label_token_volume_grade;

insert into public.address_label_token_volume_grade(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
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
    when volume_usd >= 500000
    and volume_usd < 1000000 then 'L6'
    when volume_usd >= 1000000
    and volume_usd < 1000000000 then 'Million'
    when volume_usd >= 1000000000 then 'Billion' end  as level,
    'grade'  as category,
    'ALL' trade_type,
    '' as project,
    a2.token_name as asset,
    'volume' as bus_type
    from
    (
        select
            address,
            token,
            round(volume_usd,8) volume_usd,
            recent_time_code
        from
            token_volume_usd tbvutk
    )
        a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token and a1.recent_time_code= a2.recent_code
            and a2.label_type not like 'Uniswap_v3%'
    where
        a1.volume_usd >= 100
  and a2.data_subject = 'volume_grade' and address not in (select address from exclude_address);
insert into tag_result(table_name,batch_date)  SELECT 'address_label_token_volume_grade' as table_name,'${batchDate}'  as batch_date;
