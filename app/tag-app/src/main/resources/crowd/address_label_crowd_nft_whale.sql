truncate table public.address_label_crowd_nft_whale;
insert into public.address_label_crowd_nft_whale(address,label_type,label_name,data,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    data,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
    a1.address ,
    'crowd_nft_whale' as label_type,
    'crowd_nft_whale' as label_name,
    0  as data,
    now() as updated_at
from (
   select address from address_label_nft_balance_rank
    where label_name = 'ALL_NFT_BALANCE_RANK_RARE_NFT_COLLECTOR'
   or  label_name =  'ALL_NFT_BALANCE_RANK_UNCOMMON_NFT_COLLECTOR'
   or  label_name =  'ALL_NFT_BALANCE_RANK_EPIC_NFT_COLLECTOR'
   or  label_name =  'ALL_NFT_BALANCE_RANK_LEGENDARY_NFT_COLLECTOR'
    union all
    select address from
    address_label_nft_balance_top  ) a1
where
        address <>'0x000000000000000000000000000000000000dead';