truncate table public.address_label_eth_time_grade;
insert into public.address_label_eth_time_grade(address,label_type,label_name,updated_at)
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
    now() as updated_at
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
  and counter <= 365;