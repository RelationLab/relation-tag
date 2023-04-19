drop table if exists snapshot_eth_holding_time;
CREATE TABLE public.snapshot_eth_holding_time (
                                         address varchar(42) NULL,
                                         latest_tx_time int8 NULL,
                                         balance numeric(128, 30) NULL,
                                         created_at timestamp NULL,
                                         updated_at timestamp NULL,
                                         removed bool NULL,
                                         first_tx_time int8 NULL
) distributed by (address);
truncate table snapshot_eth_holding_time;
vacuum snapshot_eth_holding_time;
insert into snapshot_eth_holding_time(
    address ,
    latest_tx_time ,
    balance ,
    created_at ,
    updated_at ,
    removed ,
    first_tx_time
)  select    address ,
             latest_tx_time ,
             balance ,
             created_at ,
             updated_at ,
             removed ,
             first_tx_time
from eth_holding_time;
insert into tag_result(table_name,batch_date)  SELECT 'snapshot_table' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
