truncate table public.address_label_nft_volume_count_rank;
insert into public.address_label_nft_volume_count_rank(address,label_type,label_name,updated_at)
    select
    tb1.address ,
    tb2.label_type,
    tb2.label_type||'_ELITE_NFT_TRADER' as label_name,
    now() as updated_at
    from
    (
        select
            t1.id,
            t1.address,
            t1.token,
            t1.type,
            t1.transfer_volume,
            t1.count_sum,
            t1.count_sum_total,
            t1.zb_rate,
            t1.zb_rate_transfer_count
        from
            (
                select
                    a2.id,
                    a2.address,
                    a2.token,
                    a2.type,
                    a2.transfer_volume,
                    a2.count_sum,
                    a2.count_sum_total,
                    cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate,
                    cast(a2.transfer_count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate_transfer_count
                from
                    (
                        select
                            a1.id,
                            a1.address,
                            a1.token,
                            a1.type,
                            a1.transfer_volume,
                            a1.count_sum,
                            a1.transfer_count_sum,
                            a10.count_sum_total
                        from
                            (
                                select
                                    md5(cast(random() as varchar)) as id,
                                    a1.address,
                                    a1.token,
                                    a1.type,
                                    a1.transfer_volume,
                                    a1.transfer_count,
                                    row_number() over(partition by seq_flag
				order by
					transfer_volume desc,address asc) as count_sum,
                                        row_number() over(partition by seq_flag
				order by
					transfer_count desc,address asc) as transfer_count_sum
                                from
                                    (
                                        select
                                            s1.address,
                                            s2.seq_flag,
                                            s1.token,
                                            s1.type,
                                            sum(transfer_volume) as transfer_volume,
                                            sum(transfer_count) as transfer_count
                                        from
                                            (
                                                -- project(null)+nft+type
                                                select
                                                    address ,
                                                    token ,
                                                    type ,
                                                    transfer_volume ,
                                                    transfer_count
                                                from
                                                    nft_volume_count where transfer_volume>0
                                                union all
                                                -- project(null)+nft（ALL）+type
                                                select
                                                    address ,
                                                    'ALL' as token ,
                                                    type ,
                                                    transfer_volume ,
                                                    transfer_count
                                                from
                                                    nft_volume_count where transfer_volume>0) s1
                                                inner join dim_project_token_type s2 on
                                                        s1.token = s2.token
                                                    and s2.type = s2.type
                                                    and  s2.data_subject = 'volume_elite'
                                                    and s2.label_type like '%NFT%' AND  s2.label_type NOT  LIKE '%WEB3%'
                                        where
                                                transfer_volume >= 1
                                        group by
                                            s1.address,
                                            s1.token,
                                            s1.type,
                                            s2.seq_flag) as a1) as a1
                                inner join (
                                select
                                    count(distinct address) as count_sum_total,token ,type
                                from
                                    (
                                        -- project(null)+nft+type
                                        select
                                            address ,
                                            token ,
                                            type
                                        from
                                            nft_volume_count where  transfer_volume>0
                                        union all
                                        -- project(null)+nft（ALL）+type
                                        select
                                            address ,
                                            'ALL' as token ,
                                            type
                                        from
                                            nft_volume_count where  transfer_volume>0) nvc group by token ,type) as a10 on
                                        a10.token=  a1.token and a10.type=  a1.type) as a2) as t1 ) tb1
        inner join dim_project_token_type tb2 on
                tb1.token = tb2.token
            and tb2.type = tb2.type  and (tb2.project ='' or tb2.project ='ALL')
    where
        tb1.transfer_volume >= 1
  and zb_rate <= 0.001
  and zb_rate_transfer_count <= 0.001
  and tb2.data_subject = 'volume_elite' and tb2.label_type like '%NFT%' AND  tb2.label_type NOT  LIKE '%WEB3%';