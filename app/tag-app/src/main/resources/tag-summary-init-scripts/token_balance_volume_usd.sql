
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
);
truncate table token_balance_volume_usd;
vacuum token_balance_volume_usd;

insert into token_balance_volume_usd(address, token, balance_usd, volume_usd)
select  address,token,balance_usd,volume_usd from (select distinct eh.address as address, 'eth' as token, eh.balance * price as balance_usd ,
                eh.total_transfer_all_volume* price as volume_usd from eth_holding eh
         inner join white_list_erc20 wle on symbol='WETH' ) budOut where budOut.balance_usd>=100;

insert into token_balance_volume_usd(address, token, balance_usd, volume_usd)
select address,token,balance_usd,volume_usd from  (select distinct th.address, token, th.balance * price as balance_usd, total_transfer_all_volume* price as volume_usd
   from token_holding th  inner join white_list_erc20 wle  on th.token = wle.address and ignored = false where  th.token in (select token_id from dim_rank_token)) budout
 where budOut.balance_usd>=100;

insert into tag_result(table_name,batch_date)  SELECT 'token_balance_volume_usd' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
