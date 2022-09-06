#!/bin/sh
. ./health_env.sh  > /dev/null

unset JAVA_OPTS
export JAVA_OPTS=" -Djava.awt.headless=false $JAVA_OPTS"

$JBOSS_HOME/bin/jboss-cli.sh  --controller=$CONTROLLER --connect $@
