truncate table public.address_label_nft_transfer_volume_count_rank;
insert into public.address_label_nft_transfer_volume_count_rank (address,label_type,label_name,updated_at)
    select tb1.address ,
       tb2.label_type,
       tb2.label_type||'_ELITE_NFT_TRADER' as label_name,
        now()   as updated_at
    from (select t1.id,
             t1.address,
             t1.token,
             t1.total_transfer_volume,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate,
             t1.zb_rate_transfer_count
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.total_transfer_volume,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate,
                   cast(a2.transfer_count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate_transfer_count
            from (select a1.id,
                         a1.address,
                         a1.token,
                         a1.total_transfer_volume,
                         a1.count_sum,
                         a1.transfer_count_sum,
                         a10.count_sum_total
                  from (SELECT
                            md5(CAST(random() AS varchar)) AS id,
                            a1.address,
                            a1.token,
                            a1.total_transfer_volume,
                            ROW_NUMBER() OVER(PARTITION BY seq_flag ORDER BY total_transfer_volume DESC,address asc) AS count_sum,
                                ROW_NUMBER() OVER(PARTITION BY seq_flag ORDER BY total_transfer_count DESC,address asc) AS transfer_count_sum
                        FROM
                            (
                                SELECT
                                    s1.address,
                                    s2.seq_flag,
                                    s1.token,
                                    sum(s1.total_transfer_volume) AS total_transfer_volume,
                                    sum(s1.total_transfer_count) AS total_transfer_count
                                FROM (
                                         -- project-token-type
                                         select  address
                                              ,token
                                              ,total_transfer_volume
                                              ,total_transfer_count
                                         from nft_transfer_holding   WHERE
                                                 total_transfer_volume >= 1
                                         union all
                                         -- project(null)+nft（ALL）+type
                                         select  address
                                              ,'ALL' as token
                                              ,total_transfer_volume
                                              ,total_transfer_count
                                         from nft_transfer_holding   WHERE
                                                 total_transfer_volume >= 1
                                     )
                                         s1
                                         INNER JOIN dim_project_token_type s2
                                                    ON
                                                                s1.token = s2.token
                                                            AND s2.data_subject = 'volume_elite'
                                and s2.label_type like '%NFT%' AND  s2.label_type NOT  LIKE '%WEB3%' and (s2.project ='' or s2.project ='ALL')
                                WHERE
                                    total_transfer_volume >= 1
                                GROUP BY
                                    s1.address,
                                    s1.token,
                                    s2.seq_flag) AS a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total ,token
                        from ( -- project-token-type
                                 select  address
                                      ,token
                                 from nft_transfer_holding   WHERE
                                         total_transfer_volume >= 1
                                 union all
                                 -- project(null)+nft（ALL）+type
                                 select  address
                                      ,'ALL' as token
                                 from nft_transfer_holding   WHERE
                                         total_transfer_volume >= 1) nth group by  token) as a10
                       on a10.token = a1.token) as a2) as t1
     ) tb1
         inner join
     dim_project_token_type tb2
     on
             tb1.token = tb2.token
    where tb1.total_transfer_volume >= 1
  and tb2.type = 'Transfer'  and (tb2.project ='' or tb2.project ='ALL')
  and zb_rate <= 0.001 and zb_rate_transfer_count<=0.001
  and tb2.data_subject = 'volume_elite' and tb2.label_type like '%NFT%' AND  tb2.label_type NOT  LIKE '%WEB3%';