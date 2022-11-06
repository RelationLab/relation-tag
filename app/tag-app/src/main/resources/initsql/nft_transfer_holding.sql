DROP TABLE if EXISTS public.nft_transfer_holding;
create table nft_transfer_holding
(
    id                    bigserial,
    address               varchar(512) not null,
    token                 varchar(512) not null,
    total_transfer_volume bigint       not null,
    total_transfer_count  bigint,
    created_at            timestamp default CURRENT_TIMESTAMP,
    updated_at            timestamp default CURRENT_TIMESTAMP,
    removed               boolean   default false
);
insert into nft_transfer_holding (address, token, total_transfer_volume, total_transfer_count)
    (select nh.address,
            nh.token,
            nh.total_transfer_all_volume - nh.total_transfer_mint_volume - nh.total_transfer_burn_volume - COALESCE(nbsh.total_transfer_buy_volume,0) - COALESCE(nbsh.total_transfer_sell_volume,0),
            nh.total_transfer_all_count - nh.total_transfer_mint_count - nh.total_transfer_burn_count - COALESCE(nbsh.total_transfer_buy_count,0) - COALESCE(nbsh.total_transfer_sell_count,0)
     from nft_holding nh
              left join nft_buy_sell_holding nbsh
                        on nh.address = nbsh.address
                            and nh.token = nbsh.token)