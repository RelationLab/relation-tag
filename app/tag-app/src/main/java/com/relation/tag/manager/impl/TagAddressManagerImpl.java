package com.relation.tag.manager.impl;

import com.relation.tag.entity.DimRuleSqlContent;
import com.relation.tag.entity.FileEntity;
import com.relation.tag.entity.RecentTime;
import com.relation.tag.manager.TagAddressManager;
import com.relation.tag.service.IAddressLabelGpService;
import com.relation.tag.service.IDimRuleSqlContentService;
import com.relation.tag.util.FileUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.util.Lists;
import org.assertj.core.util.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ForkJoinPool;

@Service
@Slf4j
public class TagAddressManagerImpl implements TagAddressManager {
    @Autowired
    @Qualifier("greenplumDimRuleSqlContentServiceImpl")
    private IDimRuleSqlContentService dimRuleSqlContentService;
    @Autowired
    @Qualifier("greenPlumAddressLabelGpServiceImpl")
    protected IAddressLabelGpService iAddressLabelService;

    @Value("${config.environment:stag}")
    protected String configEnvironment;
    protected static ForkJoinPool forkJoinPool = new ForkJoinPool(500);

    /*********构造基础数据前提脚本文件路径**********/
    public static String BASIC_DATA_PRE_SCRIPTS_PATH = "basic-data-pre-scripts";
    /*********构造基础数据脚本文件路径**********/
    public static String BASIC_DATA_SCRIPTS_PATH = "basic-data-scripts";
    /*********构造基维度数据脚本文件路径**********/
    public static String DIM_DATA_SCRIPTS_PATH = "dim-data-scripts";
    /*********初始化汇总数据脚本文件路径**********/
    public static String TAG_SUMMARY_INIT_SCRIPTS_PATH = "tag-summary-init-scripts";

    /*********打标签脚本文件路径**********/
    public static String TAG_SCRIPTS_PATH = "tagscripts";

    /*************表定义脚本文件路径*************/
    public static String TABEL_DEFI_PATH = "tabel-defi";
    /*************时间维度脚本文件路径*************/
    public static String RECENT_TIME_PATH = "recent-time";
    /*************数据过滤脚本文件路径*************/
    public static String DATA_FILTER_PATH = "data-filter";

    /***********************************打标签流程代码*******************************************/
    /**
     * 刷新全量标签
     *
     * @param batchDate
     * @throws Exception
     */
    @Override
    public void refreshAllLabel(String batchDate) throws Exception {
        String checkTable = "address_labels_json_gin_".concat(configEnvironment);
        if (!checkResult(checkTable, batchDate, 1, false)) {
            tag(batchDate, TAG_SCRIPTS_PATH);
        }
    }

    /**
     * 检查表执行结果（一次性检查不带尝试）
     *
     * @param tableName
     * @param batchDate
     * @param result
     * @param likeKey
     * @return
     */
    public boolean checkResult(String tableName, String batchDate, Integer result, boolean likeKey) {
        if (StringUtils.isEmpty(tableName)) {
            return false;
        }
        try {
            Integer tagInteger = checkResultData(tableName, batchDate, likeKey);
//            log.info("tableName==={},tagList.size===={}", tableName, tagInteger);
            return tagInteger != null && tagInteger.intValue() >= result;
        } catch (Exception ex) {
            return false;
        }
    }

    /**
     * 打标签
     *
     * @param batchDate
     * @param filePath
     * @throws Exception
     */
    private void tag(String batchDate, String filePath) throws Exception {
        /****
         * 如果正在打标签，等待.....
         */
        checkTagging(batchDate);
        if (!checkResult("address_label", batchDate, 62, true)) {
            buildTagBasicData(batchDate);
            check("dim_rule_content", 60 * 1000, batchDate, 1, false);
            tagSummaryInit(batchDate, TAG_SUMMARY_INIT_SCRIPTS_PATH);
            check("total_volume_usd", 1 * 60 * 1000, batchDate, 1, false);
            List<DimRuleSqlContent> ruleSqlList = dimRuleSqlContentService.list();
            List<FileEntity> fileList = Lists.newArrayList();
            for (DimRuleSqlContent item : ruleSqlList) {
                String fileName = item.getRuleName().concat(".sql");
                fileList.add(FileEntity.builder().fileName(fileName)
                        .fileContent(FileUtils.readFile(filePath.concat(File.separator).concat(fileName))).build());
            }
            tagByRuleSqlList(fileList, batchDate);
        }
        check("address_label", 60 * 1000, batchDate, 59, true);
        tagMerge(batchDate);
    }

