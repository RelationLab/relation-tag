truncate table public.address_label_crowd_nft_active_users;
insert into public.address_label_crowd_nft_active_users (address,label_type,label_name,updated_at)
select
    a1.address ,
    'crowd_nft_active_users' as label_type,
    'crowd_nft_active_users' as label_name,
    now() as updated_at from address_label_nft_count_grade a1
         where (label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_Low'
            or label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_Medium'
            or label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_High')
    and
          address <>'0x000000000000000000000000000000000000dead';