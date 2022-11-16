truncate table address_label_nft_transfer_volume_top;
insert into public.address_label_nft_transfer_volume_top(address,label_type,label_name,updated_at)
    select
    s1.address,
    s1.label_type,
    label_type||'_'||'TOP' as label_name,
        now() as updated_at
    from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.token
	order by
		total_transfer_volume desc,address asc) as rn
        from (select address
                   ,token
                   ,sum(total_transfer_volume) as total_transfer_volume from (
                   select  address
                        ,token
                        ,total_transfer_volume
                   from nft_transfer_holding where total_transfer_volume>=1
                   union all
                   -- project(null)+nft（ALL）+type
                   select  address
                        ,'ALL' as token
                        ,total_transfer_volume
                   from nft_transfer_holding where total_transfer_volume>=1) totala group by  address,token) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.type = 'Transfer' and (a2.project ='' or a2.project ='ALL')
                                   and a2.data_subject = 'volume_top' and a2.label_type like '%NFT%' AND  a2.label_type NOT  LIKE '%WEB3%'
    ) s1
    where
        s1.rn <= 100;
