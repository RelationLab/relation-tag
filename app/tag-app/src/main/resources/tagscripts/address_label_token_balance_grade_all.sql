drop table if exists address_label_token_balance_grade_all;
CREATE TABLE public.address_label_token_balance_grade_all (

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
                                                              asset varchar(80) NULL
);
truncate table public.address_label_token_balance_grade_all;
insert into public.address_label_token_balance_grade_all(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset)
    select
    address,
    a2.label_type,
    a2.label_type || '_' || case
                                when balance_usd >= 100
                                    and balance_usd < 1000 then 'L1'
                                when balance_usd >= 1000
                                    and balance_usd < 10000 then 'L2'
                                when balance_usd >= 10000
                                    and balance_usd < 50000 then 'L3'
                                when balance_usd >= 50000
                                    and balance_usd < 100000 then 'L4'
                                when balance_usd >= 100000
                                    and balance_usd < 500000 then 'L5'
                                when balance_usd >= 500000
                                    and balance_usd < 1000000 then 'L6'
                                when balance_usd >= 1000000
                                    and balance_usd < 1000000000 then 'Millionaire'
                                when balance_usd >= 1000000000 then 'Billionaire'
        end as label_name,
    balance_usd  as data,
    'DEFI'  as wired_type,
    now() as updated_at,
    'b'  as "group",
    case
    when balance_usd >= 100
    and balance_usd < 1000 then 'L1'
    when balance_usd >= 1000
    and balance_usd < 10000 then 'L2'
    when balance_usd >= 10000
    and balance_usd < 50000 then 'L3'
    when balance_usd >= 50000
    and balance_usd < 100000 then 'L4'
    when balance_usd >= 100000
    and balance_usd < 500000 then 'L5'
    when balance_usd >= 500000
    and balance_usd < 1000000 then 'L6'
    when balance_usd >= 1000000
    and balance_usd < 1000000000 then 'Millionaire'
    when balance_usd >= 1000000000 then 'Billionaire' end as level,
    'grade' as category,
    'all' trade_type,
    'all' as project,
    'all' as asset
    from
    (
        select
            address,
            'ALL' as token ,
            sum(balance_usd) as balance_usd
        from
            total_balance_volume_usd tbvu
        group by
            address
    ) a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
    where
        a1.balance_usd >= 100
  and a2.data_subject = 'balance_grade'
  and a2.token_type = 'token' and address <>'0x000000000000000000000000000000000000dead';

drop table if exists address_label_crowd_token_whale;
CREATE TABLE public.address_label_crowd_token_whale (
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
truncate table public.address_label_crowd_token_whale;
insert into public.address_label_crowd_token_whale(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset)
select
           a1.address ,
           'crowd_token_whale' as label_type,
           'crowd_token_whale' as label_name,
           0  as data,
           'CROWD'  as wired_type,
           now() as updated_at,
           'g'  as "group",
    'crowd_token_whale'  as level,
    'other'  as category,
    'all' trade_type,
    'all' as project,
    'all' as asset
       from (
                select address from
                    address_label_token_balance_grade_all
                where label_name = 'ALL_ALL_ALL_BALANCE_GRADE_Millionaire'
                   or label_name = 'ALL_ALL_ALL_BALANCE_GRADE_Billionaire'
                   or label_name = 'ALL_ALL_ALL_BALANCE_TOP_WHALE'
                union all
                select address from address_label_token_balance_rank_all  ) a1
       where address <>'0x000000000000000000000000000000000000dead';

