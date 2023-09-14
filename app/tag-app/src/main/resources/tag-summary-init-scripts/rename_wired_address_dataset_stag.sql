DROP TABLE IF EXISTS wired_address_dataset;
ALTER TABLE wired_address_dataset_temp                       RENAME TO wired_address_dataset;
insert into tag_result(table_name,batch_date)  SELECT 'rename_wired_address_dataset_{tableSuffix}' as table_name,'${batchDate}'  as batch_date;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;
