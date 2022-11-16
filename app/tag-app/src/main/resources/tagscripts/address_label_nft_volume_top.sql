truncate table public.address_label_nft_volume_top;
insert into public.address_label_nft_volume_top (address,label_type,label_name,updated_at)
    select
    s1.address,
    s1.label_type,
    s1.label_type||'_'||'TOP' as label_name,
    now() as updated_at
    from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by seq_flag
	order by
		transfer_volume desc,address asc) as rn
        from( select address
                   ,token
                   ,type
                   ,sum(transfer_volume) as transfer_volume
              from (
                       -- project(null)+nft+type(null)
                       select
                           address
                            ,token
                            ,'' as type
                            ,transfer_volume
                            ,transfer_count
                       from
                           nft_volume_count  where transfer_volume >= 1
                       union all
                       -- project(null)+nft(ALL)+type(null)
                       select
                           address
                            ,'ALL' AS token
                            ,'' AS type
                            ,transfer_volume
                            ,transfer_count

                       from
                           nft_volume_count  where transfer_volume >= 1
                       union all
                       -- project(null)+nft+type
                       select
                           address
                            ,token
                            ,type
                            ,transfer_volume
                            ,transfer_count

                       from
                           nft_volume_count  where transfer_volume >= 1
                       union all
                       -- project(null)+nft+type(ALL)
                       select
                           address
                            ,token
                            ,'ALL' AS type
                            ,transfer_volume
                            ,transfer_count

                       from
                           nft_volume_count  where transfer_volume >= 1
                       union all
                       -- project(null)+nft（ALL）+type
                       select
                           address
                            ,'ALL' AS token
                            ,type
                            ,transfer_volume
                            ,transfer_count
                       from
                           nft_volume_count  where transfer_volume >= 1
                   ) tatola group by   address,token,type) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = 'volume_top' and a2.label_type like '%NFT%' AND  a2.label_type NOT  LIKE '%WEB3%'
                                   and a1.type=a2.type and (a2.project ='' or a2.project ='ALL')
    ) s1
    where
        s1.rn <= 100;