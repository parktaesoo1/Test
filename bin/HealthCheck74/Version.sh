#!/bin/sh
###########################
# JBOSS EAP 7.2           # 
###########################
# HealthCheck V0.1        #
###########################

. ./health_env.sh

## JBoss Process Check ##
PID=`ps -ef | grep java | grep "SERVER=$SERVER_NAME " | awk '{print $2}'`

if [ e$PID == "e" ]
then
    echo "JBoss SERVER - $SERVER_NAME is Not RUNNING..."
    exit;
fi

### VERSION INFO GET ###
./jboss-cli.sh --command=version > version_info.txt

printf "%s\n" "--------------------------------------------------"
printf "\e[1;34m %-10s\e[0m \n" "## JBOSS VERSION INFO ##"
printf "%s\n" "--------------------------------------------------"

JBOSS_RELEASE=`cat version_info.txt|grep "Release"| awk -F':' '{print $2}'`
JBOSS_PRODUCT=`cat version_info.txt|grep "Product"| awk -F':' '{print $2}'`
JAVA_VERSION=`cat version_info.txt|grep "java.version"| awk -F':' '{print $2}'`
OS_VERSION=`cat version_info.txt|grep "os.version"| awk -F':' '{print $2}'`

### Print output  
printf " %-15s : %-10s\n" "OS_VERSION" "$OS_VERSION"
printf " %-15s : %-10s\n" "JBOSS_HOME" "$JBOSS_HOME"
printf " %-15s : %-10s\n" "JBOSS_RELEASE" "$JBOSS_RELEASE"
printf " %-15s : %-10s\n" "JBOSS_PRODUCT" "$JBOSS_PRODUCT"
printf " %-15s : %-10s\n" "JAVA_VERSION" "$JAVA_VERSION"
printf "%s\n" "--------------------------------------------------"

rm -f ./version_info.txt
