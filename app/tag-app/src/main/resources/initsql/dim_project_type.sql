
  drop table if exists dim_project_type;
  create table dim_project_type
  (
      project  varchar(100)
      ,type   varchar(100)
      ,label_type   varchar(100)
      ,label_name  varchar(100)
      ,content   varchar(100)
      ,operate_type   varchar(100)
      ,seq_flag varchar(100)
      ,data_subject varchar(100)
      ,etl_update_time timestamp
      ,token_name   varchar(100)
  );
  truncate table dim_project_type;      
  
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( 'ALL', 'ALL', 'WEB3_ALL_ALL_BALANCE_GRADE', '', '', 'T', 'ALL_ALL', 'balance_grade', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( 'ALL', 'ALL', 'WEB3_ALL_ALL_BALANCE_TOP', '', '', 'T', 'ALL_ALL', 'balance_top', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( 'ALL', 'ALL', 'WEB3_ALL_ALL_BALANCE_RANK', '', '', 'T', 'ALL_ALL', 'balance_rank', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( 'ALL', 'ALL', 'WEB3_ALL_ALL_ACTIVITY', '', '', 'T', 'ALL_ALL', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( 'ALL', 'NFT Recipient', 'WEB3_ALL_NFTRecipient_ACTIVITY', '', '', 'T', 'ALL_NFTRecipient', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xaf89c5e115ab3437fc965224d317d09faa66ee3e', 'NFT Recipient', 'WEB3_Mirror_NFTRecipient_BALANCE_GRADE', '', '', 'T', 'Mirror_NFTRecipient', 'balance_grade', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xaf89c5e115ab3437fc965224d317d09faa66ee3e', 'write', 'WEB3_Mirror_Write_BALANCE_GRADE', '', '', 'T', 'Mirror_Write', 'balance_grade', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x283af0b28c62c092c9727f1ee09c02ca627eb7f5', 'NFT Recipient', 'WEB3_ENS_NFTRecipient_BALANCE_GRADE', '', '', 'T', 'ENS_NFTRecipient', 'balance_grade', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x283af0b28c62c092c9727f1ee09c02ca627eb7f5', 'write', 'WEB3_ENS_Write_BALANCE_GRADE', '', '', 'T', 'ENS_Write', 'balance_grade', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xde30da39c46104798bb5aa3fe8b9e0e1f348163f', 'NFT Recipient', 'WEB3_Gitcoin_NFTRecipient_BALANCE_GRADE', '', '', 'T', 'Gitcoin_NFTRecipient', 'balance_grade', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xde30da39c46104798bb5aa3fe8b9e0e1f348163f', 'write', 'WEB3_Gitcoin_Write_BALANCE_GRADE', '', '', 'T', 'Gitcoin_Write', 'balance_grade', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xc9a42690912f6bd134dbc4e2493158b3d72cad21', 'NFT Recipient', 'WEB3_RabbitHole_NFTRecipient_BALANCE_GRADE', '', '', 'T', 'RabbitHole_NFTRecipient', 'balance_grade', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xc9a42690912f6bd134dbc4e2493158b3d72cad21', 'write', 'WEB3_RabbitHole_Write_BALANCE_GRADE', '', '', 'T', 'RabbitHole_Write', 'balance_grade', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x5bd25d2f4f26bc82a34de016d34612a28a0cd492', 'NFT Recipient', 'WEB3_ProjectGalaxy_NFTRecipient_BALANCE_GRADE', '', '', 'T', 'ProjectGalaxy_NFTRecipient', 'balance_grade', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x5bd25d2f4f26bc82a34de016d34612a28a0cd492', 'write', 'WEB3_ProjectGalaxy_Write_BALANCE_GRADE', '', '', 'T', 'ProjectGalaxy_Write', 'balance_grade', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xaf89c5e115ab3437fc965224d317d09faa66ee3e', 'NFT Recipient', 'WEB3_Mirror_NFTRecipient_BALANCE_TOP', '', '', 'T', 'Mirror_NFTRecipient', 'balance_top', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xaf89c5e115ab3437fc965224d317d09faa66ee3e', 'NFT Recipient', 'WEB3_Mirror_NFTRecipient_BALANCE_RANK', '', '', 'T', 'Mirror_NFTRecipient', 'balance_rank', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xaf89c5e115ab3437fc965224d317d09faa66ee3e', 'write', 'WEB3_Mirror_Write_BALANCE_TOP', '', '', 'T', 'Mirror_Write', 'balance_top', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xaf89c5e115ab3437fc965224d317d09faa66ee3e', 'write', 'WEB3_Mirror_Write_BALANCE_RANK', '', '', 'T', 'Mirror_Write', 'balance_rank', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x283af0b28c62c092c9727f1ee09c02ca627eb7f5', 'NFT Recipient', 'WEB3_ENS_NFTRecipient_BALANCE_TOP', '', '', 'T', 'ENS_NFTRecipient', 'balance_top', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x283af0b28c62c092c9727f1ee09c02ca627eb7f5', 'NFT Recipient', 'WEB3_ENS_NFTRecipient_BALANCE_RANK', '', '', 'T', 'ENS_NFTRecipient', 'balance_rank', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x283af0b28c62c092c9727f1ee09c02ca627eb7f5', 'write', 'WEB3_ENS_Write_BALANCE_TOP', '', '', 'T', 'ENS_Write', 'balance_top', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x283af0b28c62c092c9727f1ee09c02ca627eb7f5', 'write', 'WEB3_ENS_Write_BALANCE_RANK', '', '', 'T', 'ENS_Write', 'balance_rank', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xde30da39c46104798bb5aa3fe8b9e0e1f348163f', 'NFT Recipient', 'WEB3_Gitcoin_NFTRecipient_BALANCE_TOP', '', '', 'T', 'Gitcoin_NFTRecipient', 'balance_top', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xde30da39c46104798bb5aa3fe8b9e0e1f348163f', 'NFT Recipient', 'WEB3_Gitcoin_NFTRecipient_BALANCE_RANK', '', '', 'T', 'Gitcoin_NFTRecipient', 'balance_rank', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xde30da39c46104798bb5aa3fe8b9e0e1f348163f', 'write', 'WEB3_Gitcoin_Write_BALANCE_TOP', '', '', 'T', 'Gitcoin_Write', 'balance_top', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xde30da39c46104798bb5aa3fe8b9e0e1f348163f', 'write', 'WEB3_Gitcoin_Write_BALANCE_RANK', '', '', 'T', 'Gitcoin_Write', 'balance_rank', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xc9a42690912f6bd134dbc4e2493158b3d72cad21', 'NFT Recipient', 'WEB3_RabbitHole_NFTRecipient_BALANCE_TOP', '', '', 'T', 'RabbitHole_NFTRecipient', 'balance_top', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xc9a42690912f6bd134dbc4e2493158b3d72cad21', 'NFT Recipient', 'WEB3_RabbitHole_NFTRecipient_BALANCE_RANK', '', '', 'T', 'RabbitHole_NFTRecipient', 'balance_rank', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xc9a42690912f6bd134dbc4e2493158b3d72cad21', 'write', 'WEB3_RabbitHole_Write_BALANCE_TOP', '', '', 'T', 'RabbitHole_Write', 'balance_top', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xc9a42690912f6bd134dbc4e2493158b3d72cad21', 'write', 'WEB3_RabbitHole_Write_BALANCE_RANK', '', '', 'T', 'RabbitHole_Write', 'balance_rank', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x5bd25d2f4f26bc82a34de016d34612a28a0cd492', 'NFT Recipient', 'WEB3_ProjectGalaxy_NFTRecipient_BALANCE_TOP', '', '', 'T', 'ProjectGalaxy_NFTRecipient', 'balance_top', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x5bd25d2f4f26bc82a34de016d34612a28a0cd492', 'NFT Recipient', 'WEB3_ProjectGalaxy_NFTRecipient_BALANCE_RANK', '', '', 'T', 'ProjectGalaxy_NFTRecipient', 'balance_rank', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x5bd25d2f4f26bc82a34de016d34612a28a0cd492', 'write', 'WEB3_ProjectGalaxy_Write_BALANCE_TOP', '', '', 'T', 'ProjectGalaxy_Write', 'balance_top', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x5bd25d2f4f26bc82a34de016d34612a28a0cd492', 'write', 'WEB3_ProjectGalaxy_Write_BALANCE_RANK', '', '', 'T', 'ProjectGalaxy_Write', 'balance_rank', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xaf89c5e115ab3437fc965224d317d09faa66ee3e', 'ALL', 'WEB3_Mirror_ALL_ACTIVITY', '', '', 'T', 'Mirror_ALL', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x283af0b28c62c092c9727f1ee09c02ca627eb7f5', 'ALL', 'WEB3_ENS_ALL_ACTIVITY', '', '', 'T', 'ENS_ALL', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xde30da39c46104798bb5aa3fe8b9e0e1f348163f', 'ALL', 'WEB3_Gitcoin_ALL_ACTIVITY', '', '', 'T', 'Gitcoin_ALL', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xc9a42690912f6bd134dbc4e2493158b3d72cad21', 'ALL', 'WEB3_RabbitHole_ALL_ACTIVITY', '', '', 'T', 'RabbitHole_ALL', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x5bd25d2f4f26bc82a34de016d34612a28a0cd492', 'ALL', 'WEB3_ProjectGalaxy_ALL_ACTIVITY', '', '', 'T', 'ProjectGalaxy_ALL', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xaf89c5e115ab3437fc965224d317d09faa66ee3e', 'write', 'WEB3_Mirror_Write_ACTIVITY', '', '', 'T', 'Mirror_Write', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xaf89c5e115ab3437fc965224d317d09faa66ee3e', 'NFT Recipient', 'WEB3_Mirror_NFTRecipient_ACTIVITY', '', '', 'T', 'Mirror_NFTRecipient', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xaf89c5e115ab3437fc965224d317d09faa66ee3e', 'mint', 'WEB3_Mirror_Mint_ACTIVITY', '', '', 'T', 'Mirror_Mint', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x283af0b28c62c092c9727f1ee09c02ca627eb7f5', 'NFT Recipient', 'WEB3_ENS_NFTRecipient_ACTIVITY', '', '', 'T', 'ENS_NFTRecipient', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x283af0b28c62c092c9727f1ee09c02ca627eb7f5', 'registerer', 'WEB3_ENS_Registerer_ACTIVITY', '', '', 'T', 'ENS_Registerer', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x283af0b28c62c092c9727f1ee09c02ca627eb7f5', 'renewer', 'WEB3_ENS_Renewer_ACTIVITY', '', '', 'T', 'ENS_Renewer', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x283af0b28c62c092c9727f1ee09c02ca627eb7f5', 'Airdrop Recipient', 'WEB3_ENS_AirdropRecipient_ACTIVITY', '', '', 'T', 'ENS_AirdropRecipient', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xde30da39c46104798bb5aa3fe8b9e0e1f348163f', 'donator', 'WEB3_Gitcoin_Donator_ACTIVITY', '', '', 'T', 'Gitcoin_Donator', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xde30da39c46104798bb5aa3fe8b9e0e1f348163f', 'Airdrop Recipient', 'WEB3_Gitcoin_AirdropRecipient_ACTIVITY', '', '', 'T', 'Gitcoin_AirdropRecipient', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0xc9a42690912f6bd134dbc4e2493158b3d72cad21', 'NFT Recipient', 'WEB3_RabbitHole_NFTRecipient_ACTIVITY', '', '', 'T', 'RabbitHole_NFTRecipient', 'count', now());
insert into dim_project_type(project, type, label_type, label_name, content, operate_type, seq_flag, data_subject, etl_update_time) values ( '0x5bd25d2f4f26bc82a34de016d34612a28a0cd492', 'NFT Recipient', 'WEB3_ProjectGalaxy_NFTRecipient_ACTIVITY', '', '', 'T', 'ProjectGalaxy_NFTRecipient', 'count', now());


update dim_project_type set token_name = split_part(label_type  ,'_', 2);
  insert into tag_result(table_name,batch_date)  SELECT 'dim_project_type' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;


