drop table if exists snapshot_token_holding_time;

CREATE TABLE public.snapshot_token_holding_time (
                                           address varchar(42) NULL,
                                           "token" varchar(42) NULL,
                                           counter int8 NULL DEFAULT 0,
                                           first_tx_time timestamp NULL,
                                           latest_tx_time timestamp NULL,
                                           updated_block_height int8 NULL,
                                           balance numeric(125) NULL,
                                           created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                           updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                           removed bool NULL DEFAULT false
)distributed by (address, token);
truncate table snapshot_token_holding_time;
vacuum snapshot_token_holding_time;
insert into snapshot_token_holding_time(address,
                               "token",
                               counter,
                               first_tx_time,
                               latest_tx_time,
                               updated_block_height,
                               balance ,
                               created_at ,
                               updated_at ,
                               removed )
select address,
       "token",
       counter,
       first_tx_time,
       latest_tx_time,
       updated_block_height,
       balance ,
       created_at ,
       updated_at ,
       removed from token_holding_time;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

