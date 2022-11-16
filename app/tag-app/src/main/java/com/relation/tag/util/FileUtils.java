package com.relation.tag.util;

import com.google.common.collect.Lists;
import com.relation.tag.entity.FileEntity;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.util.CollectionUtils;
import org.springframework.util.ResourceUtils;

import java.io.*;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
public class FileUtils {
    public final static String SEMICOLON = ";";
    /**
     * read TXT file
     *
     * @param filePath
     */
    public static String readFile(String filePath) throws Exception {
//        log.info(String.format("readFile %s start.........",filePath));
        StringBuffer stringBuffer = new StringBuffer();
        InputStreamReader read = null;
        try {
            Resource resource = new ClassPathResource(filePath);
            read = new InputStreamReader(resource.getInputStream(), "UTF-8");
            BufferedReader bufferedReader = new BufferedReader(read);
            String lineTxt = null;
            while ((lineTxt = bufferedReader.readLine()) != null) {
                stringBuffer.append(lineTxt).append("\n");
            }
        } catch (Exception ex) {
            log.error(ex.getMessage(), ex);
        } finally {
            if (read != null) {
                read.close();
            }
        }
//        log.info(String.format("readFile %s end.........",filePath));
        return stringBuffer.toString();
    }

    public static String concatDir(String fileDir) {
        return fileDir.concat(File.separator);
    }

    /**
     * parsing SQL script
     *
     * @param fileDir
     * @param fileNames
     * @return
     */
    public static List<String> resolveSqlFile(String fileDir, String[] fileNames) throws Exception {
        log.info("resolveSqlFile start......");
        String filePathConcat = concatDir(fileDir);
        List<String> sqlList = Lists.newArrayList();
        for (String itemFileName : fileNames) {
            List<String> fileList = Arrays.asList(readFile(filePathConcat.concat(itemFileName)).split(SEMICOLON));
            if (CollectionUtils.isEmpty(fileList)) {
                continue;
            }
            fileList = fileList.stream().filter(e -> {
                return StringUtils.isNotBlank(e);
            }).collect(Collectors.toList());
            sqlList.addAll(fileList);
        }
        log.info(String.format("resolveSqlFile end  sqlList length：%s", sqlList.size()));
        return sqlList;
    }
}
