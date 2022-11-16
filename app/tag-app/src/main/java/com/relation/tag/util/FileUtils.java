package com.relation.tag.util;

import com.google.common.collect.Lists;
import com.relation.tag.entity.FileEntity;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.util.CollectionUtils;

import java.io.*;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
public class FileUtils {
    public final static String SEMICOLON = ";";

    public static  void readFileTree(String rootPath, List<FileEntity> fileList) throws IOException {
        Resource resource = new ClassPathResource(rootPath);
        if (!resource.exists()) {
            System.out.println("路径错误");
            return;
        }
        System.out.println(rootPath);
        FileInputStream is = null;
        InputStreamReader read = null;
        StringBuilder sb = new StringBuilder();
        StringBuffer stringBuffer = new StringBuffer();
        if (resource.isFile()) {
            read = new InputStreamReader(resource.getInputStream(), "UTF-8");
            BufferedReader bufferedReader  = new BufferedReader(read);
            String lineTxt = null;
            while ((lineTxt = bufferedReader.readLine()) != null) {
                stringBuffer.append(lineTxt);
            }
            System.out.println("文件内容 : " + sb.toString());
            fileList.add(FileEntity.builder().fileName(resource.getFilename()).fileContent(stringBuffer.toString()).build());
        } else {
            //如果当前路径是文件夹，则列出文件夹下的所有文件和目录
            File[] files = resource.getFile().listFiles();
            for (File file : files) {
                //递归调用
                readFileTree(file.getAbsolutePath(),fileList );
            }
        }

        if (read != null) {
            read.close();
        }

        if (is != null) {
            is.close();
        }
    }

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
            BufferedReader bufferedReader  = new BufferedReader(read);
            String lineTxt = null;
            while ((lineTxt = bufferedReader.readLine()) != null) {
                stringBuffer.append(lineTxt);
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
    public static List<String> resolveSqlFile(String fileDir, String[] fileNames) throws Exception{
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
