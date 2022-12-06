drop table if exists dex_tx_volume_count_summary;
CREATE TABLE public.dex_tx_volume_count_summary (
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
                                                    CONSTRAINT dex_tx_volume_count_summary_un UNIQUE (address, token, type, project)
);

CREATE INDEX dex_tx_volume_count_summary_address_idx ON public.dex_tx_volume_count_summary USING btree (address);
CREATE INDEX dex_tx_volume_count_summary_balance_usd_idx ON public.dex_tx_volume_count_summary USING btree (balance_usd);
CREATE INDEX dex_tx_volume_count_summary_project_idx ON public.dex_tx_volume_count_summary USING btree (project);
CREATE INDEX dex_tx_volume_count_summary_token_idx ON public.dex_tx_volume_count_summary USING btree (token);
CREATE INDEX dex_tx_volume_count_summary_total_transfer_volume_usd_idx ON public.dex_tx_volume_count_summary USING btree (total_transfer_volume_usd);

insert
    into
    dex_tx_volume_count_summary(address,
                                token,
                                type,
                                project,
                                block_height,
                                total_transfer_volume_usd,
                                total_transfer_count,
                                first_updated_block_height,
                                balance_usd)
    select
    dtvcr.address,
    token,
    type,
    project,
    max(block_height) block_height,
    sum(total_transfer_volume * w.price) total_transfer_volume_usd,
    sum(total_transfer_count) total_transfer_count,
    min(first_updated_block_height) first_updated_block_height,
    sum(balance * w.price) balance_usd
    from
    dex_tx_volume_count_record dtvcr
        inner join white_list_erc20 w on
            w.address = dtvcr."token"
    group by
    dtvcr.address,
    token,
    type,
    project