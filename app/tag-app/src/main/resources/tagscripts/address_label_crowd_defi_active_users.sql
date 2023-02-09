truncate table public.address_label_crowd_defi_active_users;
insert into public.address_label_crowd_defi_active_users (address,label_type,label_name,updated_at)
select
    a1.address ,
    'crowd_defi_active_users' as label_type,
    'crowd_defi_active_users' as label_name,
    now() as updated_at
from address_label_token_count_grade a1
where (label_name = 'ALL_ALL_ALL_ACTIVITY_High'
    or label_name = 'ALL_ALL_ALL_ACTIVITY_Medium'
    or label_name = 'ALL_ALL_ALL_ACTIVITY_Low')
  and  address <>'0x000000000000000000000000000000000000dead';