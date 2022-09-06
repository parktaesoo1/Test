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

printf "%s\n" "--------------------------------------------------"
printf "\e[1;34m %-10s\e[0m \n" "## THREAD POOL CHECK ##"
printf "%s\n" "--------------------------------------------------"

### IO Threads INFO ###
./jboss-cli.sh --command='/subsystem=io/worker=default:read-resource(include-runtime)' | sed 's/[,|"]//g' > io_status.txt

IO_THREADS=`cat io_status.txt | grep "io-threads" | awk -F'=>' '{print $2}'`
IO_THREAD_COUNT=`cat io_status.txt | grep "io-thread-count" | awk -F'=>' '{print $2}'`
MAX_POOL_SIZE=`cat io_status.txt | grep "max-pool-size" | awk -F'=>' '{print $2}'`
TASK_MAX_THREAS=`cat io_status.txt | grep "task-max-threads" | awk -F'=>' '{print $2}'`
BUSY_TASK_THREAD_COUNT=`cat io_status.txt | grep "busy-task-thread-count " | awk -F'=>' '{print $2}'`
QUEUE_SIZE=`cat io_status.txt | grep "queue-size" | awk -F'=>' '{print $2}'`

# Print output  
printf " %-25s : %-10s\n" "IO_THREADS" "$IO_THREADS"
printf " %-25s : %-10s\n" "IO_THREAD_COUNT" "$IO_THREAD_COUNT"
printf " %-25s : %-10s\n" "MAX_POOL_SIZE" "$MAX_POOL_SIZE"
printf " %-25s : %-10s\n" "TASK_MAX_THREAS"  "$TASK_MAX_THREAS"
printf " %-25s : %-10s\n" "BUSY_TASK_THREAD_COUNT" "$BUSY_TASK_THREAD_COUNT"
printf " %-25s : %-10s\n" "QUEUE_SIZE" "$QUEUE_SIZE"
printf "%s\n" "--------------------------------------------------"

rm -f ./io_status.txt
