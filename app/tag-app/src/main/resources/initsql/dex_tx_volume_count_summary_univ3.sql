drop table if exists dex_tx_volume_count_summary_univ3;
CREATE TABLE public.dex_tx_volume_count_summary_univ3 (
                                                          address varchar(256) NOT NULL,
                                                          "token" varchar(256) NOT NULL,
                                                          block_height int8 NOT NULL,
                                                          total_transfer_volume_usd numeric(125, 30) DEFAULT 0,
                                                          total_transfer_count int8 DEFAULT 0,
                                                          created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                          updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                          removed bool NULL DEFAULT false,
                                                          first_updated_block_height int8 NOT NULL DEFAULT 99999999,
                                                          transaction_hash varchar(100) NULL,
                                                          router varchar(150) NULL,
                                                          "type" varchar(10) NULL,
                                                          project varchar(100) NULL,
                                                          in_transfer_volume numeric(125, 30) NULL,
                                                          out_transfer_volume numeric(125, 30) NULL,
                                                          in_transfer_count int8 NULL,
                                                          out_transfer_count int8 NULL,
                                                          balance_usd numeric(125, 30) DEFAULT 0
) DISTRIBUTED BY (address);
truncate table dex_tx_volume_count_summary_univ3;
vacuum dex_tx_volume_count_summary_univ3;

---汇总UNIv3的LP数据
insert
into
    dex_tx_volume_count_summary_univ3(address,
                                      token,
                                      type,
                                      project,
                                      block_height,
                                      total_transfer_volume_usd,
                                      total_transfer_count,
                                      first_updated_block_height,
                                      balance_usd)
select
    th.address,
    th.token as token,
    th.type as type,
    '0xc36442b4a4522e871399cd717abdd847ab11fe88' as project,
    max(th.block_height) as block_height,
    sum(round(th.total_transfer_volume * round(cast(w.price as numeric), 18),3)) as total_transfer_volume_usd,
    sum(total_transfer_count) as total_transfer_count,
    min(first_updated_block_height) as first_updated_block_height,
    sum(round(th.balance * round(cast (w.price as numeric), 18),3)) as balance_usd
from
    token_holding_uni_cal th
        inner join (
        select
            *
        from
            white_list_erc20
        where
                address in (
                select
                    token_id
                from
                    dim_rank_token)) w on
            w.address = th.price_token
group by
    th.address,
    th.token,
    th.type;
insert into tag_result(table_name,batch_date)  SELECT 'dex_tx_volume_count_summary_univ3' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
