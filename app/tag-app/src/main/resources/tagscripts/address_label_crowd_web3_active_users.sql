truncate table public.address_label_crowd_web3_active_users;
insert into public.address_label_crowd_web3_active_users(address,label_type,label_name,`data`,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    `data`,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
    a1.address ,
    'crowd_web3_active_users' as label_type,
    'crowd_web3_active_users' as label_name,
    0  as `data`,
    now() as updated_at
from  address_label_web3_type_count_grade a1
         where (label_name = 'WEB3_ALL_NFTRecipient_ACTIVITY_High'
            or label_name = 'WEB3_ALL_NFTRecipient_ACTIVITY_Medium'
            or label_name = 'WEB3_ALL_NFTRecipient_ACTIVITY_Low')
and address <>'0x000000000000000000000000000000000000dead') atb;