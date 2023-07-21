-- public.combination definition

-- Drop table

-- DROP TABLE public.combination;
drop table if exists combination;

CREATE TABLE public.combination (
                                    asset varchar(100) NULL,
                                    project varchar(100) NULL,
                                    trade_type varchar(100) NULL,
                                    balance varchar(100) NULL,
                                    volume varchar(100) NULL,
                                    activity varchar(100) NULL,
                                    hold_time varchar(100) NULL,
                                    created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                    updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                    removed bool NULL DEFAULT false,
                                    label_name text NULL,
                                    "content" varchar(100) NULL,
                                    asset_type varchar(50) NULL,
                                    label_category varchar(50) NULL
);
CREATE INDEX combination_idx_label_name ON public.combination USING btree (label_name);
update nft_sync_address set platform='CryptoPunks' where  address='0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb';
insert into tag_result(table_name,batch_date)  SELECT 'combination' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
