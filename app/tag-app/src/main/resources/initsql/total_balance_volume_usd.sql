

insert into total_balance_volume_usd(address, balance_usd, volume_usd, "balance_level")
     (SELECT address, total_balance, total_volume,
      case
      	when total_balance >= 100
      			and total_balance < 1000 then 'L1'
      	when total_balance >= 1000
      			and total_balance < 10000 then 'L2'
      	when total_balance >= 10000
      			and total_balance < 50000 then 'L3'
      	when sum(balance_usd) >= 50000
      			and total_balance < 100000 then 'L4'
      	when sum(balance_usd) >= 100000
      			and total_balance < 500000 then 'L5'
      	when total_balance >= 500000
      			and total_balance < 1000000 then 'L6'
      	when total_balance >= 1000000
      			and total_balance < 1000000000 then 'Millionaire'
      	when total_balance >= 1000000000 then 'Billionaire'
      end as "balance_level"
      from (
          select address, sum(balance_usd) as total_balance, sum(volume_usd) as total_volume
          from token_balance_volume_usd where address is not null group by address) a
      );
