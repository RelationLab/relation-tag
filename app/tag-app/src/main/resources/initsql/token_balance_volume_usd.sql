
insert into token_balance_volume_usd(address, token, balance_usd, volume_usd)
select distinct eh.address as address, 'eth' as token, eh.balance * price asbalance_usd , eh.total_transfer_all_volume* price as volume_usd from eth_holding eh
                                                                                                                                                     inner join white_list_erc20 wle on symbol='WETH' where eh.balance > 0 or eh.total_transfer_all_volume>0;
insert into token_balance_volume_usd(address, token, balance_usd, volume_usd)
select distinct th.address, token, th.balance * price as balance_usd, total_transfer_all_volume* price as volume_usd from token_holding th
                                                                                                                              inner join white_list_erc20 wle  on th.token = wle.address and ignored = false where
    (th.balance > 0 or th.total_transfer_all_volume>0) and th.token in (select token_id from dim_rank_token);


