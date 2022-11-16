truncate  table public.address_label_nft_balance_rank;
insert into public.address_label_nft_balance_rank(address,label_type,label_name,updated_at)
    select tb1.address,
       tb2.label_type,
       tb2.label_type||'_'||case
                                when zb_rate > 0.01 and zb_rate <= 0.025 then 'RARE_NFT_COLLECTOR'
                                when zb_rate > 0.001 and zb_rate <= 0.01 then 'EPIC_NFT_COLLECTOR'
                                when zb_rate > 0.025 and zb_rate <= 0.1 then 'UNCOMMON_NFT_COLLECTOR'
                                when zb_rate <= 0.001 then 'LEGENDARY_NFT_COLLECTOR'
           end as label_name,
       now()   as updated_at
    from (select t1.id,
             t1.address,
             t1.token,
             t1.balance,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.balance,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id,
                         a1.address,
                         a1.token,
                         a1.balance,
                         a1.count_sum,
                         a10.count_sum_total
                  from (SELECT
                            md5(CAST(random() AS varchar)) AS id,
                            a1.address,
                            a1.token,
                            a1.balance,
                            ROW_NUMBER() OVER(PARTITION BY seq_flag
    ORDER BY
	balance DESC,id asc) AS count_sum
                        FROM
                            (
                                SELECT
                                    s1.address,
                                    s2.seq_flag,
                                    s1.token,
                                    min(s1.id) id,
                                    sum(s1.balance) AS balance
                                FROM (
                                         -- project(null)+nft+type(null)
                                         select  address
                                              ,token
                                              ,balance
                                              ,id
                                              ,total_transfer_volume
                                              ,total_transfer_count
                                              ,total_transfer_to_volume
                                              ,total_transfer_to_count
                                              ,total_transfer_mint_volume
                                              ,total_transfer_mint_count
                                              ,total_transfer_burn_volume
                                              ,total_transfer_burn_count
                                              ,total_transfer_all_volume
                                              ,total_transfer_all_count
                                              ,updated_block_height from nft_holding where balance >= 1
                                         union all
                                         -- project(null)-token(ALL)-type(null)
                                         select address
                                              ,'ALL' as token
                                              ,balance
                                              ,id
                                              ,total_transfer_volume
                                              ,total_transfer_count
                                              ,total_transfer_to_volume
                                              ,total_transfer_to_count
                                              ,total_transfer_mint_volume
                                              ,total_transfer_mint_count
                                              ,total_transfer_burn_volume
                                              ,total_transfer_burn_count
                                              ,total_transfer_all_volume
                                              ,total_transfer_all_count
                                              ,updated_block_height  from nft_holding where balance >= 1
                                     )
                                         s1
                                         INNER JOIN dim_project_token_type s2
                                                    ON
                                                                s1.token = s2.token
                                                            AND  (s2.project ='' or s2.project ='ALL')
                                                            AND (s2.type='' or s2.type='ALL')
                                                            AND s2.data_subject = 'balance_rank' and s2.label_type like '%NFT%' AND  s2.label_type NOT  LIKE '%WEB3%'
                                WHERE
                                        balance >= 1
                                GROUP BY
                                    s1.address,
                                    s1.token,
                                    s2.seq_flag) AS a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total,token
                        from (select  address
                                   ,token
                                    ,balance
                              from nft_holding  where balance >= 1
                              union all
                              -- project(null)-token(ALL)-type(null)
                              select address
                                   ,'ALL' as token
                                   ,balance
                              from nft_holding  where balance >= 1) nh group by token) as a10
                       on a10.token = a1.token) as a2) as t1
     ) tb1
         inner join
     dim_project_token_type tb2
     on
             tb1.token = tb2.token
    where tb1.balance >= 1  AND   (tb2.project ='' or tb2.project ='ALL')
  AND (tb2.type='' OR tb2.type='ALL')
  and tb2.data_subject = 'balance_rank' and tb2.label_type like '%NFT%' AND  tb2.label_type NOT  LIKE '%WEB3%' and  zb_rate <= 0.1;