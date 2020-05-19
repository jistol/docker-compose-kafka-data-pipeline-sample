#/bin/bash
NIFI_PATH=$1
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
$NIFI_PATH/bin/nifi.sh start
/bin/bash
