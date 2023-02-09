truncate table public.address_label_nft_balance_grade;
insert into public.address_label_nft_balance_grade(address,label_type,label_name,data,updated_at)
    select address
        ,
       label_type
        ,
       label_type||'_'||case
           when balance = 1 then 'L1'
           when balance >= 2
               and balance < 4 then 'L2'
           when balance >= 4
               and balance < 11 then 'L3'
           when balance >= 11
               and balance < 51 then 'L4'
           when balance >= 51
               and balance < 101 then 'L5'
           when balance >= 101 then 'L6'
           end  as label_name,
           balance,
        now()   as updated_at
    from (
         -- project(null)+nft+type(null)
         select a1.address,
                a2.label_type,
                sum(balance) as balance
         from nft_holding a1
                  inner join dim_project_token_type a2
                             on a1.token = a2.token and (a2.project ='' or a2.project ='ALL') and (a2.type ='' OR a2.type ='ALL') and
                                a2.data_subject = 'balance_grade' and a2.label_type like '%NFT%' AND  a2.label_type NOT  LIKE '%WEB3%'
         group by a1.address,
             a2.label_type
         union all
         -- project(null)+nft(ALL)+type(null)
         select a1.address,
             a2.label_type,
             sum(balance) as balance
         from nft_holding a1
             inner join dim_project_token_type a2
         on a2.token = 'ALL' and (a2.project ='' or a2.project ='ALL') and (a2.type ='' OR a2.type ='ALL') and
             a2.data_subject = 'balance_grade' and a2.label_type like '%NFT%' AND  a2.label_type NOT  LIKE '%WEB3%'
         group by a1.address,
             a2.label_type
     ) t where balance>=1 and address <>'0x000000000000000000000000000000000000dead';