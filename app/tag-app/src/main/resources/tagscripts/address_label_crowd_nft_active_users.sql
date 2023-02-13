truncate table public.address_label_crowd_nft_active_users;
insert into public.address_label_crowd_nft_active_users(address,label_type,label_name,`data`,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    `data`,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
    a1.address ,
    'crowd_nft_active_users' as label_type,
    'crowd_nft_active_users' as label_name,
    0  as `data`,
    now() as updated_at from address_label_nft_count_grade a1
         where (label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_Low'
            or label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_Medium'
            or label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_High')
    and
          address <>'0x000000000000000000000000000000000000dead') atb;