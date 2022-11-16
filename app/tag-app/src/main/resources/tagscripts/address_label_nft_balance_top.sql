truncate table address_label_nft_balance_top;
insert into public.address_label_nft_balance_top (address,label_type,label_name,updated_at)
    select
    s1.address,
    s1.label_type,
    s1.label_type||'_'||'WHALE' as label_name,
    now() as updated_at
    from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.token
	order by
		balance desc,address asc) as rn
        from (select  address,
             token,
             sum(balance) as  balance from
            (
                select
                    address,
                    token,
                    balance
                from
                    nft_holding
                union all
                select
                    address,
                    'ALL' as token,
                    balance
                from
                    nft_holding   ) totala where totala.balance>=1
                   group by address,token) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = 'balance_top' and a2.label_type like '%NFT%' AND  a2.label_type NOT  LIKE '%WEB3%'
                                   and (a2.project ='' or a2.project ='ALL')  AND (a2.type='' or a2.type='ALL')
  ) s1
    where
        s1.rn <= 100;