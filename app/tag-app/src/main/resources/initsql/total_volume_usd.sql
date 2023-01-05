

insert into total_balance_volume_usd(address, volume_usd)
    (select address,  sum(volume_usd) from token_volume_usd group by address);