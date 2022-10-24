drop table if exists address_label_token_project_type_balance_grade;
drop table if exists address_label_token_project_type_count_grade;
drop table if exists address_label_token_project_type_volume_grade;
drop table if exists address_label_token_project_time_top;
drop table if exists address_label_token_project_type_volume_rank;
drop table if exists address_label_nft_project_type_count_grade;
drop table if exists address_label_nft_project_type_volume_grade;
drop table if exists address_label_nft_project_type_volume_count_rank;
drop table if exists address_label_nft_project_type_volume_rank;
drop table if exists address_label_nft_project_type_volume_top;
drop table if exists address_label_nft_balance_grade;
drop table if exists address_label_nft_count_grade;
drop table if exists address_label_nft_time_grade;
drop table if exists address_label_nft_volume_grade;
drop table if exists address_label_nft_balance_rank;
drop table if exists address_label_nft_balance_top;
drop table if exists address_label_nft_time_rank;
drop table if exists address_label_nft_time_top;
drop table if exists address_label_nft_volume_count_rank;
drop table if exists address_label_nft_volume_rank;
drop table if exists address_label_nft_volume_top;
drop table if exists address_label_nft_transfer_count_grade;
drop table if exists address_label_nft_transfer_volume_grade;
drop table if exists address_label_nft_transfer_volume_count_rank;
drop table if exists address_label_nft_transfer_volume_rank;
drop table if exists address_label_nft_transfer_volume_top;
drop table if exists address_label_eth_count_grade;
drop table if exists address_label_token_balance_grade;
drop table if exists address_label_token_count_grade;
drop table if exists address_label_token_time_grade;
drop table if exists address_label_token_volume_grade;
drop table if exists address_label_eth_balance_rank;
drop table if exists address_label_eth_volume_rank;
drop table if exists address_label_time_special;
drop table if exists address_label_token_balance_provider;
drop table if exists address_label_token_balance_rank;
drop table if exists address_label_token_balance_staked;
drop table if exists address_label_token_balance_top;
drop table if exists address_label_token_time_first_lp;
drop table if exists address_label_token_time_first_stake;
drop table if exists address_label_token_volume_rank;
drop table if exists address_label_usdt_balance_rank;
drop table if exists address_label_usdt_volume_rank;
drop table if exists address_label_web3_type_balance_grade;
drop table if exists address_label_web3_type_count_grade;
drop table if exists address_label_web3_type_balance_rank;
drop table if exists address_label_web3_type_balance_top;
CREATE TABLE public.address_label_token_project_type_balance_grade (
                                                                       distributed_key varchar(256) NULL,
                                                                       address varchar(512) NULL,
                                                                       label_type varchar(512) NULL,
                                                                       label_name varchar(1024) NULL,
                                                                       updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_project_type_count_grade (
                                                                         distributed_key varchar(256) NULL,
                                                                         address varchar(512) NULL,
                                                                         label_type varchar(512) NULL,
                                                                         label_name varchar(1024) NULL,
                                                                         updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_project_type_volume_grade (
                                                                          distributed_key varchar(256) NULL,
                                                                          address varchar(512) NULL,
                                                                          label_type varchar(512) NULL,
                                                                          label_name varchar(1024) NULL,
                                                                          updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_project_time_top (
                                                                 distributed_key varchar(256) NULL,
                                                                 address varchar(512) NULL,
                                                                 label_type varchar(512) NULL,
                                                                 label_name varchar(1024) NULL,
                                                                 updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_project_type_volume_rank (
                                                                         distributed_key varchar(256) NULL,
                                                                         address varchar(512) NULL,
                                                                         label_type varchar(512) NULL,
                                                                         label_name varchar(1024) NULL,
                                                                         updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_project_type_count_grade (
                                                                       distributed_key varchar(256) NULL,
                                                                       address varchar(512) NULL,
                                                                       label_type varchar(512) NULL,
                                                                       label_name varchar(1024) NULL,
                                                                       updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_project_type_volume_grade (
                                                                        distributed_key varchar(256) NULL,
                                                                        address varchar(512) NULL,
                                                                        label_type varchar(512) NULL,
                                                                        label_name varchar(1024) NULL,
                                                                        updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_project_type_volume_count_rank (
                                                                             distributed_key varchar(256) NULL,
                                                                             address varchar(512) NULL,
                                                                             label_type varchar(512) NULL,
                                                                             label_name varchar(1024) NULL,
                                                                             updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_project_type_volume_rank (
                                                                       distributed_key varchar(256) NULL,
                                                                       address varchar(512) NULL,
                                                                       label_type varchar(512) NULL,
                                                                       label_name varchar(1024) NULL,
                                                                       updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_project_type_volume_top (
                                                                      distributed_key varchar(256) NULL,
                                                                      address varchar(512) NULL,
                                                                      label_type varchar(512) NULL,
                                                                      label_name varchar(1024) NULL,
                                                                      updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_balance_grade (
                                                            distributed_key varchar(256) NULL,
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_count_grade (
                                                          distributed_key varchar(256) NULL,
                                                          address varchar(512) NULL,
                                                          label_type varchar(512) NULL,
                                                          label_name varchar(1024) NULL,
                                                          updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_time_grade (
                                                         distributed_key varchar(256) NULL,
                                                         address varchar(512) NULL,
                                                         label_type varchar(512) NULL,
                                                         label_name varchar(1024) NULL,
                                                         updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_volume_grade (
                                                           distributed_key varchar(256) NULL,
                                                           address varchar(512) NULL,
                                                           label_type varchar(512) NULL,
                                                           label_name varchar(1024) NULL,
                                                           updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_balance_rank (
                                                           distributed_key varchar(256) NULL,
                                                           address varchar(512) NULL,
                                                           label_type varchar(512) NULL,
                                                           label_name varchar(1024) NULL,
                                                           updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_balance_top (
                                                          distributed_key varchar(256) NULL,
                                                          address varchar(512) NULL,
                                                          label_type varchar(512) NULL,
                                                          label_name varchar(1024) NULL,
                                                          updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_time_rank (
                                                        distributed_key varchar(256) NULL,
                                                        address varchar(512) NULL,
                                                        label_type varchar(512) NULL,
                                                        label_name varchar(1024) NULL,
                                                        updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_time_top (
                                                       distributed_key varchar(256) NULL,
                                                       address varchar(512) NULL,
                                                       label_type varchar(512) NULL,
                                                       label_name varchar(1024) NULL,
                                                       updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_volume_count_rank (
                                                                distributed_key varchar(256) NULL,
                                                                address varchar(512) NULL,
                                                                label_type varchar(512) NULL,
                                                                label_name varchar(1024) NULL,
                                                                updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_volume_rank (
                                                          distributed_key varchar(256) NULL,
                                                          address varchar(512) NULL,
                                                          label_type varchar(512) NULL,
                                                          label_name varchar(1024) NULL,
                                                          updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_volume_top (
                                                         distributed_key varchar(256) NULL,
                                                         address varchar(512) NULL,
                                                         label_type varchar(512) NULL,
                                                         label_name varchar(1024) NULL,
                                                         updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_transfer_count_grade (
                                                                   distributed_key varchar(256) NULL,
                                                                   address varchar(512) NULL,
                                                                   label_type varchar(512) NULL,
                                                                   label_name varchar(1024) NULL,
                                                                   updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_transfer_volume_grade (
                                                                    distributed_key varchar(256) NULL,
                                                                    address varchar(512) NULL,
                                                                    label_type varchar(512) NULL,
                                                                    label_name varchar(1024) NULL,
                                                                    updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_transfer_volume_count_rank (
                                                                         distributed_key varchar(256) NULL,
                                                                         address varchar(512) NULL,
                                                                         label_type varchar(512) NULL,
                                                                         label_name varchar(1024) NULL,
                                                                         updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_transfer_volume_rank (
                                                                   distributed_key varchar(256) NULL,
                                                                   address varchar(512) NULL,
                                                                   label_type varchar(512) NULL,
                                                                   label_name varchar(1024) NULL,
                                                                   updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_transfer_volume_top (
                                                                  distributed_key varchar(256) NULL,
                                                                  address varchar(512) NULL,
                                                                  label_type varchar(512) NULL,
                                                                  label_name varchar(1024) NULL,
                                                                  updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_eth_count_grade (
                                                          distributed_key varchar(256) NULL,
                                                          address varchar(512) NULL,
                                                          label_type varchar(512) NULL,
                                                          label_name varchar(1024) NULL,
                                                          updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_grade (
                                                              distributed_key varchar(256) NULL,
                                                              address varchar(512) NULL,
                                                              label_type varchar(512) NULL,
                                                              label_name varchar(1024) NULL,
                                                              updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_count_grade (
                                                            distributed_key varchar(256) NULL,
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_time_grade (
                                                           distributed_key varchar(256) NULL,
                                                           address varchar(512) NULL,
                                                           label_type varchar(512) NULL,
                                                           label_name varchar(1024) NULL,
                                                           updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_volume_grade (
                                                             distributed_key varchar(256) NULL,
                                                             address varchar(512) NULL,
                                                             label_type varchar(512) NULL,
                                                             label_name varchar(1024) NULL,
                                                             updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_eth_balance_rank (
                                                           distributed_key varchar(256) NULL,
                                                           address varchar(512) NULL,
                                                           label_type varchar(512) NULL,
                                                           label_name varchar(1024) NULL,
                                                           updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_eth_volume_rank (
                                                          distributed_key varchar(256) NULL,
                                                          address varchar(512) NULL,
                                                          label_type varchar(512) NULL,
                                                          label_name varchar(1024) NULL,
                                                          updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_time_special (
                                                       distributed_key varchar(256) NULL,
                                                       address varchar(512) NULL,
                                                       label_type varchar(512) NULL,
                                                       label_name varchar(1024) NULL,
                                                       updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_provider (
                                                                 distributed_key varchar(256) NULL,
                                                                 address varchar(512) NULL,
                                                                 label_type varchar(512) NULL,
                                                                 label_name varchar(1024) NULL,
                                                                 updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_rank (
                                                             distributed_key varchar(256) NULL,
                                                             address varchar(512) NULL,
                                                             label_type varchar(512) NULL,
                                                             label_name varchar(1024) NULL,
                                                             updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_staked (
                                                               distributed_key varchar(256) NULL,
                                                               address varchar(512) NULL,
                                                               label_type varchar(512) NULL,
                                                               label_name varchar(1024) NULL,
                                                               updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_top (
                                                            distributed_key varchar(256) NULL,
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_time_first_lp (
                                                              distributed_key varchar(256) NULL,
                                                              address varchar(512) NULL,
                                                              label_type varchar(512) NULL,
                                                              label_name varchar(1024) NULL,
                                                              updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_time_first_stake (
                                                                 distributed_key varchar(256) NULL,
                                                                 address varchar(512) NULL,
                                                                 label_type varchar(512) NULL,
                                                                 label_name varchar(1024) NULL,
                                                                 updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_volume_rank (
                                                            distributed_key varchar(256) NULL,
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_usdt_balance_rank (
                                                            distributed_key varchar(256) NULL,
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_usdt_volume_rank (
                                                           distributed_key varchar(256) NULL,
                                                           address varchar(512) NULL,
                                                           label_type varchar(512) NULL,
                                                           label_name varchar(1024) NULL,
                                                           updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_web3_type_balance_grade (
                                                                  distributed_key varchar(256) NULL,
                                                                  address varchar(512) NULL,
                                                                  label_type varchar(512) NULL,
                                                                  label_name varchar(1024) NULL,
                                                                  updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_web3_type_count_grade (
                                                                distributed_key varchar(256) NULL,
                                                                address varchar(512) NULL,
                                                                label_type varchar(512) NULL,
                                                                label_name varchar(1024) NULL,
                                                                updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_web3_type_balance_rank (
                                                                 distributed_key varchar(256) NULL,
                                                                 address varchar(512) NULL,
                                                                 label_type varchar(512) NULL,
                                                                 label_name varchar(1024) NULL,
                                                                 updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_web3_type_balance_top (
                                                                distributed_key varchar(256) NULL,
                                                                address varchar(512) NULL,
                                                                label_type varchar(512) NULL,
                                                                label_name varchar(1024) NULL,
                                                                updated_at timestamp(6) NULL
);

