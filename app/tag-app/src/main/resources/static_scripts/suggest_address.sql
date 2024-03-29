-----推荐地址表
-- drop table recommend_address;
CREATE TABLE public.recommend_address(
    batch_id bigint,----批次号id，从suggest_address_batch获取
    "address" varchar(2048) NOT NULL,------推荐地址集
    created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    config_environment varchar(64) NOT NULL,------环境字段：config_environment(dev,stag,prod)
    updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP
);

-- insert into suggest_address(batch_id,"address") values(1,'0xb6682297a79d260ff94355603d26c9a4be08a046');
-- insert into suggest_address(batch_id,"address") values(2,'0xb6681a65dc886cca60f2dd5a982fdbb0d8b83f1a');
