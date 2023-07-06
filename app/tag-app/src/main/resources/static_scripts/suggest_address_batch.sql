-----推荐地址批次号表
-- drop table suggest_address_batch;
CREATE TABLE public.suggest_address_batch (
          batch_id bigserial NOT NULL,----批次号id,自动生成
          "name" varchar(64) NOT NULL,----批次名称，按指定规则生成 产品定哈
          ugc_label_data_analysis_id bigint, ----关联人群画像任务id
          status varchar(64) NULL DEFAULT 'TODO'::character varying, ------状态字段：status(TODO,DONE)
          config_environment varchar(64) NOT NULL,------环境字段：config_environment(dev,stag,prod)
          created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
          CONSTRAINT uidx_suggest_address_batch UNIQUE (batch_id, config_environment)
);
--
-- insert into suggest_address_batch( "name",config_environment)
-- values ('panpanceshi1','stag') ;
-- insert into suggest_address_batch( "name",config_environment)
-- values ('panpanceshi2','stag') ;