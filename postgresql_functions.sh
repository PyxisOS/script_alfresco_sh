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
# POSTGRESQL METHODS
#########################################################################################
# This script containd methods for postgress



# load file of properties
if [ -f ./alfresco_prop.properties ]; then
         . ./alfresco_prop.properties
else
        echo missing alfresco_prop.properties
fi

# create log file
	
#######################################
# start postgresql
#######################################
start_postgresql() {
	echo "### Start postgresql service ###"
	cd /
	cd $1
	START_POST=$(sh alfresco.sh start postgresql)
	CHECK_RUNNING="$(check_if_postgresql_is_running $1)"
	if [ ! "$CHECK_RUNNING" = "running" ]; then
		echo [$(date +${FORMAT})]" postgresql is up"
	else 
		echo "there is some problem to start postgresql"
	fi
}


#######################################
# stop postgresql
#######################################
stop_postgresql() {
	echo "### Stop postgresql service ###" 
	cd $1
	STOP_POST=$(sh alfresco.sh stop postgresql)
	CHECK_RUNNING="$(check_if_postgresql_is_running $1)"
	if [ ! "$CHECK_RUNNING" = "not running" ]; then
		echo [$(date +${FORMAT})]" postgresql is down" 
	else 
		echo "there is some problem to stop postgresql"
	fi
}


#######################################
# check if alfresco is running
#######################################
check_if_postgresql_is_running() {
	cd /
	cd $1
	echo "### Check if postgresql is running ###"
	OUTPUT=$($1/alfresco.sh status postgresql)
	CHECK="postgresql already running"
	POSTGRESQL_STATUS=`echo $OUTPUT`

	if [ "$POSTGRESQL_STATUS" = "$CHECK" ]; then
		echo "running"
	else
		echo "not running"
	fi
}



#######################################
# backup database
#######################################
backup_database() {
	echo "### Backup database ###"
	start_postgresql $1
	POSTGRESQL=$1/postgresql/
	### create dump directories
	cd /
	echo [$(date +${FORMAT})]" backup the database"
	cd $POSTGRESQL/bin
	PGPASSWORD=${DBPASS} ${POSTGRESQL}bin/pg_dump -h localhost -p ${DBPORT} -U ${DBUSER} > "${DIR_BACKUP}/${NOW}/database/alfresco_db_dump"
	echo [$(date +${FORMAT})]" backup database with success!!!"
}




