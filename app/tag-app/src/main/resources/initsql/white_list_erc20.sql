-- public.white_list_erc20_tag definition

-- Drop table

-- DROP TABLE public.white_list_erc20_tag;

-- public.white_list_erc20 definition

-- Drop table

-- DROP TABLE public.white_list_erc20;
DROP TABLE IF EXISTS public.white_list_erc20_temp;
CREATE TABLE public.white_list_erc20_temp as
select * from white_list_erc20;
update
    white_list_erc20 b
set
    price = A.price
    from
	(
	select
		wa.symbol,
		wa.price
	from
		white_list_erc20_temp wa
	inner join(
		select
			max(updated_at) as updated_at,
			wlet.symbol
		from
			white_list_erc20_temp wlet
		group by
			wlet.symbol) wb on
		(wa.symbol = wb.symbol
			and wa.updated_at = wb.updated_at)) A
where
    b.symbol = A.symbol;


DROP TABLE IF EXISTS public.white_list_erc20_tag;
CREATE TABLE public.white_list_erc20_tag as
select * from white_list_erc20;