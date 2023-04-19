drop table if exists address_label_eth_count_grade;
CREATE TABLE public.address_label_eth_count_grade (
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
truncate table public.address_label_eth_count_grade;
vacuum address_label_eth_count_grade;

insert into public.address_label_eth_count_grade(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
 select
    a1.address ,
    a2.label_type,
    a2.label_type || '_' || case
                                when total_transfer_count >= 1
                                    and total_transfer_count < 10 then 'L1'
                                when total_transfer_count >= 10
                                    and total_transfer_count < 40 then 'L2'
                                when total_transfer_count >= 40
                                    and total_transfer_count < 80 then 'L3'
                                when total_transfer_count >= 80
                                    and total_transfer_count < 120 then 'L4'
                                when total_transfer_count >= 120
                                    and total_transfer_count < 160 then 'L5'
                                when total_transfer_count >= 160
                                    and total_transfer_count < 200 then 'L6'
                                when total_transfer_count >= 200
                                    and total_transfer_count < 400 then 'Low'
                                when total_transfer_count >= 400
                                    and total_transfer_count < 619 then 'Medium'
                                when total_transfer_count >= 619 then 'High'
        end as label_name,
    a1.total_transfer_count  as data,
    'DEFI'  as wired_type,
    now() as updated_at,
    'c'  as "group",
    case
        when total_transfer_count >= 1
        and total_transfer_count < 10 then 'L1'
        when total_transfer_count >= 10
        and total_transfer_count < 40 then 'L2'
        when total_transfer_count >= 40
        and total_transfer_count < 80 then 'L3'
        when total_transfer_count >= 80
        and total_transfer_count < 120 then 'L4'
        when total_transfer_count >= 120
        and total_transfer_count < 160 then 'L5'
        when total_transfer_count >= 160
        and total_transfer_count < 200 then 'L6'
        when total_transfer_count >= 200
        and total_transfer_count < 400 then 'Low'
        when total_transfer_count >= 400
        and total_transfer_count < 619 then 'Medium'
        when total_transfer_count >= 619 then 'High'
    end as level,
    'grade' as category,
    'ALL' trade_type,
    '' as project,
    a2.token_name as asset,
    'activity' as bus_type
    from
    (
        select
            address,
            'eth' as token,
            total_transfer_count
        from
            eth_holding_vol_count th1
    ) a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
    where
        a1.total_transfer_count >= 1
  and a2.data_subject = 'count'
  and a2.token_type = 'token' and address not in (select address from exclude_address);
insert into tag_result(table_name,batch_date)  SELECT 'address_label_eth_count_grade' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
