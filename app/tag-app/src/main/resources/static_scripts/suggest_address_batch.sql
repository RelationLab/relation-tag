-----推荐地址批次号表
drop table suggest_address_batch;
CREATE TABLE public.suggest_address_batch (
          batch_id bigserial NOT NULL,
          "name" varchar(64) NOT NULL,
          ugc_label_data_analysis_id bigint,
          status varchar(64) NULL DEFAULT 'TO_DO'::character varying, ------status(TODO,DONE)
          config_environment varchar(64) NOT NULL,------config_environment(dev,stag,prod)
          created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
          CONSTRAINT uidx_suggest_address_batch UNIQUE (batch_id, config_environment)
);