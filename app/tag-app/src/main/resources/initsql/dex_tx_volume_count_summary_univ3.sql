drop table if exists dex_tx_volume_count_summary_univ3;
CREATE TABLE public.dex_tx_volume_count_summary_univ3 (
                                                    id bigserial NOT NULL,
                                                    address varchar(256) NOT NULL,
                                                    "token" varchar(256) NOT NULL,
                                                    block_height int8 NOT NULL,
                                                    total_transfer_volume_usd numeric(125, 30) NOT NULL DEFAULT 0,
                                                    total_transfer_count int8 NOT NULL DEFAULT 0,
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
                                                    balance_usd numeric(125, 30) NOT NULL DEFAULT 0,
                                                    CONSTRAINT dex_tx_volume_count_summary_univ3_pkey PRIMARY KEY (id),
                                                    CONSTRAINT dex_tx_volume_count_summary_univ3_un UNIQUE (address, token, type, project)
);

CREATE INDEX dex_tx_volume_count_summary_univ3_address_idx ON public.dex_tx_volume_count_summary_univ3 USING btree (address);
CREATE INDEX dex_tx_volume_count_summary_univ3_balance_usd_idx ON public.dex_tx_volume_count_summary_univ3 USING btree (balance_usd);
CREATE INDEX dex_tx_volume_count_summary_univ3_project_idx ON public.dex_tx_volume_count_summary_univ3 USING btree (project);
CREATE INDEX dex_tx_volume_count_summary_univ3_token_idx ON public.dex_tx_volume_count_summary_univ3 USING btree (token);
CREATE INDEX dex_tx_volume_count_summary_univ3_total_transfer_volume_usd_idx ON public.dex_tx_volume_count_summary_univ3 USING btree (total_transfer_volume_usd);

    insert
    into
    dex_tx_volume_count_summary_univ3 (address,
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
    th.token,
    th.type as type,
    '0xc36442b4a4522e871399cd717abdd847ab11fe88' as project,
    max(th.block_height) as block_height,
    sum(th.total_transfer_volume * w.price) as total_transfer_volume_usd,
    sum(total_transfer_count) as total_transfer_count,
    min(first_updated_block_height) as first_updated_block_height,
    sum(th.balance * w.price) as balance_usd
    from
    token_holding_uni th
        inner join white_list_erc20 w on
            w.address = th.price_token
    where
    (th.balance >= 0
        and th.total_transfer_volume >= 0)
    group by
    th.address,
    th.token,
    th.type