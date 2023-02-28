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
distributed by (address);
truncate table token_volume_usd;
insert
    into
    token_volume_usd(address,
                     token,
                     volume_usd)
    select
    distinct eh.address as address,
             'eth' as token,
             eh.total_transfer_all_volume * round(wle.price,3)  as volume_usd
    from
    eth_holding_vol_count eh
        inner join (select * from white_list_erc20 where symbol = 'WETH')  wle
    where eh.total_transfer_all_volume>0;
insert
into
    token_volume_usd(address,
                     token,
                     volume_usd)
select
    distinct th.address,
             token,
             total_transfer_all_volume * round(wle.price,3) as volume_usd
from
    token_holding_vol_count th
        inner join (select * from white_list_erc20 where address  in (
        select
            token_id
        from
            dim_rank_token)) wle on
                th.token = wle.address
            and ignored = false
where
     th.total_transfer_all_volume>0
  and th.token in (
    select
        token_id
    from
        dim_rank_token);


