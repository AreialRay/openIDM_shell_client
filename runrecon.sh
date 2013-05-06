#!/bin/bash
#OpenIDM Shell Client
#https://github.com/smof/openIDM_shell_client
#Runs a reconcilation job for specific mapping definition

#check that jq util is present
JQ_LOC="$(which jq)"
if [ "$JQ_LOC" = "" ]; then
   	echo "JSON parser jq not found.  Download from http://stedolan.github.com/jq/download/"
   	exit
fi

#check if curl is installed
CURL_LOC="$(which curl)"
if [ "$CURL_LOC" = "" ]; then
	echo "Curl not found.  Please install sudo apt-get install curl etc..."
	exit
fi

#check that arg is passed
if [ "$1" = "" ]; then
	echo "Argument missing.  Requires argument mapping name from appropriate conf/sync.json"
	echo "Eg. ./runrecon.sh systemHrdb_managedUser"
	exit
fi

#suck in username and password details
OPENIDM_SERVER=$(jq '.server' settings.json | sed 's/\"//g')
OPENIDM_SERVER_PORT=$(jq '.port' settings.json)
USERNAME=$(jq '.username' ./settings.json | sed 's/\"//g')
PASSWORD=$(jq '.password' ./settings.json | sed 's/\"//g')

#construct URL
URL="http://$OPENIDM_SERVER:$OPENIDM_SERVER_PORT/openidm/recon?_action=recon&mapping=$1"

#run parses JSON response to for pretty reading
curl --request POST --header "X-OpenIDM-Username: $USERNAME" --header "X-OpenIDM-Password: $PASSWORD" $URL | jq .

