-----推荐地址表
CREATE TABLE public.suggest_address(
      batch_id bigint NOT NULL,
      "address" varchar(2048) NOT NULL,
      created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
      updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP
);

insert into suggest_address(batch_id,"address") values(2,'0xb6681a65dc886cca60f2dd5a982fdbb0d8b83f1a');
insert into suggest_address(batch_id,"address") values(3,'0xb6681d712cf227020fa28e7fe40c8692e21dec99');
