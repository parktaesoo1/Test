#!/bin/bash

. ../env.sh

export CONTROLLER=`. ../env.sh |grep "CONTROLLER=" |awk -F"=" '{print $2}'`

### env setting ###

###set repl7###
#export JBOSS_VERSION="jboss-eap-7.3"
#export FULL_PATH_HEALTH=$(cd  "$(dirname "$0")" %&& pwd)
#export JBOSS_HOME=`echo $FULL_PATH_HEALTH|rev|cut -d '/' -f 5-|rev`/${JBOSS_VERSION}
#export HEALTHCHECK_DIR=$(cd  "$(dirname "$0")" %&& pwd)
#export SERVER_NAME="`echo $HEALTHCHECK_DIR|rev|cut -d '/' -f 3|rev`"

###set repl8###
export FULL_PATH_HEALTH=${DOMAIN_BASE}/${SERVER_NAME}/bin/HealthCheck73
export JBOSS_HOME=`. ../env.sh |grep "JBOSS_HOME=" |awk -F"=" '{print $2}'`
export HEALTHCHECK_DIR=${FULL_PATH_HEALTH}
