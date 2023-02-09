truncate table public.address_label_crowd_active_users;
insert into public.address_label_crowd_active_users (address,label_type,label_name,updated_at)
select
    a1.address ,
    'crowd_active_users' as label_type,
    'crowd_active_users' as label_name,
    now() as updated_at
from (
         select address from address_label_nft_count_grade
         where label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_High'
         union all
         select address from address_label_web3_type_count_grade
         where label_name = 'WEB3_ALL_NFTRecipient_ACTIVITY_High'
         union all
         select address from address_label_token_count_grade
         where label_name = 'ALL_ALL_ALL_ACTIVITY_High') a1
where
        address <>'0x000000000000000000000000000000000000dead';