    /**
     * 全量锁检查打标签
     *
     * @param batchDate
     * @throws InterruptedException
     */
    private void checkTagging(String batchDate) throws InterruptedException {
        while (true) {
            boolean taggingFlag = checkResult("tagging", batchDate, 1, false);
            if (!taggingFlag) {
                break;
            }
            Thread.sleep(10 * 60 * 1000);
        }
    }

    /**
     * 检查表执行结果（带尝试）
     *
     * @param tableName
     * @param sleepTime
     * @param batchDate
     * @param resultNum
     * @param likeKey
     */
    public void check(String tableName, long sleepTime, String batchDate, int resultNum, boolean likeKey) {
        if (StringUtils.isEmpty(tableName)) {
            return;
        }
        while (true) {
            try {
                Integer tagInteger = checkResultData(tableName, batchDate, likeKey);
                if (tagInteger != null && tagInteger.intValue() >= resultNum) {
//                    log.info("check table ===={} end.......tagList.size===={}", tableName, tagInteger);
                    break;
                }
            } catch (Exception ex) {
                try {
                    Thread.sleep(sleepTime);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
            try {
                Thread.sleep(sleepTime);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }

    /**
     * 检查表执行结果
     *
     * @param tableName
     * @param batchDate
     * @param likeKey
     * @return
     */
    private Integer checkResultData(String tableName, String batchDate, boolean likeKey) {
        String checkSql = "select count(1) from ".concat(" tag_result where 1=1 and ");
        if (likeKey) {
            checkSql = checkSql.concat(" table_name like '").concat(tableName).concat("%");
        } else {
            checkSql = checkSql.concat(" table_name='").concat(tableName);
        }
        checkSql = checkSql.concat("' and batch_date='").concat(batchDate).concat("'");
//        log.info("exceSelectSql======={}",checkSql);
        Integer retVal = iAddressLabelService.exceSelectSql(checkSql);
//        log.info("exceSelectSql======={},retVal=============={}",checkSql,retVal);
        return retVal;
    }

    /**
     * 执行打标签脚本（整个目录下的标签脚本）
     *
     * @param ruleSqlList
     * @param batchDate
     */
    private void tagByRuleSqlList(List<FileEntity> ruleSqlList, String batchDate) {
        try {
            forkJoinPool.execute(() -> {
                ruleSqlList.parallelStream().forEach(ruleSql -> {
                    execContentSql(ruleSql, batchDate);
                });
            });
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 执行单个打标签脚本
     *
     * @param ruleSql
     * @param batchDate
     */
    private void execContentSql(FileEntity ruleSql, String batchDate) {
        try {
            String tableName = ruleSql.getFileName();
            String table = tableName.split("\\.")[0];
            if (checkResult(table, batchDate, 1, false)) {
                return;
            }
            iAddressLabelService.exceSql(ruleSql.getFileContent(), ruleSql.getFileName());
        } catch (Exception ex) {
            try {
                Thread.sleep(1 * 60 * 1000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            execContentSql(ruleSql, batchDate);
        }
    }

    /**
     * 合并标签结果
     *
     * @param batchDate
     * @throws Exception
     */
    @Override
    public void tagMerge(String batchDate) throws Exception {
        execSql(null, "address_label_gp.sql", batchDate, TAG_SUMMARY_INIT_SCRIPTS_PATH, Maps.newHashMap("tableSuffix",configEnvironment), false);
        execSql("address_label_gp_"+configEnvironment, "address_labels_json_gin.sql", batchDate, TAG_SUMMARY_INIT_SCRIPTS_PATH, Maps.newHashMap("tableSuffix",configEnvironment), false);
    }

    /*************************************************************执行SQL部分**********************************************************/
    /**
     * 异步执行SQL
     *
     * @param lastTableName
     * @param sqlName
     * @param batchDate
     * @param dir
     * @param conditionMap
     * @param synFlag
     * @return
     */
    private boolean execSql(String lastTableName, String sqlName, String batchDate, String dir, Map<String, String> conditionMap, boolean synFlag) {
        return execSql(lastTableName, sqlName, batchDate, dir, 1, false,conditionMap, synFlag);
    }

    private boolean execSql(String lastTableName, String sqlName, String batchDate, String dir, int resultNum, boolean likeKey, Map<String, String> conditionMap, boolean synFlag) {
        String tableName = sqlName.split("\\.")[0];
        String finalTableName = tableName;
        if (!synFlag){
            forkJoinPool.execute(new Runnable() {
                @Override
                public void run() {
                    execSynSql(lastTableName, sqlName, finalTableName, batchDate, dir, resultNum, likeKey, conditionMap, synFlag);
                }
            });
        }else {
            execSynSql(lastTableName, sqlName, finalTableName, batchDate, dir, resultNum, likeKey, conditionMap, synFlag);
        }
        return checkResult(finalTableName, batchDate, resultNum, likeKey);
    }

    /**
     * 同步执行SQL
     *
     * @param lastTableName
     * @param sqlName
     * @param tableName
     * @param batchDate
     * @param dir
     * @param conditionMap
     * @param synFlag
     */
    private void execSynSql(String lastTableName, String sqlName, String tableName,
                            String batchDate, String dir, int resultNum, boolean likeKey, Map<String, String> conditionMap, boolean synFlag) {
        long sleepTime = synFlag?0:20 * 1000;
        check(lastTableName, sleepTime, batchDate, resultNum, likeKey);
        try {
            String recentTimeCode = null;
            String tableSuffix = null;
            String recentTimeBlockHeight = null;
            if (conditionMap != null && !conditionMap.isEmpty()) {
                recentTimeCode = conditionMap.getOrDefault("recentTimeCode", null);
                tableSuffix = conditionMap.getOrDefault("tableSuffix", null);
                recentTimeBlockHeight = conditionMap.getOrDefault("recentTimeBlockHeight", null);
            }
            tableName = StringUtils.isNotBlank(recentTimeCode)?tableName.concat("_").concat(recentTimeCode):tableName;
            if (checkResult(tableName, batchDate, 1, false)) {
                return;
            }
            String exceSql = FileUtils.readFile(dir.concat(File.separator).concat(sqlName));
            if (StringUtils.isNotEmpty(recentTimeCode)) {
                exceSql = exceSql.replace("${recentTimeCode}", recentTimeCode);
            }
            if (StringUtils.isNotEmpty(recentTimeBlockHeight)) {
                exceSql = exceSql.replace("${recentTimeBlockHeight}", recentTimeBlockHeight);
            }
            if (StringUtils.isNotEmpty(tableSuffix)) {
                exceSql = exceSql.replace("${tableSuffix}", tableSuffix);
            }
            iAddressLabelService.exceSql(exceSql, sqlName);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            try {
                Thread.sleep(1 * 60 * 1000);
            } catch (InterruptedException ex) {
                throw new RuntimeException(ex);
            }
            log.info("sqlName==={} try ......", sqlName);
            execSynSql(lastTableName, sqlName, tableName, batchDate, dir, resultNum, likeKey, conditionMap, synFlag);
        }
    }

    /************************************基础数据部分****************************************/
    private void buildTagBasicData(String batchDate) {
        /******************生成基础数据前提*****************/
        basicDataPre(batchDate, BASIC_DATA_PRE_SCRIPTS_PATH);
        /******************基础数据部分****************/
        basicData(batchDate, BASIC_DATA_SCRIPTS_PATH);
        /***********维度表部分*********/
        dimData(batchDate, DIM_DATA_SCRIPTS_PATH);
    }

    private void basicDataPre(String batchDate, String filePath) {
        execSql(null, "drop_view.sql", batchDate, filePath, null,true );
        execSql("drop_view", "dms_syn_block.sql", batchDate, filePath, null, true);
        execSql("dms_syn_block", "snapshot_table.sql", batchDate, filePath, null,true );
        execSql("snapshot_table", "create_view.sql", batchDate, filePath, null,true );
    }

    private void basicData(String batchDate, String filePath) {
        /******************级别部分*****************/
        execSql("create_view", "level_def.sql", batchDate, filePath, null, false);

        /******************DEX部分*****************/
        execSql("create_view", "platform.sql", batchDate, filePath, null, false);
        execSql("create_view", "platform_detail.sql", batchDate, filePath, null, false);
        execSql("create_view", "trade_type.sql", batchDate, filePath, null, false);
        execSql("create_view", "dex_action_platform.sql", batchDate, filePath, null, false);

        /******************WEB3部分*****************/
        execSql("create_view", "web3_platform.sql", batchDate, filePath, null, false);
        execSql("create_view", "web3_action.sql", batchDate, filePath, null, false);
        execSql("create_view", "web3_action_platform.sql", batchDate, filePath, null, false);

        /******************NFT部分*****************/
        execSql("create_view", "mp_nft_platform.sql", batchDate, filePath, null, false);
        execSql("create_view", "nft_trade_type.sql", batchDate, filePath, null, false);
        execSql("create_view", "nft_action_platform.sql", batchDate, filePath, null, false);

        /************计算token的dex和nft的MP部分*************/
        execSql("basic_data", "token_platform.sql", batchDate, filePath,11,true, null,false );
        execSql("basic_data", "nft_platform.sql", batchDate, filePath,11,true, null, false);
    }

    private void dimData(String batchDate, String filePath) {
        execSql("data", "combination.sql", batchDate, filePath, 2,true,null, false);
        execSql("data", "label.sql", batchDate, filePath, 2,true,null, false);

        execSql("data_table", "dim_rule_sql_content.sql", batchDate, filePath,2,true, null, false);
        execSql("data_table", "label_factor_seting.sql", batchDate, filePath, 2,true,null, false);
        execSql("data_table", "dim_project_token_type.sql", batchDate, filePath,2,true, null, false);
        execSql("data_table", "dim_project_type.sql", batchDate, filePath, 2,true,null,false );
        execSql("data_table", "dim_rule_content.sql", batchDate, filePath, 2,true,null,false );
        execSql("data_table", "white_list_erc20.sql", batchDate, filePath, 2,true,null, false);
    }


    /************************************打标签汇总数据部分****************************************/
    private void tagSummaryInit(String batchDate, String filePath) throws Exception {
        String dataFilterPath = filePath.concat(File.separator).concat(DATA_FILTER_PATH);
        String tableDefiPath = filePath.concat(File.separator).concat(TABEL_DEFI_PATH);
        String recentTimePath = filePath.concat(File.separator).concat(RECENT_TIME_PATH);
        dataFilter(batchDate, dataFilterPath);
        execSql("dim", "dex_tx_volume_count_summary_stake.sql", batchDate, filePath, 6,true,null, false);
        execSql("dim", "token_balance_volume_usd.sql", batchDate, filePath, 6,true,null, false);
        execSql("dim", "total_balance_volume_usd.sql", batchDate, filePath, 6,true,null, false);
        /***************web3_transaction_record_summary***********/
        execSql("dim", "web3_transaction_record_summary.sql", batchDate, tableDefiPath, 6,true,null, false);
        exceRecentTimeScripts(batchDate, recentTimePath, "web3_transaction_record_summary.sql", "tabel_defi_web3_transaction_record_summary", 1,false);

        /***************erc20_tx_record_from***********/
        execSql("dim", "erc20_tx_record_from.sql", batchDate, tableDefiPath, 6,true,null, false);
        exceRecentTimeScripts(batchDate, recentTimePath, "erc20_tx_record_from.sql", "tabel_defi_erc20_tx_record_from", 1,false);
        /***************erc20_tx_record_to***********/
        execSql("dex_tx_volume_count_summary_univ3", "erc20_tx_record_to.sql", batchDate, tableDefiPath, 9,true,null, false);
        exceRecentTimeScripts(batchDate, recentTimePath, "erc20_tx_record_to.sql", "tabel_defi_erc20_tx_record_to", 1,false);
        execSql("erc20_tx_record", "token_holding_vol_count.sql", batchDate, filePath, 18,true,null, false);

        /***************eth_holding_vol_count***********/
        execSql("dim", "eth_tx_record_from_to.sql", batchDate, tableDefiPath, 6,true,null, false);
        exceRecentTimeScripts(batchDate, recentTimePath, "eth_tx_record_from_to.sql", "tabel_defi_eth_tx_record_from_to", 1,false);
        execSql("eth_tx_record_from_to", "eth_holding_vol_count.sql", batchDate, filePath, 9,true,null, false);

        execSql("vol_count", "token_volume_usd.sql", batchDate, filePath, 2,true,null, false);
        execSql("token_volume_usd", "total_volume_usd.sql", batchDate, filePath, 1,false,null, false);

        /***************nft_holding***********/
        execSql("dim", "nft_holding.sql", batchDate, tableDefiPath, 6,true,null, false);
        execSql("tabel_defi_nft_holding", "nft_holding_middle.sql", batchDate, tableDefiPath, 1,false,null, false);
        exceRecentTimeScripts(batchDate, recentTimePath, "nft_holding_middle.sql", "tabel_defi_nft_holding_middle", 1,false);
        exceRecentTimeScripts(batchDate, recentTimePath, "nft_holding_record.sql", "nft_holding_middle", 9,true);
        execSql("nft_holding_record", "nft_holding_summary.sql", batchDate, filePath, 9,true,null, false);

        /***************nft_buy_sell_holding***********/
        execSql("nft_holding_summary", "nft_buy_sell_holding_middle.sql", batchDate, tableDefiPath, 1,false,null, false);
        exceRecentTimeScripts(batchDate, recentTimePath, "nft_buy_sell_holding_middle.sql", "tabel_defi_nft_buy_sell_holding_middle", 1,false);
        execSql("nft_buy_sell_holding_middle", "nft_buy_sell_holding.sql", batchDate, filePath, 9,true,null, false);
        execSql("nft_buy_sell_holding", "nft_transfer_holding.sql", batchDate, filePath, 1,false,null, false);

        /***************platform_nft_holding***********/
        execSql("nft_transfer_holding", "platform_nft_holding_middle.sql", batchDate, tableDefiPath, 1,false,null, false);
        exceRecentTimeScripts(batchDate, recentTimePath, "platform_nft_holding_middle.sql", "tabel_defi_platform_nft_holding_middle", 1,false);
        execSql("platform_nft_holding_middle", "platform_nft_holding.sql", batchDate, filePath, 9,true,null, false);
        execSql("platform_nft_holding", "platform_nft_volume_usd.sql", batchDate, filePath, 1,false,null, false);

        /********************platform_nft_type_volume_count*******************/
        execSql("platform_nft_volume_usd", "platform_nft_type_volume_count.sql", batchDate, tableDefiPath, 1,false,null, false);
        exceRecentTimeScripts(batchDate, recentTimePath, "platform_nft_type_volume_count.sql", "tabel_defi_platform_nft_type_volume_count", 1,false);
        execSql("platform_nft_type_volume_count", "platform_nft_type_volume_count_summary.sql", batchDate, filePath, 9,true,null, false);
        execSql("platform_nft_type_volume_count_summary", "nft_volume_count.sql", batchDate, filePath, 1,false,null, false);

        /***************dex_tx_count_summary***********/
        execSql("filter", "dex_tx_count_summary.sql", batchDate, tableDefiPath, 2,true,null, false);
        exceRecentTimeScripts(batchDate, recentTimePath, "dex_tx_count_summary.sql", "tabel_defi_dex_tx_count_summary", 1,false);
        execSql("dex_tx_count_summary", "dex_tx_count_summary.sql", batchDate, filePath, 9,true,null, false);

        /***************dex_tx_volume_count_summary***********/
        execSql("filter", "dex_tx_volume_count_summary.sql", batchDate, tableDefiPath, 2,true,null, false);
        exceRecentTimeScripts(batchDate, recentTimePath, "dex_tx_volume_count_summary.sql", "tabel_defi_dex_tx_volume_count_summary", 1,false);
        execSql("dex_tx_volume_count_summary", "dex_tx_volume_count_summary.sql", batchDate, filePath, 9,true,null, false);

        /***************dex_tx_volume_count_summary***********/
        execSql("filter", "dex_tx_volume_count_summary_univ3.sql", batchDate, tableDefiPath, 2,true,null, false);
        exceRecentTimeScripts(batchDate, recentTimePath, "dex_tx_volume_count_summary_univ3.sql", "tabel_defi_dex_tx_volume_count_summary_univ3", 1,false);
        }

    private void exceRecentTimeScripts(String batchDate, String filePath, String fileName, String lastTableName, int resultNum, boolean likeKey) {
        List<RecentTime> list = iAddressLabelService.selectRecentTimeList();
        if (CollectionUtils.isEmpty(list)) {
            return;
        }
        list.forEach(item -> {
            Map<String,String> map = Maps.newHashMap("recentTimeCode",item.getRecentTimeCode());
            map.put("recentTimeBlockHeight",item.getBlockHeight().toString());
            execSql(lastTableName, fileName, batchDate, filePath, resultNum,  likeKey,map, false);
        });
    }

    /****
     * 处理交易流水中hash重复的数据（做一层过滤）
     * @param batchDate
     * @param filePath
     */
    private void dataFilter(String batchDate, String filePath) {
        execSql("dim", "dex_tx_volume_count_record_filter.sql", batchDate, filePath,6,true, null, false);
        execSql("dim", "token_holding_uni_filter.sql", batchDate, filePath, 6,true,null, false);
    }
}
