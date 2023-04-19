drop table if exists snapshot_eth_tx_record;
create table  snapshot_eth_tx_record
(
    block_hash   varchar(256) not null,
    block_number bigint       not null,
    hash         varchar(256) not null,
    tx_index     bigint       not null,
    log_index    varchar(50) not null,
    from_address varchar(256) not null,
    to_address   varchar(256),
    tx_type      varchar(64),
    amount       numeric(128, 30),
    fee          numeric(128, 30),
    created_at   timestamp default CURRENT_TIMESTAMP,
    updated_at   timestamp default CURRENT_TIMESTAMP,
    removed      boolean   default false
);

create index if not exists idx_etr_blocknumber
    on snapshot_eth_tx_record (block_number);

create index if not exists idx_etr_fromAddress
    on snapshot_eth_tx_record (from_address);

create index if not exists idx_etr_toAddress
    on snapshot_eth_tx_record (to_address);
truncate table snapshot_eth_tx_record;
vacuum snapshot_eth_tx_record;

insert into snapshot_eth_tx_record
(
    block_hash   ,
    block_number,
    hash         ,
    tx_index    ,
    log_index   ,
    from_address ,
    to_address,
    tx_type,
    amount,
    fee,
    created_at,
    updated_at,
    removed
) select block_hash   ,
         block_number,
         hash         ,
         tx_index    ,
         log_index   ,
         from_address ,
         to_address,
         tx_type,
         amount,
         fee,
         created_at,
         updated_at,
         removed from eth_tx_record;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
