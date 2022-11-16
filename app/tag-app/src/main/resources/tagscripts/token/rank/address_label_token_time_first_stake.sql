truncate table address_label_token_time_first_stake;
insert into public.address_label_token_time_first_stake (address,label_type,label_name,updated_at)
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
            row_number() over( partition by a2.seq_flag
	order by
		first_updated_block_height asc) as rn
        from
            (select * from
                dex_tx_volume_count_summary where type='stake' and balance_usd>0)  a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token and a1.project=a2.project
                                   and a2.data_subject = 'FIRST_MOVER_STAKING'
    ) s1
    where
        s1.rn <= 100;