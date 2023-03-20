DROP TABLE if EXISTS  static_total_data;
create table static_total_data
(
    address_num numeric(250, 20) NULL,
    individual_address_num numeric(250, 20) NULL,
    contract_address_num numeric(250, 20) NULL,
    defi_address_num numeric(250, 20) NULL,
    nft_address_num numeric(250, 20) NULL,
    web3_address_num numeric(250, 20) NULL,
    avg_balance numeric(250, 20) NULL,
    avg_volume numeric(250, 20) NULL,
    avg_activity numeric(250, 20) NULL,
    avg_birthday numeric(250, 20) NULL
);