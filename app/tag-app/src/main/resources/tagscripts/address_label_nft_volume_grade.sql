truncate table public.address_label_nft_volume_grade;
insert into public.address_label_nft_volume_grade(address,label_type,label_name,updated_at)
    select address,
       label_type,
       label_type||'_'||case
           when volume_usd >= 1
               and volume_usd < 3 then 'L1'
           when volume_usd >= 3
               and volume_usd < 7 then 'L2'
           when volume_usd >= 7
               and volume_usd < 21 then 'L3'
           when volume_usd >= 21
               and volume_usd < 101 then 'L4'
           when volume_usd >= 101
               and volume_usd < 201 then 'L5'
           when volume_usd >= 201 then 'L6'
           end as label_name,
        now()   as updated_at
    from (
         -- project(null)+nft+type
         select a1.address,
                a2.seq_flag,
                a2.label_type,
                sum(
                        transfer_volume) as volume_usd
         from nft_volume_count a1
                  inner join dim_project_token_type a2
                             on a1.token = a2.token and (a2.project ='' or a2.project ='ALL') and a1.type = a2.type and a2.type!='transfer' and
                                a2.data_subject = 'volume_grade'
         group by a1.address,
             a2.seq_flag,
             a2.label_type
         union all
         -- project(null)+nft（ALL）+type
         select a1.address,
             a2.seq_flag,
             a2.label_type,
             sum(
             transfer_volume) as volume_usd
         from nft_volume_count a1
             inner join dim_project_token_type a2
         on a2.token = 'ALL' and (a2.project ='' or a2.project ='ALL') and a1.type = a2.type and a2.type!='transfer' and
             a2.data_subject = 'volume_grade' and a2.label_type like '%NFT%' AND  a2.label_type NOT  LIKE '%WEB3%'
         group by a1.address,
             a2.seq_flag,
             a2.label_type) t where volume_usd >= 1;