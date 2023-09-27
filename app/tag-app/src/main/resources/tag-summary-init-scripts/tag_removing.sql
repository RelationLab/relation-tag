insert into tag_result(table_name,batch_date)  SELECT 'tag_removing_${tableSuffix}' as table_name,'${batchDate}'  as batch_date;
