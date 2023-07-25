drop table if exists erc20_tx_record_filter;
CREATE TABLE public.erc20_tx_record_filter
(
    from_address          varchar(256) NULL,
    to_address            varchar(256) NULL,
    "token"               varchar(256) NULL,
    block_number          bigint NULL,
    total_transfer_volume numeric(125, 30) NULL,
    hash                  varchar(100) NULL
) distributed by (address,"token");
truncate table erc20_tx_record_filter;
vacuum
erc20_tx_record_filter;
insert into erc20_tx_record_filter(from_address,
                                   to_address,
                                   token,
                                   block_number,
                                   total_transfer_volume,
                                   hash)

select from_address,
       to_address,
       token,
       block_number as                              block_number,
       amount * round(cast(w.price as numeric), 18) total_transfer_volume,
       hash
from erc20_tx_record
         inner join (select white_list_erc20.*
                     from white_list_erc20
                              INNER JOIN (select address
                                          from top_token_1000 tt2
                                          where tt2.holders >= 100
                                            and removed <> true) top_token_1000
                                         ON (white_list_erc20.address = top_token_1000.address)) w on
    (w.address = erc20_tx_record.token)
where sender = from_address;
insert into erc20_tx_record_filter(from_address,
                                   to_address,
                                   token,
                                   block_number,
                                   total_transfer_volume,
                                   hash)
select from_address,
       to_address,
       token,
       block_number as                              block_number,
       amount * round(cast(w.price as numeric), 18) total_transfer_volume,
       hash
from erc20_tx_record
         inner join (select white_list_erc20.*
                     from white_list_erc20
                              INNER JOIN (select address
                                          from top_token_1000 tt2
                                          where tt2.holders >= 100
                                            and removed <> true) top_token_1000
                                         ON (white_list_erc20.address = top_token_1000.address)) w on
    (w.address = erc20_tx_record.token)
where sender = to_address;


insert into erc20_tx_record_filter(from_address,
                                   to_address,
                                   token,
                                   block_number,
                                   total_transfer_volume,
                                   hash)
select from_address,
       to_address,
       'eth'                                        token,
       block_number as                              block_number,
       amount * round(cast(w.price as numeric), 18) total_transfer_volume,
       hash
from (select * from eth_tx_record where tx_type = 'ETH_INTERNAL') eth_tx_record
         left join erc20_tx_record on (eth_tx_record.hash = erc20_tx_record.hash and
                                       (eth_tx_record.from_address = erc20_tx_record.sender))
         inner join white_list_erc20 w on (w.address = 'eth');

insert into erc20_tx_record_filter(from_address,
                                   to_address,
                                   token,
                                   block_number,
                                   total_transfer_volume,
                                   hash)
select from_address,
       to_address,
       'eth'                                        token,
       block_number as                              block_number,
       amount * round(cast(w.price as numeric), 18) total_transfer_volume,
       hash
from (select * from eth_tx_record where tx_type = 'ETH_INTERNAL') eth_tx_record
         left join erc20_tx_record on (eth_tx_record.hash = erc20_tx_record.hash and
                                       (eth_tx_record.to_address = erc20_tx_record.sender))
         inner join white_list_erc20 w on (w.address = 'eth');
insert into tag_result(table_name, batch_date)
SELECT 'erc20_tx_record_filter' as table_name, to_char(current_date, 'YYYY-MM-DD') as batch_date;

