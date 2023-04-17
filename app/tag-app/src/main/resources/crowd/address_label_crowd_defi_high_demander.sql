truncate table public.address_label_crowd_defi_high_demander;
insert into public.address_label_crowd_defi_high_demander(address,label_type,label_name,data,wired_type,updated_at,group,level,category,trade_type,project,asset,bus_type)
select
    address ,
    label_type,
    label_name,
    data,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
    a1.address ,
    'crowd_defi_high_demander' as label_type,
    'crowd_defi_high_demander' as label_name,
    0  as data,
    now() as updated_at  from address_label_token_volume_rank_all a1
         where (label_name = 'ALL_ALL_ALL_VOLUME_RANK_MEDIUM' or label_name = 'ALL_ALL_ALL_VOLUME_RANK_HEAVY'
            or label_name = 'ALL_ALL_ALL_VOLUME_RANK_ELITE'  or label_name = 'ALL_ALL_ALL_VOLUME_RANK_LEGENDARY')
and
          address not in (select address from exclude_address);