drop table if exists address_label_univ3_balance_grade;
CREATE TABLE public.address_label_univ3_balance_grade (
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
truncate table public.address_label_univ3_balance_grade;
vacuum address_label_univ3_balance_grade;

insert into public.address_label_univ3_balance_grade(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
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
        when balance_usd >= 1000000000 then 'Billionaire' end  as level,
    'grade'  as category,
    'ALL' trade_type,
    '' as project,
    a2.token_name as asset,
    'balance' as bus_type
from
    (
        select
            address,
            token,
            round(balance_usd,3) balance_usd,
            project,
            type
        from
            dex_tx_volume_count_summary_univ3 tbvutk
        where
                project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'
          and balance_usd >= 100
          and type = 'lp'
    ) a1
        inner join
    dim_rule_content a2
    on
                a1.token = a2.token
            and a2.label_type  like 'Uniswap_v3%'
where
        a2.data_subject = 'balance_grade' and address not in (select address from exclude_address);
insert into tag_result(table_name,batch_date)  SELECT 'address_label_univ3_balance_grade' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;



