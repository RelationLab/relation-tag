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

    public static void readFileTree(String rootPath, List<FileEntity> fileList) throws IOException {
        ClassPathResource resource = new ClassPathResource(rootPath);
        FileUtils.readFileTree(resource.getPath(), fileList, resource.getFile());
    }

    public static void readFileTree(String rootPath, List<FileEntity> fileList, File resourceFile) throws IOException {
        File rootFile = new File(rootPath);
        System.out.println(rootPath);
        FileInputStream is = null;
        BufferedReader reader = null;
        StringBuilder sb = new StringBuilder();
        if (rootFile.isFile()) {
            //如果当前路径是文件，读取内容
            is = new FileInputStream(rootFile);
            reader = new BufferedReader(new InputStreamReader(is, "GBK"));
            String content = null;
            while ((content = reader.readLine()) != null) {
                sb.append(content);
            }
            fileList.add(FileEntity.builder().fileName(rootFile.getName()).fileContent(sb.toString()).build());
            System.out.println("文件内容 : " + sb.toString());
        } else {
            //如果当前路径是文件夹，则列出文件夹下的所有文件和目录
            File[] files = resourceFile != null ? resourceFile.listFiles() : rootFile.listFiles();
            for (File file : files) {
                //递归调用
                readFileTree(file.getAbsolutePath(), fileList, null);
            }
        }

        if (reader != null) {
            reader.close();
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
            BufferedReader bufferedReader = new BufferedReader(read);
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
