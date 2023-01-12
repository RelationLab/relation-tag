
insert into nft_transfer_holding (address, token, total_transfer_volume, total_transfer_count)
    (select nh.address,
            nh.token,
            nh.total_transfer_all_volume - nh.total_transfer_mint_volume - nh.total_transfer_burn_volume - COALESCE(nbsh.total_transfer_buy_volume,0) - COALESCE(nbsh.total_transfer_sell_volume,0),
            nh.total_transfer_all_count - nh.total_transfer_mint_count - nh.total_transfer_burn_count - COALESCE(nbsh.total_transfer_buy_count,0) - COALESCE(nbsh.total_transfer_sell_count,0)
     from nft_holding nh
              left join nft_buy_sell_holding nbsh
                        on nh.address = nbsh.address
                            and nh.token = nbsh.token);
