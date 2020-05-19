docker-compose-kafka-data-pipeline-sample
----
본 샘플 프로젝트는 아래 책의 7장 과정인 "카프카를 활용한 데이터 파이프라인 구축"을 위한 Docker 기반의 실습용 저장소입니다.    
5개의 컨테이너로 기동 되며 각 ES/KIBANA를 제외한 나머지 컨테이너들은 Ubuntu를 기반으로 설정되었습니다.
![카프카,데이터플랫폼의 최강자 표지](/img/0.jpeg)     

책에 서술된 구축 과정은 아래 그림과 같습니다.    
![책의내용_실습1](/img/1.png)    
![책의내용_실습2](/img/2.png)    

구성
----
본 프로젝트의 구성은 다음과 같습니다.    

![프로젝트의 구성](/img/3.png)    

## 1. Apache Kafka Broker ##    
서비스(컨테이너)명 : broker (kafka_broker_1)
운영체제 : Ubuntu
설치구성 : Kafka 2.3.0

## 2. Apache Kafka Producer ##    
서비스(컨테이너)명 : producer (kafka_producer_1)
운영체제 : Ubuntu
설치구성 : Kafka 2.3.0, filebeat 7.4.2

## 3. Apache Nifi ##    
서비스(컨테이너)명 : nifi (kafka_nifi_1)
운영체제 : Ubuntu
설치구성 : Nifi 1.10.0 

## 4. ElasticSearch ##    
서비스(컨테이너)명 : elasticsearch (kafka_elasticsearch_1)
도커 이미지 : elasticsearch:6.5.3 

## 5. kibana ##    
서비스(컨테이너)명 : kibana (kafka_kibana_1)
도커 이미지 : kibana:6.5.3 

기동 및 중지
----
본 프로젝트는 docker-compose 기반으로 기동됩니다. 실습을 위한 프로젝트이기 때문에 단순 컨테이너 기동뿐 아니라 일련의 기본 생성을 실행하게 됩니다.    

## 기동 ##
다음 명령을 통해 시작합니다.    

```bash
$ ./start.sh
```

도커 이미지를 새로 생성하며 전체 컨테이너 기동 후 실습을 위한 필수 토픽을 생성하고 producer-log 토픽의 프로듀서 콘솔을 실행합니다.    

## 중지 ##
다음 명령을 통해 중지 합니다.

```bash
$ ./stop.sh
```

각 컨테이너를 제거하고 도커 volume에 저장된 데이터를 모두 삭제합니다.     

Nifi 설정
----
실습 프로세스와 동일한 환경을 구성하기 위해 다음과 같이 nifi 설정이 필요합니다.    

나이파이 설정 페이지 접속 (http://localhost:8080/nifi/)    

![Nifi Admin Home](/img/4.png)    

Consumer 만들기 → Elasticsearch 에 저장

- Processor 추가   

![Processor 추가](/img/5.png)    

- ConsumeKafka 1 추가    

![ConsumeKafka 1-1 추가](/img/6.png)     
![ConsumeKafka 1-1 추가](/img/7.png)    


- ConsumerKafka 1 설정

+ kafka_brokers : kafka_broker_1:9092
+ Topic Name(s) : peter-log
+ Group ID : nifi-001 (아무거나...)

![ConsumerKafka 1 설정](/img/8.png)    

p.s : Consumer만 추가한 상태에서 정상적으로 메시지를 받는지 확인 하려면 "[Settings > Automatically Terminate Relationships]" 의 output 값을 모두 체크

![Settings > Automatically Terminate Relationships](/img/9.png)    

- ConsumerKafka 1 실행 

![ConsumeKafka 1-1 추가](/img/10.png) -> ![ConsumeKafka 1-2 추가](/img/11.png)  

p.s 카프카 컨슈머가 잘 연결 됬는지 확인하기 위해서는 컨슈머 그룹을 조회 해 볼 수 있음.    

```bash
# In KAFKA Broker Server
$ $KAFKA_PATH/bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list
```

- 엘라스틱서치 전송을 위한 PutElasticsearchHttp 프로세서 추가     

![PutElasticsearchHttp 1-1 추가](/img/12.png) -> ![PutElasticsearchHttp 1-2 추가](/img/13.png)  

- PutElasticsearchHttp 설정     

+ ElasticSearch Hosts : http://kafka_elasticsearch_1:9200    
+ Index : `peter-log-${now():format("yyyy.MM.dd")}`    
 
+ Type : filebeat     

![PutElasticsearchHttp 1-1 설정](/img/14.png)     

+ Settings > Automatically Terminate Relationships 의 모든 값 체크

![PutElasticsearchHttp 1-2 설정](/img/15.png)     


비고
----
현재 JDK 버전을 11 기반으로 설정되어 있습니다. default-jdk 버전이 상향 될 경우 아래 파일의 JAVA_HOME 설정이 변경 되어야 합니다.    

```bash
// entrypoint-nifi.sh
#/bin/bash
NIFI_PATH=$1
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
$NIFI_PATH/bin/nifi.sh start
/bin/bash
``` 