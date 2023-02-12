truncate table public.address_label_crowd_nft_whale;
insert into public.address_label_crowd_nft_whale (address,label_type,label_name,updated_at)
select
    a1.address ,
    'crowd_nft_whale' as label_type,
    'crowd_nft_whale' as label_name,
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