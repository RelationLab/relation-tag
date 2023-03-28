drop table if exists address_label_token_time_special;
CREATE TABLE public.address_label_token_time_special (
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
                                                         asset varchar(50) NULL,
                                                         bus_type varchar(20) NULL
);
truncate table public.address_label_token_time_special;
insert into public.address_label_token_time_special(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
    select
    a1.address ,
    a2.label_type,
    a2.label_type || '_' || case
                                when counter >= 155 then 'LONG_TERM_HOLDER'
                                when counter >= 1
                                    and counter < 155 then 'SHORT_TERM_HOLDER'
        end as label_name,
    counter  as data,
    'DEFI'  as wired_type,
    now() as updated_at,
    't'  as "group",
    case
    when counter >= 155 then 'LONG_TERM_HOLDER'
    when counter >= 1
    and counter < 155 then 'SHORT_TERM_HOLDER' end  as level,
    'other'  as category,
    'ALL' trade_type,
    '' as project,
    a2.token_name as asset,
    'time' as bus_type
    from
    (
        select
            address,
            token,
            counter
        from
            token_holding_time tbvutk
        where
                balance>0 and address <>'0x000000000000000000000000000000000000dead') a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
    where
        a2.data_subject = 'time_special'
  and counter >= 1
  and a2.token_type = 'token';