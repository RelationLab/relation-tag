drop table if exists snapshot_erc20_tx_record;
CREATE TABLE public.snapshot_erc20_tx_record (
                                                 block_hash varchar(256) NOT NULL,
                                                 block_number int8 NOT NULL,
                                                 hash varchar(256) NOT NULL,
                                                 tx_index int8 NOT NULL,
                                                 log_index int8 NOT NULL,
                                                 from_address varchar(256) NOT NULL,
                                                 to_address varchar(256) NOT NULL,
                                                 "token" varchar(256) NOT NULL,
                                                 amount numeric(128, 30) NULL,
                                                 created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                 updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                 removed bool NULL DEFAULT false
) distributed by (token);
CREATE INDEX snapshot_erc20_tx_record_from_address_token_index ON public.snapshot_erc20_tx_record USING btree (from_address, token);
CREATE INDEX snapshot_erc20_tx_record_to_address_token_index ON public.snapshot_erc20_tx_record USING btree (to_address, token);
CREATE INDEX idx_e20tr_blocknumber ON public.snapshot_erc20_tx_record USING btree (block_number);
CREATE INDEX idx_e20tr_fromaddress ON public.snapshot_erc20_tx_record USING btree (from_address);
CREATE INDEX idx_e20tr_toaddress ON public.snapshot_erc20_tx_record USING btree (to_address);
CREATE INDEX idx_e20tr_token ON public.snapshot_erc20_tx_record USING btree (token);
truncate table snapshot_erc20_tx_record;
vacuum snapshot_erc20_tx_record;

insert into public.snapshot_erc20_tx_record (
    block_hash ,
    block_number,
    hash ,
    tx_index,
    log_index,
    from_address ,
    to_address ,
    "token" ,
    amount,
    created_at,
    updated_at,
    removed
) select  block_hash ,
          block_number,
          hash ,
          tx_index,
          log_index,
          from_address ,
          to_address ,
          "token" ,
          amount,
          created_at,
          updated_at,
          removed from erc20_tx_record;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
