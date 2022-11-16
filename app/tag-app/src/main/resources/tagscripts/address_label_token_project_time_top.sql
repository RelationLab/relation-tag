truncate table public.address_label_token_project_time_top;
insert into public.address_label_token_project_time_top(address,label_type,label_name,updated_at)
    select
    s1.address,
    s1.label_type,
    s1.label_type as label_name,
    now() as updated_at
    from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over(partition by   a2.seq_flag  order by first_updated_block_height desc) as rn
        from dex_tx_volume_count_summary a1 inner join dim_project_token_type a2
                                                       on a1.token=a2.token
                                                           and a1.project=a2.project
                                                           and a1.type=a2.type and a2.data_subject='time'
        where balance_usd >0
    ) s1 where s1.rn<=100;