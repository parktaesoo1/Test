#!/bin/sh
###########################
# JBOSS EAP 7.2           # 
###########################
# HealthCheck V0.1        #
###########################

. ./health_env.sh

### DS POOL NAME GET ###
./jboss-cli.sh --command="/subsystem=datasources:read-resource(recursive=true)"|grep -B 1 "allocation-retry\"" | sed 's/{/\n/g' | sed 's/"//g' > DS_info.txt
DS_NAMES=`cat DS_info.txt |egrep -v "allocation-retry|--" | sed 's/=>/\n/g' |grep -v "data-source"`
#echo $DS_NAMES

printf "%s\n" "--------------------------------------------------"
printf "\e[1;34m %-10s\e[0m \n" "## DATASOURCE CONNETION POOL CHECK ##"
printf "%s\n" "--------------------------------------------------"


for DS_NAME in $DS_NAMES ;
do
        ### DS Monitoring Check  ###
        ./jboss-cli.sh --command=/subsystem=datasources/data-source=$DS_NAME:read-resource\(recursive=true,include-runtime=true\) | sed 's/["|,]//g' > conn_info.txt
        ### DS POOL Connection TEST ###
        ./jboss-cli.sh --command="/subsystem=datasources/data-source=$DS_NAME:test-connection-in-pool" | sed 's/["|,]//g' > conn_test.txt

        TEST_CONNECTION_CHECK=`cat conn_test.txt|grep "outcome"|awk -F'=>' '{print $2}'`
        MAX_POOL_SIZE=`cat conn_info.txt|grep "max-pool-size"|awk -F'=>' '{print $2}'`
        MIN_POOL_SIZE=`cat conn_info.txt|grep "min-pool-size"|awk -F'=>' '{print $2}'`
        ACTIVE_COUNT=`cat conn_info.txt|grep "ActiveCount"|awk -F'=>' '{print $2}'`
        IN_USE_COUNT=`cat conn_info.txt|grep "InUseCount"|awk -F'=>' '{print $2}'`
        MAX_IN_USE_COUNT=`cat conn_info.txt|grep "MaxUsedCount"|awk -F'=>' '{print $2}'`

# Print output  
printf " %-15s : %-15s\n" "DATASOURCE" " $DS_NAME"
if [ $TEST_CONNECTION_CHECK == "success" ]
then
        printf " %-15s : %-15s\n" "connection" " OK"
else
        printf " %-15s : \e[37;41m %-15s \033[0m \n" "connection" "DISCONNECT"
fi
printf " %-15s : %-10s\n" "min_pool_size" "$MIN_POOL_SIZE"
printf " %-15s : %-10s\n" "max_pool_size" "$MAX_POOL_SIZE"
printf " %-15s : %-10s\n" "ActiveCount" "$ACTIVE_COUNT"
printf " %-15s : %-10s\n" "InUseCount"  "$IN_USE_COUNT"
printf " %-15s : %-10s\n" "MaxInUseCount" "$MAX_IN_USE_COUNT"
printf "%s\n" "--------------------------------------------------"
done

rm -f ./DS_info.txt ./conn_info.txt  ./conn_test.txt
