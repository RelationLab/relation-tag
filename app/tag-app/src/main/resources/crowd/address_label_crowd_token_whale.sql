truncate table public.address_label_crowd_token_whale;
insert into public.address_label_crowd_token_whale(address,label_type,label_name,data,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    data,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
    a1.address ,
    'crowd_token_whale' as label_type,
    'crowd_token_whale' as label_name,
    0  as data,
    now() as updated_at
from (
    select address from
    address_label_token_balance_grade_all
    where label_name = 'ALL_ALL_ALL_BALANCE_GRADE_Millionaire'
           or label_name = 'ALL_ALL_ALL_BALANCE_GRADE_Billionaire'
           or label_name = 'ALL_ALL_ALL_BALANCE_TOP_WHALE'
    union all
    select address from address_label_token_balance_rank_all  ) a1
    where address <>'0x000000000000000000000000000000000000dead';