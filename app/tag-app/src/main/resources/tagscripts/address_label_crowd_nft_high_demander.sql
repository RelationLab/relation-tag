truncate table public.address_label_crowd_nft_high_demander;
insert into public.address_label_crowd_nft_high_demander(address,label_type,label_name,`data`,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    `data`,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
    a1.address ,
    'crowd_nft_high_demander' as label_type,
    'crowd_nft_high_demander' as label_name,
    0  as `data`,
    now() as updated_at
 from address_label_nft_volume_rank a1
         where (label_name = 'ALL_ALL_ALL_NFT_VOLUME_RANK_RARE_NFT_TRADER'
            or label_name = 'ALL_ALL_ALL_NFT_VOLUME_RANK_EPIC_NFT_TRADER'
            or label_name = 'ALL_ALL_ALL_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER'
            or label_name = 'ALL_ALL_ALL_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER')
    and
        address <>'0x000000000000000000000000000000000000dead') atb;