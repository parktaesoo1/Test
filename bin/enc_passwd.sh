#!/usr/bin/env bash

###############################
# DataSource Password Encrypt #
###############################
# JBOSS EAP 6.x / 7.x         #
###############################

BASEDIR=$(dirname "$0")
. $BASEDIR/env.sh

echo $BASEDIR

SNAME=$1
ACCOUNT=$2
PASSWORD=$3
DBNAME=$4

## PATH SETTING ##
OVERLAYS=`ls -al $JBOSS_HOME/modules/system/layers/base/ |grep .overlays`
LOGGING_FILE_PATH="modules/system/layers/base/org/jboss/logging/main"
LOGGING_FILE=`ls $JBOSS_HOME/$LOGGING_FILE_PATH |grep -v module`

if [ ! -z "$OVERLAYS" ]; 
then
  JBOSS_VERSION_CP=`ls -r $JBOSS_HOME/modules/system/layers/base/.overlays |head -n 1`
  PICKETBOX_PATH="modules/system/layers/base/.overlays/$JBOSS_VERSION_CP/org/picketbox/main"   
  PICKETBOX_FILE=`ls $JBOSS_HOME/$PICKETBOX_PATH |grep -v module |head -n 1`
else
  PICKETBOX_PATH="modules/system/layers/base/org/picketbox/main"
  PICKETBOX_FILE=`ls $JBOSS_HOME/$PICKETBOX_PATH |grep -v module |head -n 1`
fi

## DBNAME CHECK ##
str_chk=`echo "$DBNAME" | egrep "(.*)\/(.*)$" | wc -l`

if [[ $str_chk ]];
then
        DBNAME=`echo "$DBNAME" | sed -e 's/\//\\\\\//g'`
fi

## CHECK INPUT DATA ## 
if [ e$DBNAME == "e" ];
then
        echo " input DATASOURCE Info ....." 
        echo " ex ) ./enc_passwd.sh \"Security Domain name\" \"user name\" \"passwd\" \"datasource name\" " 
        exit 1
fi

#### CLASSPATH SETTING ####
export CLASSPATH=$JBOSS_HOME/$PICKETBOX_PATH/$PICKETBOX_FILE:$JBOSS_HOME/$LOGGING_FILE_PATH/$LOGGING_FILE:$CLASSPATH

### Passwd Encryption  #####
RESULT_LOW=`$JAVA_HOME/bin/java org.picketbox.datasource.security.SecureIdentityLoginModule $PASSWORD > enc.cli`
RESULT_1=`cut -f2 -d: enc.cli`
RESULT_2=`echo $RESULT_1`
echo "/subsystem=security/security-domain=$SNAME/:add(cache-type=default)" > enc.cli
echo "/subsystem=security/security-domain=$SNAME/authentication=classic:add(login-modules=[{\"code\"=>\"org.picketbox.datasource.security.SecureIdentityLoginModule\", \"flag\"=>\"required\", \"module-options\"=>[(\"username\"=>\"$ACCOUNT\"),(\"password\"=>\"$RESULT_2\")]}])" >> enc.cli
echo "/subsystem=datasources/data-source=$DBNAME:write-attribute(name=password,value=undefined)" >> enc.cli
echo "/subsystem=datasources/data-source=$DBNAME:write-attribute(name=user-name,value=undefined)" >> enc.cli
echo "/subsystem=datasources/data-source=$DBNAME:write-attribute(name=security-domain,value=$SNAME)">> enc.cli

./jboss-cli.sh --file=enc.cli

#rm -f enc.cli

##############################
echo "Security Domain name : $SNAME"
echo "DB Account : $ACCOUNT"
echo "password : $PASSWORD"
echo "Datasource pool name : $DBNAME"
echo "## END ##"

