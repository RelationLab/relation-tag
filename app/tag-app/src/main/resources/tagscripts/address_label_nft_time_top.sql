truncate table public.address_label_nft_time_top;
insert into public.address_label_nft_time_top(address,label_type,label_name,`data`,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    `data`,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
    s1.address,
    s1.label_type,
    s1.label_type as label_name,
    s1.rn  as `data`,
    now() as updated_at
    from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.seq_flag
	order by
		first_tx_time asc) as rn
        from
            (
                select
                    address,
                    token,
                    latest_tx_time,
                    balance,
                    first_tx_time
                from
                    nft_holding_time where address <>'0x000000000000000000000000000000000000dead'
            ) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = 'time_rank'
                                   and a2.label_type like '%NFT%'
                                   and a2.label_type not like '%WEB3%'
                                   and (a2.type = ''
                                   or a2.type = 'ALL')
                                   and (a2.project = ''
                                   or a2.project = 'ALL')
    ) s1
    where
        s1.rn <= 100 ) atb;