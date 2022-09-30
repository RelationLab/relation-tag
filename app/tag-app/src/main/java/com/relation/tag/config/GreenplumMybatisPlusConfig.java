package com.relation.tag.config;

import com.alibaba.druid.pool.DruidDataSource;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.core.MybatisConfiguration;
import com.baomidou.mybatisplus.core.config.GlobalConfig;
import com.baomidou.mybatisplus.extension.spring.MybatisSqlSessionFactoryBean;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.type.JdbcType;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import javax.sql.DataSource;

@Configuration
@MapperScan(basePackages = "com.relation.tag.mapper.greenplum",
        sqlSessionTemplateRef = "greenplumSqlSessionTemplate")
public class GreenplumMybatisPlusConfig {
    private String mappers = "classpath*:mappers/greenplum/**/*Mapper.xml";

    @Bean(name = "greenplumDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.greenplum")
    public DataSource dataSource() {
        DruidDataSource druidDataSource = new DruidDataSource();
        return druidDataSource;
    }

    @Bean("greenplumSqlSessionFactory")
    public SqlSessionFactory sqlSessionFactory(@Qualifier("greenplumDataSource") DataSource dataSource) throws Exception {
        MybatisSqlSessionFactoryBean sqlSessionFactory = new MybatisSqlSessionFactoryBean();
        sqlSessionFactory.setDataSource(dataSource);
        sqlSessionFactory.setMapperLocations(new PathMatchingResourcePatternResolver().getResources(mappers));
        MybatisConfiguration configuration = new MybatisConfiguration();
        configuration.setJdbcTypeForNull(JdbcType.NULL);
        configuration.setMapUnderscoreToCamelCase(true);
        configuration.setCacheEnabled(false);
        //configuration.addMapper(SysMenuMapper.class);
        sqlSessionFactory.setConfiguration(configuration);
        GlobalConfig.DbConfig dbConfig = new GlobalConfig.DbConfig();
        dbConfig.setIdType(IdType.AUTO);

        GlobalConfig conf = new GlobalConfig();
        conf.setDbConfig(dbConfig);
        sqlSessionFactory.setGlobalConfig(conf);
        return sqlSessionFactory.getObject();
    }


    @Bean(name = "greenplumTransactionManager")
    public DataSourceTransactionManager transactionManager(@Qualifier("greenplumDataSource") DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }

    @Bean(name = "greenplumSqlSessionTemplate")
    public SqlSessionTemplate sqlSessionTemplate(@Qualifier("greenplumSqlSessionFactory") SqlSessionFactory sqlSessionFactory) throws Exception {
        return new SqlSessionTemplate(sqlSessionFactory);
    }
}
