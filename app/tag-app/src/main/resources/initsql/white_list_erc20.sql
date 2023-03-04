-- DROP TABLE IF EXISTS public.white_list_erc20_temp;
-- CREATE TABLE public.white_list_erc20_temp as
-- select * from white_list_erc20;
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
--  		white_list_erc20 wa
--  	inner join(
--  		select
--  			max(updated_at) as updated_at,
--  			wlet.symbol,wlet."name"
--  		from
--  			white_list_erc20 wlet
--  		group by
--  			wlet.symbol,wlet."name") wb on
--  		(wa.symbol = wb.symbol
--  			and wa.updated_at = wb.updated_at)) A
-- where
--     b.symbol = A.symbol and b."name"  = A.name and b.is_lp is false;

DROP TABLE IF EXISTS public.white_list_erc20;
CREATE TABLE public.white_list_erc20 as
select * from white_list_erc20_temp;

DROP TABLE IF EXISTS public.white_list_erc20_tag;
CREATE TABLE public.white_list_erc20_tag as
select * from white_list_erc20;