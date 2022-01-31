#!/usr/bin
# This is a script that runs migration in Alfresco Content Service
#
# Copyright 2021 Lucy Zarbano
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#########################################################################################
# ALFRESCO CONTENT SERVICE METHODS
#########################################################################################
# This script containd methods for acs



# load file of properties
if [ -f ./alfresco_prop.properties ]; then
         . ./alfresco_prop.properties
else
        echo missing alfresco_prop.properties
fi


#######################################
# Start alfresco content service
#######################################
start_alfresco() {
	echo "### Start Alfresco Content Service ###" 
	cd $1
	START_POST=$(sh alfresco.sh start)
        CHECK_RUNNING="$(check_if_alfresco_is_running $1)"
	if [ ! "$CHECK_RUNNING" = "running" ]; then
		echo [$(date +${FORMAT})]" alfresco content service is up" 
	else 
		echo "there is some problem to start alfresco" 
	fi
}


#######################################
# Stop alfresco content service
#######################################
stop_alfresco() {
	echo "### Stop Alfresco Content Service ###"
	cd $1
	STOP_POST=$(sh alfresco.sh stop)
        CHECK_RUNNING="$(check_if_alfresco_is_running $1)"
	if [ ! "$CHECK_RUNNING" = "not running" ]; then
		echo [$(date +${FORMAT})]" alfresco content service is down"
	else 
		echo "there is some problem to stop alfresco"
	fi
}



#######################################
# check if alfresco is running
#######################################
check_if_alfresco_is_running() {
	cd /
	cd $1
	echo "### Check if alfresco is running ###"
	OUTPUT=$($1/alfresco.sh status)
	CHECK_RUNNING="tomcat already running postgresql already running"
	CHECK_NOT_RUNNING="tomcat not running postgresql not running"
	ACS_STATUS=`echo $OUTPUT`
	if [ "$ACS_STATUS" = "$CHECK_RUNNING" ]; then
		echo "running"
	elif [ "$ACS_STATUS" = "$CHECK_NOT_RUNNING" ]; then
		echo "not running"
	else 
		echo "not defined"
	fi
}
