

insert into total_volume_usd(address, volume_usd)
    (select address,  sum(volume_usd) from token_volume_usd where address is not null group by address);