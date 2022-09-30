# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
FROM susky900213/spring-boot-extension:1.0.0 AS spring-boot-extension

FROM maven:3.6.3-openjdk-8 AS relation-tag

COPY --from=spring-boot-extension /root/.m2 /root/.m2

RUN mkdir /build
ADD pom.xml /build
ADD tag-app /build/tag-app

RUN cd /build && mvn clean package

FROM openjdk:8u302-jdk

MAINTAINER qingyun.yu

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' > /etc/timezone

COPY --from=relation-data-sync /build/tag-app/target/tag-app.jar /tag-app.jar

EXPOSE 10008 10008

ENTRYPOINT ["java", "-jar", "tag-app.jar"]