-- public.label_factor_seting_temp definition

-- Drop table
drop table if exists label_factor_seting_temp;
CREATE TABLE public.label_factor_seting_temp
(
    dict_code           varchar(100) NULL,
    dict_name           varchar(100) NULL,
    parent_id           int8 NULL,
    dict_level          int8 NULL,
    dict_type           varchar(100) NULL,
    created_at          timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    removed             bool NULL DEFAULT false,
    dict_describe       varchar(150) NULL,
    total_dict_describe varchar(150) NULL
) with (appendonly='true', compresstype=zstd, compresslevel='5');


INSERT INTO public.label_factor_seting_temp (dict_code,dict_name,dict_type)
select platform as dict_code,platform as dict_name,'asset_NFT' as dict_type
from  nft_sync_address_temp nsa   group by platform;

insert
into
    public.label_factor_seting_temp
(dict_code,
 dict_name,
 parent_id,
 dict_level,
 dict_type,
 dict_describe)
select
        symbol || '(' || substring (address ,
                                    1,
                                    8)|| ')' as dict_code,
        symbol as dict_name,
        8 as parent_id,
        2 as dict_level,
        'asset_Token' as dict_type,
        symbol || '(' || substring (address ,
                                    1,
                                    8)|| ')' as dict_describe
from
    top_token_1000_temp tt ;

INSERT INTO label_factor_seting_temp (dict_code,dict_name,dict_type)
select (lpt.symbol1||'/'||lpt.symbol2)||  '(' || SUBSTRING(lpt.pool, 1, 8)|| ')' as dict_code,
       lpt.factory_content as dict_name,'asset_LP' as dict_type
from  (select wlp.name,
              wlp.symbol_wired,
              wlp.address as pool,
              wlp.factory,
              wlp.factory_type,
              wlp.factory_content,
              wlp.pool_id,
              wlp.symbols[1] as symbol1,
              wlp.symbols[2] as symbol2,
              wlp.type,
              wlp.tokens,
              wlp.decimals,
              wlp.price,
              wlp.tvl,
              wlp.fee as fee,
              SUBSTR(wlp.address, 1, 6) as poolPrefix,
              wlp.total_supply,
              wslp.factory AS stakePool,
              wslp.factory_type as stakeRouter
       from white_list_lp_temp wlp
                left join white_list_lp_temp wslp on wlp.address = wslp.address and wlp.type = 'LP' and wslp.type = 'SLP'
       where wlp.tvl > 1000000
         and string_to_array(wlp.symbol_wired, '/') && array['ETH','WETH', 'UNI', 'AAVE', '1INCH', 'MANA', 'AXS', 'SAND']
        and wlp."type" = 'LP' ) lpt;
insert into tag_result(table_name,batch_date)  SELECT 'dim_label_factor_seting' as table_name,'${batchDate}'  as batch_date;
