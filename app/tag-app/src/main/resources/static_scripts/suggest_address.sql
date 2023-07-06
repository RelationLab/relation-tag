-----推荐地址表
CREATE TABLE public.suggest_address(
      batch_id bigint NOT NULL,
      "address" varchar(2048) NOT NULL,
      created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP
);