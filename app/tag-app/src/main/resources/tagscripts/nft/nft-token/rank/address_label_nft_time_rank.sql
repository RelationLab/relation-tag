truncate table public.address_label_nft_time_rank;
insert into public.address_label_nft_time_rank (address,label_type,label_name,updated_at)
    select a1.address
        ,
       a2.label_type
        ,
       a2.label_type||'_'||case
           when counter >= 155 then 'LONG_TERM_HOLDER'
           when counter >= 1
               and counter < 155 then 'SHORT_TERM_HOLDER'
           end as label_name
        ,
        now()   as updated_at
    from (select token,
             address,
             floor((floor(extract(epoch from now())) - nht.latest_tx_time) / (24 * 3600)) as counter
      from nft_holding_time nht
      where nht.latest_tx_time is not null
        and balance > 0)  a1
         inner join
     dim_project_token_type a2
     on
             a1.token = a2.token
    where a2.data_subject = 'time_special' and a2.label_type like '%NFT%' AND  a2.label_type NOT  LIKE '%WEB3%' and counter >=1
  and counter <= 365  AND (a2.type='' or a2.type='ALL') and (a2.project ='' or a2.project ='ALL');