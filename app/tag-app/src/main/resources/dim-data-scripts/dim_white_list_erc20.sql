-- DROP TABLE IF EXISTS public.white_list_erc20_temp;
-- CREATE TABLE public.white_list_erc20_temp as
-- select * from white_list_erc20_temp;
-- update
--     white_list_erc20_temp b
-- set
--     price = A.price
--     from
--  	(
--  	select
--  		wa.symbol,
--  		wa.name,
--  		wa.price
--  	from
--  		white_list_erc20_temp wa
--  	inner join(
--  		select
--  			max(updated_at) as updated_at,
--  			wlet.symbol,wlet."name"
--  		from
--  			white_list_erc20_temp wlet
--  		group by
--  			wlet.symbol,wlet."name") wb on
--  		(wa.symbol = wb.symbol
--  			and wa.updated_at = wb.updated_at)) A
-- where
--     b.symbol = A.symbol and b."name"  = A.name and b.is_lp is false;

DROP TABLE IF EXISTS public.white_list_erc20_temp;
CREATE TABLE public.white_list_erc20_temp as
select * from white_list_price_temp_cdc;
delete from white_list_erc20_temp where type='SLP';
DROP TABLE IF EXISTS public.white_list_erc20_tag_temp;
CREATE TABLE public.white_list_erc20_tag_temp as
select * from white_list_erc20_temp;

update dim_project_token_type_temp set project='0x1111111254fb6c44bac0bed2854e76f90643097d' where project='0x1111111254fb6c44bAC0beD2854e76F90643097d';
update dim_project_token_type_rank_temp set project='0x1111111254fb6c44bac0bed2854e76f90643097d' where project='0x1111111254fb6c44bAC0beD2854e76F90643097d';
insert into tag_result(table_name,batch_date)  SELECT 'dim_white_list_erc20' as table_name,'${batchDate}'  as batch_date;
