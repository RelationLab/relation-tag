drop table if exists nft_balance_usd_temp;
create table public.nft_balance_usd_temp
(
    address varchar(512) not null,
    token varchar(512) not null,
    balance_usd numeric,
    created_at timestamp default CURRENT_TIMESTAMP,
    updated_at timestamp default now()
)with (appendonly='true', compresstype=zstd, compresslevel='5')
    distributed by (address,"token");
truncate table nft_balance_usd_temp;
vacuum nft_balance_usd_temp;

insert into nft_balance_usd_temp(address, token, balance_usd)
select  address,token,sum(balance_usd) as balance_usd
from (select distinct eh.operator as address, token,
                      case when eh.type='DEPOSIT' then eh.quote_value * price
                           else 0-eh.quote_value * price end
                                  as balance_usd
      from platform_deposit_withdraw_tx_record eh
               inner join white_list_erc20_temp wle on symbol='WETH' ) budOut
group by address,token ;

insert into tag_result(table_name,batch_date)  SELECT 'total_nft_balance_usd' as table_name,'${batchDate}'  as batch_date;

