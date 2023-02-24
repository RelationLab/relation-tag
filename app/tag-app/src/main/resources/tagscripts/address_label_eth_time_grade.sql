drop table if exists address_label_eth_time_grade;
CREATE TABLE public.address_label_eth_time_grade (
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
truncate table public.address_label_eth_time_grade;
insert into public.address_label_eth_time_grade(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset)
 select
    a1.address,
    a2.label_type,
    a2.label_type || '_' || case
                                when counter = 1 then 'L1'
                                when counter > 1
                                    and counter <= 7 then 'L2'
                                when counter > 7
                                    and counter <= 30 then 'L3'
                                when counter > 30
                                    and counter <= 90 then 'L4'
                                when counter > 90
                                    and counter <= 180 then 'L5'
                                when counter > 180
                                    and counter <= 365 then 'L6'
        end as label_name,
    a1.counter  as data,
    'DEFI'  as wired_type,
    now() as updated_at,
    't'  as "group",
    case
    when counter = 1 then 'L1'
    when counter > 1
    and counter <= 7 then 'L2'
    when counter > 7
    and counter <= 30 then 'L3'
    when counter > 30
    and counter <= 90 then 'L4'
    when counter > 90
    and counter <= 180 then 'L5'
    when counter > 180
    and counter <= 365 then 'L6'
    end  as level,
    'grade' as category,
    'all' trade_type,
    'all' as project,
    a2.token_name as asset
    from
    (
        select
            address,
            'eth' as token,
            floor((floor(extract(epoch from now())) - latest_tx_time) / (24 * 3600)) as counter
        from
            eth_holding_time tbvutk) a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
    where
        a2.data_subject = 'time_grade'
  and counter >= 1
  and counter <= 365 and address <>'0x000000000000000000000000000000000000dead';