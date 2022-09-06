#!/bin/sh
###########################
# JBOSS EAP 7.2           # 
###########################
# HealthCheck V0.1        #
############################

. ./health_env.sh

## JBoss Process Check ##
PID=`ps -ef | grep java | grep "SERVER=$SERVER_NAME " | awk '{print $2}'`

if [ e$PID == "e" ]
then
    echo "JBoss SERVER - $SERVER_NAME is Not RUNNING..."
    exit;
fi

### Deployment APPS GET ###
./jboss-cli.sh --command="/deployment=*/subsystem=undertow:read-resource(include-runtime=true)" | sed 's/["|,]//g' > session_info.txt
DEPLOY_APPS=`cat session_info.txt|grep "deployment"|awk -F'=>' '{print $2}'`

printf "%s\n" "--------------------------------------------------"
printf "\e[1;34m %-10s\e[0m \n" "## ACTIVE SESSION CHECK ##"
printf "%s\n" "--------------------------------------------------"

### Deployed APPS Session GET ###
for DEPLOY_APP in $DEPLOY_APPS ;
do

ACTIVE_SESSION=`cat session_info.txt|grep $DEPLOY_APP -A 16 | grep "active-sessions" | grep -v max | awk -F'=>' '{print $2}'`
MAX_ACTIVE_SESSIONS=`cat session_info.txt|grep $DEPLOY_APP  -A 16 | grep "max-active-sessions"| awk -F'=>' '{print $2}'`
SESSION_CREATED=`cat session_info.txt|grep $DEPLOY_APP -A 16 | grep "sessions-created" | awk -F'=>' '{print $2}'`
EXPIRED_SESSION=`cat session_info.txt|grep $DEPLOY_APP -A 16 | grep "expired-sessions" | awk -F'=>' '{print $2}'`

# Print output  
APPLICATION=`echo $DEPLOY_APP | sed 's/)//'`
printf " %-20s : %-15s\n" "APPLICATION" "$APPLICATION"
printf " %-20s : %-10s\n" "active-sessions" "$ACTIVE_SESSION"
printf " %-20s : %-10s\n" "max-active-sessions" "$MAX_ACTIVE_SESSIONS"
printf " %-20s : %-10s\n" "sessions-created" "$SESSION_CREATED"
printf " %-20s : %-10s\n" "expired-sessions" "$EXPIRED_SESSION"
printf "%s\n" "--------------------------------------------------"
done

rm -f ./session_info.txt

