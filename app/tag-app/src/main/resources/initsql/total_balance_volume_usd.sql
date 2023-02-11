

insert into total_balance_volume_usd(address, balance_usd, volume_usd)
     (select address, sum(balance_usd), sum(volume_usd) from token_balance_volume_usd where address is not null group by address);
