#!/bin/sh
###########################
# JBOSS EAP 7.2           # 
###########################
# JGROUPS MEMBER          #
###########################

. ./health_env.sh

## JBoss Process Check ##
PID=`ps -ef | grep java | grep "SERVER=$SERVER_NAME " | awk '{print $2}'`

if [ e$PID == "e" ]
then
    echo "JBoss SERVER - $SERVER_NAME is Not RUNNING..."
    exit;
fi

./jboss-cli.sh --command="/subsystem=jgroups/channel=ee:read-attribute(name=view,include-defaults)" |sed 's/"//g' > CLUSTER_INFO.txt


ADD_MEMBER=`cat CLUSTER_INFO.txt|grep "result" |awk '{print $3}'`
CURRENT_VIEW=`cat CLUSTER_INFO.txt|grep "result" | awk '{print $5" "$6}'`

printf "%s\n" "---------------------------------------------------"
printf "\e[1;34m %-10s\e[0m \n" "## JBOSS JGROUPS MEMBER CHECK ##"
printf "%s\n" "---------------------------------------------------"

if [[ e$CURRENT_VIEW == "e" ]]
then
        printf " %-20s : %-30s\n" "Current Members" "N/A"
        printf " %-20s : %-10s\n" "Add Member" "N/A"
else
        printf " %-20s : %-30s\n" "Current Members" "$CURRENT_VIEW"
        printf " %-20s : %-10s\n" "Add Member" "$ADD_MEMBER"
fi

printf "%s\n" "--------------------------------------------------"

rm -f CLUSTER_INFO.txt
