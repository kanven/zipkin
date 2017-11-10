#!/bin/bash

cd `dirname $0`
BIN_DIR=`pwd`
cd ..
APP_HOME=`pwd`
LIBS_DIR=$APP_HOME/lib

#### elasticsearch configuration ####
ES_HOST=http://10.1.10.201:9201,http://10.1.10.202:9201,http://10.1.10.203:9201
ES_INDEX=zipkin
ES_INDEX_SHARDS=3
ES_INDEX_REPLICAS=1
ES_USERNAME=
ES_PASSWORD=

#### kafka address  #### 
KAFKA_ADDRESS=127.0.0.1:9092

ES_STORE_CONFIG="-Dzipkin.storage.type=elasticsearch -Dzipkin.storage.elasticsearch.hosts=$ES_HOST -Dzipkin.storage.elasticsearch.index=$ES_INDEX -Dzipkin.storage.elasticsearch.index-shards=$ES_INDEX_SHARDS -Dzipkin.storage.elasticsearch.index-replicas=$ES_INDEX_REPLICAS -Dzipkin.storage.elasticsearch.username=$ES_USERNAME -Dzipkin.storage.elasticsearch.password=$ES_PASSWORD "

COLLECTOR_CONFIG="-Dloader.home=$LIBS_DIR -Dloader.debug=false -Dloader.path=zipkin-autoconfigure-collector-kafka10-module.jar,zipkin-autoconfigure-collector-kafka10-module.jar!/lib  -Dspring.profiles.active=kafka -Dzipkin.collector.kafka.bootstrap-servers=$KAFKA_ADDRESS -Dzipkin.collector.kafka.overrides.auto.offset.reset=latest "

JAVA_MEM_OPTS=" -server -Xmx1024M -Xms1024M -Xmn256m -Xss256k -XX:+UseFastAccessorMethods -XX:PermSize=256M -XX:MaxPermSize=256M -XX:CMSInitiatingOccupancyFraction=70 -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection "

java $ES_STORE_CONFIG $COLLECTOR_CONFIG $JAVA_MEM_OPTS  -cp $LIBS_DIR/zipkin-server-2.1.0-exec.jar  org.springframework.boot.loader.PropertiesLauncher 1>> $APP_HOME/stdout 2>&1  & 
