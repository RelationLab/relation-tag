truncate table public.address_label_crowd_long_term_holder;
insert into public.address_label_crowd_long_term_holder(address,label_type,label_name,`data`,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    `data`,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
    a1.address ,
    'crowd_long_term_holder' as label_type,
    'crowd_long_term_holder' as label_name,
    0  as `data`,
    now() as updated_at
from (
         select address from address_label_eth_time_special
         where label_name = 'ETH_HOLDING_TIME_SPECIAL_LONG_TERM_HOLDER'
         union all
         select address from address_label_token_time_special
         where label_name like '%_HOLDING_TIME_SPECIAL_LONG_TERM_HOLDER'
         union all
         select address from address_label_nft_time_rank
         where label_name like '%_NFT_TIME_SPECIAL_LONG_TERM_HOLDER'
     ) a1
where  address <>'0x000000000000000000000000000000000000dead') atb;