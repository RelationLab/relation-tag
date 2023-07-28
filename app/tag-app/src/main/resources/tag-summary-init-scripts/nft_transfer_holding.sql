DROP TABLE if EXISTS public.nft_transfer_holding_temp;
create table nft_transfer_holding_temp
(
    id                    bigserial,
    address               varchar(512) not null,
    token                 varchar(512) not null,
    total_transfer_volume bigint       not null,
    total_transfer_count  bigint,
    created_at            timestamp default CURRENT_TIMESTAMP,
    updated_at            timestamp default CURRENT_TIMESTAMP,
    recent_time_code           varchar(30) NULL
)distributed by (address,"token",recent_time_code);
truncate table nft_transfer_holding_temp;
vacuum nft_transfer_holding_temp;

insert into nft_transfer_holding_temp (address, token, total_transfer_volume, total_transfer_count,recent_time_code)
    (select nh.address,
            nh.token,
            nh.total_transfer_all_volume - nh.total_transfer_mint_volume - nh.total_transfer_burn_volume - COALESCE(nbsh.total_transfer_buy_volume,0) - COALESCE(nbsh.total_transfer_sell_volume,0),
            nh.total_transfer_all_count - nh.total_transfer_mint_count - nh.total_transfer_burn_count - COALESCE(nbsh.total_transfer_buy_count,0) - COALESCE(nbsh.total_transfer_sell_count,0),
            nh.recent_time_code
     from nft_holding_temp nh
              left join nft_buy_sell_holding_temp nbsh
                        on nh.address = nbsh.address
                            and nh.token = nbsh.token and nh.recent_time_code=nbsh.recent_time_code);
insert into tag_result(table_name,batch_date)  SELECT 'nft_transfer_holding' as table_name,'${batchDate}'  as batch_date;

