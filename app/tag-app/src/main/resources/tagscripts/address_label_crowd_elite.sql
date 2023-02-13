truncate table public.address_label_crowd_elite;
insert into public.address_label_crowd_elite(address,label_type,label_name,`data`,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    `data`,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
    a1.address ,
    'crowd_elite' as label_type,
    'crowd_elite' as label_name,
    0  as `data`,
    now() as updated_at
from (
         select address from address_label_nft_volume_count_rank
         where label_name = 'ALL_ALL_ALL_NFT_VOLUME_ELITE_ELITE_NFT_TRADER'
         union all
         select address from address_label_token_volume_rank_all
         where label_name = 'ALL_ALL_ALL_VOLUME_RANK_ELITE'
         ) a1
where
        address <>'0x000000000000000000000000000000000000dead') atb;