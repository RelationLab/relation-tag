DROP TABLE IF EXISTS address_label_gp_${tableSuffix};
ALTER TABLE address_label_gp_temp_${tableSuffix}                    RENAME TO address_label_gp_${tableSuffix};
DROP TABLE IF EXISTS address_labels_json_gin_${tableSuffix};
ALTER TABLE address_labels_json_gin_temp_${tableSuffix}              RENAME TO address_labels_json_gin_${tableSuffix} ;
insert into tag_result(table_name,batch_date)  SELECT 'rename_table_${tableSuffix}' as table_name,'${batchDate}'  as batch_date;
delete from  tag_result where  table_name='tagging';
delete  from tag_result where table_name='tag-begin'
delete from tag_result where batch_date<'${batchDate}';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;