-- public.ugc_label_data_analysis definition

-- Drop table

DROP TABLE public.ugc_label_data_analysis;

CREATE TABLE public.ugc_label_data_analysis (
                                                id bigserial NOT NULL,
                                                "name" varchar(2048) NOT NULL,
                                                address varchar(256) NOT NULL,
                                                api_level varchar(256) NOT NULL,
                                                "mode" varchar(64) NOT NULL,
                                                labels text NOT NULL,
                                                status varchar(64) NULL DEFAULT 'TO_DO'::character varying,
                                                analysis_result text NULL,
                                                created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                                removed bool NULL DEFAULT false,
                                                analysis_at timestamp NULL,
                                                config_environment varchar(64) NOT NULL,
                                                analysis_address_num int8 NULL,
                                                address_image_text jsonb NULL,
                                                CONSTRAINT uidx_data_analysis_id_config_environment UNIQUE (id, config_environment)
);
