drop table if exists address_label_token_project_type_count_grade;
drop table if exists address_label_token_project_type_volume_grade;
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
drop table if exists address_label_token_time_special;
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
drop table if exists address_label_eth_time_grade;
drop table if exists address_label_eth_time_special;
drop table if exists address_label_token_balance_grade_all;
drop table if exists address_label_token_volume_grade_all;
drop table if exists address_label_token_balance_rank_all;
drop table if exists address_label_token_balance_top_all;
drop table if exists address_label_token_volume_rank_all;
drop table if exists address_label_univ3_balance_grade;
drop table if exists address_label_univ3_count_grade;
drop table if exists address_label_univ3_volume_grade;
drop table if exists address_label_univ3_balance_rank;
drop table if exists address_label_univ3_balance_top;
drop table if exists address_label_univ3_volume_rank;

CREATE TABLE public.address_label_token_project_type_count_grade (
                                                                         
                                                                         address varchar(512) NULL,
                                                                         label_type varchar(512) NULL,
                                                                         label_name varchar(1024) NULL,
                                                                         updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_project_type_volume_grade (
                                                                          
                                                                          address varchar(512) NULL,
                                                                          label_type varchar(512) NULL,
                                                                          label_name varchar(1024) NULL,
                                                                          updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_project_type_volume_rank (
                                                                         
                                                                         address varchar(512) NULL,
                                                                         label_type varchar(512) NULL,
                                                                         label_name varchar(1024) NULL,
                                                                         updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_project_type_count_grade (
                                                                       
                                                                       address varchar(512) NULL,
                                                                       label_type varchar(512) NULL,
                                                                       label_name varchar(1024) NULL,
                                                                       updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_project_type_volume_grade (
                                                                        
                                                                        address varchar(512) NULL,
                                                                        label_type varchar(512) NULL,
                                                                        label_name varchar(1024) NULL,
                                                                        updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_project_type_volume_count_rank (
                                                                             
                                                                             address varchar(512) NULL,
                                                                             label_type varchar(512) NULL,
                                                                             label_name varchar(1024) NULL,
                                                                             updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_project_type_volume_rank (
                                                                       
                                                                       address varchar(512) NULL,
                                                                       label_type varchar(512) NULL,
                                                                       label_name varchar(1024) NULL,
                                                                       updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_project_type_volume_top (
                                                                      
                                                                      address varchar(512) NULL,
                                                                      label_type varchar(512) NULL,
                                                                      label_name varchar(1024) NULL,
                                                                      updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_balance_grade (
                                                            
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_count_grade (
                                                          
                                                          address varchar(512) NULL,
                                                          label_type varchar(512) NULL,
                                                          label_name varchar(1024) NULL,
                                                          updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_time_grade (
                                                         
                                                         address varchar(512) NULL,
                                                         label_type varchar(512) NULL,
                                                         label_name varchar(1024) NULL,
                                                         updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_volume_grade (
                                                           
                                                           address varchar(512) NULL,
                                                           label_type varchar(512) NULL,
                                                           label_name varchar(1024) NULL,
                                                           updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_balance_rank (
                                                           
                                                           address varchar(512) NULL,
                                                           label_type varchar(512) NULL,
                                                           label_name varchar(1024) NULL,
                                                           updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_balance_top (
                                                          
                                                          address varchar(512) NULL,
                                                          label_type varchar(512) NULL,
                                                          label_name varchar(1024) NULL,
                                                          updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_time_rank (
                                                        
                                                        address varchar(512) NULL,
                                                        label_type varchar(512) NULL,
                                                        label_name varchar(1024) NULL,
                                                        updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_time_top (
                                                       
                                                       address varchar(512) NULL,
                                                       label_type varchar(512) NULL,
                                                       label_name varchar(1024) NULL,
                                                       updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_volume_count_rank (
                                                                
                                                                address varchar(512) NULL,
                                                                label_type varchar(512) NULL,
                                                                label_name varchar(1024) NULL,
                                                                updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_volume_rank (
                                                          
                                                          address varchar(512) NULL,
                                                          label_type varchar(512) NULL,
                                                          label_name varchar(1024) NULL,
                                                          updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_volume_top (
                                                         
                                                         address varchar(512) NULL,
                                                         label_type varchar(512) NULL,
                                                         label_name varchar(1024) NULL,
                                                         updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_transfer_count_grade (
                                                                   
                                                                   address varchar(512) NULL,
                                                                   label_type varchar(512) NULL,
                                                                   label_name varchar(1024) NULL,
                                                                   updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_transfer_volume_grade (
                                                                    
                                                                    address varchar(512) NULL,
                                                                    label_type varchar(512) NULL,
                                                                    label_name varchar(1024) NULL,
                                                                    updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_transfer_volume_count_rank (
                                                                         
                                                                         address varchar(512) NULL,
                                                                         label_type varchar(512) NULL,
                                                                         label_name varchar(1024) NULL,
                                                                         updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_transfer_volume_rank (
                                                                   
                                                                   address varchar(512) NULL,
                                                                   label_type varchar(512) NULL,
                                                                   label_name varchar(1024) NULL,
                                                                   updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_nft_transfer_volume_top (
                                                                  
                                                                  address varchar(512) NULL,
                                                                  label_type varchar(512) NULL,
                                                                  label_name varchar(1024) NULL,
                                                                  updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_eth_count_grade (
                                                          
                                                          address varchar(512) NULL,
                                                          label_type varchar(512) NULL,
                                                          label_name varchar(1024) NULL,
                                                          updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_grade (
                                                              
                                                              address varchar(512) NULL,
                                                              label_type varchar(512) NULL,
                                                              label_name varchar(1024) NULL,
                                                              updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_count_grade (
                                                            
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_time_grade (
                                                           
                                                           address varchar(512) NULL,
                                                           label_type varchar(512) NULL,
                                                           label_name varchar(1024) NULL,
                                                           updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_volume_grade (
                                                             
                                                             address varchar(512) NULL,
                                                             label_type varchar(512) NULL,
                                                             label_name varchar(1024) NULL,
                                                             updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_eth_balance_rank (
                                                           
                                                           address varchar(512) NULL,
                                                           label_type varchar(512) NULL,
                                                           label_name varchar(1024) NULL,
                                                           updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_eth_volume_rank (
                                                          
                                                          address varchar(512) NULL,
                                                          label_type varchar(512) NULL,
                                                          label_name varchar(1024) NULL,
                                                          updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_time_special (
                                                       
                                                       address varchar(512) NULL,
                                                       label_type varchar(512) NULL,
                                                       label_name varchar(1024) NULL,
                                                       updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_provider (
                                                                 
                                                                 address varchar(512) NULL,
                                                                 label_type varchar(512) NULL,
                                                                 label_name varchar(1024) NULL,
                                                                 updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_rank (
                                                             
                                                             address varchar(512) NULL,
                                                             label_type varchar(512) NULL,
                                                             label_name varchar(1024) NULL,
                                                             updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_staked (
                                                               
                                                               address varchar(512) NULL,
                                                               label_type varchar(512) NULL,
                                                               label_name varchar(1024) NULL,
                                                               updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_top (
                                                            
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_time_first_lp (
                                                              
                                                              address varchar(512) NULL,
                                                              label_type varchar(512) NULL,
                                                              label_name varchar(1024) NULL,
                                                              updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_time_first_stake (
                                                                 
                                                                 address varchar(512) NULL,
                                                                 label_type varchar(512) NULL,
                                                                 label_name varchar(1024) NULL,
                                                                 updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_volume_rank (
                                                            
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_usdt_balance_rank (
                                                            
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_usdt_volume_rank (
                                                           
                                                           address varchar(512) NULL,
                                                           label_type varchar(512) NULL,
                                                           label_name varchar(1024) NULL,
                                                           updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_web3_type_balance_grade (
                                                                  
                                                                  address varchar(512) NULL,
                                                                  label_type varchar(512) NULL,
                                                                  label_name varchar(1024) NULL,
                                                                  updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_web3_type_count_grade (
                                                                
                                                                address varchar(512) NULL,
                                                                label_type varchar(512) NULL,
                                                                label_name varchar(1024) NULL,
                                                                updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_web3_type_balance_rank (
                                                                 
                                                                 address varchar(512) NULL,
                                                                 label_type varchar(512) NULL,
                                                                 label_name varchar(1024) NULL,
                                                                 updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_web3_type_balance_top (
                                                                
                                                                address varchar(512) NULL,
                                                                label_type varchar(512) NULL,
                                                                label_name varchar(1024) NULL,
                                                                updated_at timestamp(6) NULL
);


CREATE TABLE public.address_label_eth_time_grade (
                                                     
                                                     address varchar(512) NULL,
                                                     label_type varchar(512) NULL,
                                                     label_name varchar(1024) NULL,
                                                     updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_eth_time_special (
                                                       
                                                       address varchar(512) NULL,
                                                       label_type varchar(512) NULL,
                                                       label_name varchar(1024) NULL,
                                                       updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_grade_all (
                                                            
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_volume_grade_all (
                                                       
                                                       address varchar(512) NULL,
                                                       label_type varchar(512) NULL,
                                                       label_name varchar(1024) NULL,
                                                       updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_rank_all (
                                                            
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_balance_top_all (
                                                            
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_token_volume_rank_all (
                                                            
                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_univ3_balance_grade (

                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_univ3_count_grade (

                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_univ3_volume_grade (

                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_univ3_balance_rank (

                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_univ3_balance_top (

                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

CREATE TABLE public.address_label_univ3_volume_rank (

                                                            address varchar(512) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL
);

truncate table dex_tx_volume_count_summary;
----ALTER TABLE public.erc20_tx_record DROP COLUMN id;