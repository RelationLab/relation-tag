drop table if exists address_label_token_time_first_lp;
CREATE TABLE public.address_label_token_time_first_lp (

                                                          address varchar(512) NULL,
                                                          data numeric(250, 20) NULL,
                                                          wired_type varchar(20) NULL,
                                                          label_type varchar(512) NULL,
                                                          label_name varchar(1024) NULL,
                                                          updated_at timestamp(6) NULL
);
truncate table address_label_token_time_first_lp;
insert into public.address_label_token_time_first_lp(address,label_type,label_name,data,wired_type,updated_at)
    select
    s1.address,
    s1.label_type,
    s1.label_type as label_name,
    rn  as data,
    'DEFI'  as wired_type,
    now() as updated_at
    from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.token,
		seq_flag
	order by
		first_updated_block_height asc,
		address asc) as rn
        from
            (
                select
                    *
                from
                    dex_tx_volume_count_summary
                where
                        type = 'lp'
                  and balance_usd>0 and address <>'0x000000000000000000000000000000000000dead') a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a1.project = a2.project
                                   and a2.data_subject = 'FIRST_MOVER_LP'
    ) s1
    where
        s1.rn <= 100;