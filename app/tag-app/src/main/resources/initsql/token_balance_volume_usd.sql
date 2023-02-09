
insert into token_balance_volume_usd(address, token, balance_usd, volume_usd, balance_level)
select address, token, balance_usd, volume_usd,
case
      	when total_balance >= 100
      			and total_balance < 1000 then 'L1'
      	when total_balance >= 1000
      			and total_balance < 10000 then 'L2'
      	when total_balance >= 10000
      			and total_balance < 50000 then 'L3'
      	when total_balance >= 50000
      			and total_balance < 100000 then 'L4'
      	when total_balance >= 100000
      			and total_balance < 500000 then 'L5'
      	when total_balance >= 500000
      			and total_balance < 1000000 then 'L6'
      	when total_balance >= 1000000
      			and total_balance < 1000000000 then 'Millionaire'
      	when total_balance >= 1000000000 then 'Billionaire'
      end as "balance_level"
from (
    select distinct eh.address as address, 'eth' as token, eh.balance * price as balance_usd, eh.total_transfer_all_volume * price as volume_usd
    from eth_holding eh
    inner join white_list_erc20 wle on symbol='WETH'
    where eh.balance > 0 or eh.total_transfer_all_volume>0
);


insert into token_balance_volume_usd(address, token, balance_usd, volume_usd)
select distinct th.address, token, th.balance * price as balance_usd, total_transfer_all_volume* price as volume_usd
from token_holding th
inner join white_list_erc20 wle  on th.token = wle.address and ignored = false
where (th.balance > 0 or th.total_transfer_all_volume>0) and th.token in (select token_id from dim_rank_token);


