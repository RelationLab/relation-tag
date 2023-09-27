insert into tag_result(table_name,batch_date)  SELECT 'tag_removed_${tableSuffix}' as table_name,'${batchDate}'  as batch_date;
delete from tag_result where batch_date<'${batchDate}';

