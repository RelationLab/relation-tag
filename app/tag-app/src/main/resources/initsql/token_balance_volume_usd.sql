drop table if exists token_balance_volume_usd;
create table public.token_balance_volume_usd
(
    address varchar(512) not null,
    token varchar(512) not null,
    balance_usd numeric,
    volume_usd numeric,
    created_at timestamp default CURRENT_TIMESTAMP,
    updated_at timestamp default now(),
    removed boolean default false
)    DISTRIBUTED BY (address);

insert into token_balance_volume_usd(address, token, balance_usd, volume_usd)
    (select eh.address, 'eth', eh.balance * price, eh.total_transfer_all_volume* price from eth_holding eh
     left join white_list_erc20 wle on symbol='WETH' where (eh.balance > 0.04 or eh.total_transfer_all_volume>0));

insert into token_balance_volume_usd(address, token, balance_usd, volume_usd)
    (select th.address, token, th.balance * price, total_transfer_all_volume* price from token_holding th
    inner join white_list_erc20 wle on th.token = wle.address and ignored = false where
   (th.balance > 0 or th.total_transfer_all_volume>0));