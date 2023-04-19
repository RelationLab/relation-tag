drop table if exists snapshot_nft_holding_time;

CREATE TABLE public.snapshot_nft_holding_time (
                                         address varchar(42) NULL,
                                         "token" varchar(42) NULL,
                                         latest_tx_time int8 NULL,
                                         balance int8 NULL,
                                         created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                         updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                         removed bool NULL DEFAULT false,
                                         first_tx_time int8 NULL
)distributed by (address, token);

truncate table snapshot_nft_holding_time;
vacuum snapshot_nft_holding_time;
insert into snapshot_nft_holding_time(address ,
                             "token" ,
                             latest_tx_time ,
                             balance ,
                             created_at,
                             updated_at,
                             removed ,
                             first_tx_time )
select address ,
       "token" ,
       latest_tx_time ,
       balance ,
       created_at,
       updated_at,
       removed ,
       first_tx_time from nft_holding_time;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
