-- DROP TABLE public.token_volume_usd;
DROP TABLE IF EXISTS public.token_volume_usd;
CREATE TABLE public.token_volume_usd (
                                         address varchar(512) NULL,
                                         "token" varchar(512) NULL,
                                         volume_usd numeric NULL,
                                         created_at timestamp NULL,
                                         updated_at timestamp NULL,
                                         removed bool NULL
)
distributed by (token);
truncate table token_volume_usd;
insert
into
    token_volume_usd(address,
                     token,
                     volume_usd)
select
    eh.address as address,
    'eth' as token,
    eh.total_transfer_all_volume * round(cast(wle.price as numeric),3)  as volume_usd
from
    (select address,sum(total_transfer_all_volume) as total_transfer_all_volume  from eth_holding_vol_count  where total_transfer_all_volume>0
     group by address
    ) eh
        inner join (select price from white_list_erc20 where symbol = 'WETH'  group by price)  wle  on 1=1;


insert
into
    token_volume_usd(address,
                     token,
                     volume_usd)
select
    th.address,
    token,
    total_transfer_all_volume * round(cast(wle.price as numeric), 3) as volume_usd
from
    (
        select
            address,
            token,
            total_transfer_all_volume
        from
            token_holding_vol_count
        where
                total_transfer_all_volume>0
          and token in (
            select
                token_id
            from
                dim_rank_token)
        group by
            address,
            token,
            total_transfer_all_volume
    ) th
        inner join (
        select
            *
        from
            white_list_erc20
        where
                address in (
                select
                    token_id
                from
                    dim_rank_token)) wle on
                th.token = wle.address
            and ignored = false;


