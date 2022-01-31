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
# ALFRESCO CONTENT SERVICE MIGRATION PROCEDURE     
#########################################################################################
# This script runs the migrating of an instance of Alfresco Content Services running 
# on one server to another server

#########################################################################################
# ALFRESCO CONTENT SERVICE MIGRATION STEPS     
#########################################################################################
# 1. Stop Alfresco Content Service one
# 2. Export the database to dir.root
# 3. Copy the configuration directory to dir.root.
# 4. Back up dir.root
# 5. Install a compatible Alfresco Content Services server. This is typically an identical version to server 1.
# 6. Restore dir.root
# 7. Restore server configuration
# 8. If any configuration references server 1 explicitly, change these references to server 2.
# 10. Import the database from dir.root
# 11. Start the server

#######################################
# Print a given string
# GLOBALS:
#   A_STRING_PREFIX
# ARGUMENTS:
#   String to print
# OUTPUTS:
#   Write String to stdout
# RETURN:
#   0 if print succeeds, non-zero on error.
#######################################


# load file of properties
if [ -f ./alfresco_prop.properties ]; then
         . ./alfresco_prop.properties
else
        echo missing alfresco_prop.properties
fi


# load file of acs methods
if [ -f ./acs_methods.sh ]; then
         . ./acs_methods.sh
else
        echo missing ./acs_methods.sh
fi


#######################################
# Configure the directory for backup
#######################################
configure_dir_backup(){
	# create dir backup
	cd $DIR_BACKUP
	NOW=$(date +"%m-%d-%Y-%H-%M-%S")
	mkdir "$NOW"
	cd ${NOW}

	# create database dir backup
	mkdir database
	
	# create log file
	cd ../
	LOG_FILE=$(pwd)/${NOW}_logging.log
}


#######################################
# backup database to dir_backup
#######################################
backup_database() {
	echo "\n" >> ${LOG_FILE}
	echo "### STEP 2: BACKUP DATABASE ###" >> ${LOG_FILE}
	echo [$(date +${FORMAT})]" starting postgresql service"  >> ${LOG_FILE}
	cd $ALF_DIR_ROOT
	sh alfresco.sh start postgresql
	echo [$(date +${FORMAT})]" check if postgresql is running"  >> ${LOG_FILE}
	OUTPUT=$(${ALF_DIR_ROOT}/alfresco.sh status postgresql)
	POSTGRES_STATUS=`echo $OUTPUT`
	CHECK="postgresql already running"
	POSTGRESQL=${ALF_DIR_ROOT}/postgresql/
	if [ ! "$POSTGRES_STATUS" = "$CHECK" ]; then
		echo [$(date +${FORMAT})]"Postgresql Database Server is not running, aborting alfresco 		backup" 
	fi

	### create dump directories
	cd /
	echo [$(date +${FORMAT})]" backup the database"  >> ${LOG_FILE}
	cd $POSTGRESQL/bin
	PGPASSWORD=${DBPASS} ${POSTGRESQL}bin/pg_dump -h localhost -p ${DBPORT} -U ${DBUSER} > "${DIR_BACKUP}/${NOW}/database/alfresco_db_dump"
	echo [$(date +${FORMAT})]" backup database with success!!!" >> ${LOG_FILE}
}

#######################################
# backup dir_root
#######################################
backup_dir_root(){
	echo "\n" >> ${LOG_FILE}
	echo [$(date +${FORMAT})]" copy dir.root in ${DIR_BACKUP}/${NOW}" >> ${LOG_FILE}
	cd /
	cp -R "${ALF_DIR_ROOT}" "${DIR_BACKUP}/${NOW}"
	echo [$(date +${FORMAT})]"dir.root directory copied with success!!!!!!" >> 		${LOG_FILE}
}


#######################################
# restore dir_root
#######################################
restore_dir_root(){
	echo "\n" >> ${LOG_FILE}
	echo [$(date +${FORMAT})]" restore dir.root in {ALF_DIR_ROOT_MIGRATION}" >> ${LOG_FILE}
	cd /
	# rename dir.root of alfresco server migration
	cd ${ALF_DIR_ROOT_MIGRATION}
	mv "${ALF_DIR_ROOT_MIGRATION}/${DIR_ROOT_NAME_MIGRATION}" "${DIR_ROOT_NAME_MIGRATION}_bk"
	cp -R "${DIR_BACKUP}/${NOW}/{DIR_ROOT_NAME}" "${ALF_DIR_ROOT}"
	echo [$(date +${FORMAT})]"dir.root directory copied with success!!!!!!" >> 		${LOG_FILE}
}


#######################################
# restore server configuration
#######################################
restore_server_configuration(){
	echo "\n" >> ${LOG_FILE}
	echo [$(date +${FORMAT})]" restore server configuration " >> ${LOG_FILE}
	cd /
	# rename extension root of alfresco server migration
	cd ${ALF_DIR_ROOT_MIGRATION}
	mv "${ALF_DIR_ROOT_MIGRATION}/tomcat/shared/classes/alfresco/extension" "extension_bk"
	# copy extension root of alfresco server origin
	cp -R "${DIR_BACKUP}/${NOW}/extension" "${ALF_DIR_ROOT_MIGRATION}/tomcat/shared/classes/alfresco/"
	echo [$(date +${FORMAT})]"server extension directory copied with success!!!!!!" >> 		${LOG_FILE}
}



#######################################
# restore database from dir_backup
#######################################
restore_database() {
	echo "\n" >> ${LOG_FILE}
	echo "### RESTORE DATABASE ###" >> ${LOG_FILE}
	
	start_postgresql $ALF_DIR_ROOT_MIGRATION
	
	### create dump directories
	cd /
	echo [$(date +${FORMAT})]" restore the database"  >> ${LOG_FILE}
	cd $POSTGRESQL/bin
	PGPASSWORD="$PGSQL_BINDIR/$PGSQLRESTORE_BIN -h $DBHOST -U $DBUSER -d $DBNAME ${DIR_BACKUP}/${NOW}/database/alfresco_db_dump"
	echo [$(date +${FORMAT})]" restore database with success!!!" >> ${LOG_FILE}
}


start_postgresql(){
	echo [$(date +${FORMAT})]" starting postgresql service"  >> ${LOG_FILE}
	cd $1
	sh alfresco.sh start postgresql
	echo [$(date +${FORMAT})]" check if postgresql is running"  >> ${LOG_FILE}
	OUTPUT=$($1}/alfresco.sh status postgresql)
	POSTGRES_STATUS=`echo $OUTPUT`
	CHECK="postgresql already running"
	POSTGRESQL=${ALF_DIR_ROOT}/postgresql/
	if [ ! "$POSTGRES_STATUS" = "$CHECK" ]; then
		echo [$(date +${FORMAT})]"Postgresql Database Server is not running, aborting alfresco 		backup" 
	fi
}



# STEP 0 
configure_dir_backup

# STEP 1
stop_alfresco $ALF_DIR_ROOT

# STEP 2
#backup_database

# STEP 3
#cp -r {$ALF_DIR_ROOT}/tomcat/shared/classes/alfresco/extension ${DIR_BACKUP}/${NOW}

# STEP 4
#backup_dir_root

# STEP 5
# to do manually

# STEP 6
#stop_alfresco migration
#restore_dir_root

# STEP 7
#restore_server_configuration
# runs other configuration to restore manually

# STEP 8 
#restore_database

# STEP 8
#start_alfresco migration

