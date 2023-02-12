truncate table public.address_label_crowd_defi_high_demander;
insert into public.address_label_crowd_defi_high_demander (address,label_type,label_name,updated_at)
select
    a1.address ,
    'crowd_defi_high_demander' as label_type,
    'crowd_defi_high_demander' as label_name,
    now() as updated_at  from address_label_token_volume_rank_all a1
         where (label_name = 'ALL_ALL_ALL_VOLUME_RANK_MEDIUM' or label_name = 'ALL_ALL_ALL_VOLUME_RANK_HEAVY'
            or label_name = 'ALL_ALL_ALL_VOLUME_RANK_ELITE'  or label_name = 'ALL_ALL_ALL_VOLUME_RANK_LEGENDARY')
and
         address <>'0x000000000000000000000000000000000000dead';