#!/bin/bash


### ALFRESCO COLD BACKUP
### 1. Stop Alfresco Content Service
### 2. Backup Database
### 3. Backup dir.root directories (contentstore e contentstore.deleted)
### 4. Store database e dir.root directory toghether as a singole unit (opzionale)
### 5. Start Content Service

 
# load file of properties
if [ -f ./alfresco_prop.properties ]; then
         . ./alfresco_prop.properties
else
        echo missing alfresco_prop.properties
fi


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

echo "****************************************************" >> ${LOG_FILE} 
echo "******* START COLD BACKUP ALFRESCO PROCEDURE ********" >> ${LOG_FILE}
echo "****************************************************" >> ${LOG_FILE} 


### STEP 1 ###
echo "\n" >> ${LOG_FILE}
echo "### STEP 1: Stop Alfresco Content Service ###" >> ${LOG_FILE}
cd $ALF_DIR_ROOT
sh alfresco.sh stop
echo [$(date +${FORMAT})]" alfresco is down"  >> ${LOG_FILE}


### STEP 2 ###
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
	echo [$(date +${FORMAT})]"Postgresql Database Server is not running, aborting alfresco backup" 
fi
### create dump directories
cd /
echo [$(date +${FORMAT})]" backup the database"  >> ${LOG_FILE}
cd $POSTGRESQL/bin
PGPASSWORD=${DBPASS} ${POSTGRESQL}bin/pg_dump -h localhost -p ${DBPORT} -U ${DBUSER} > "${DIR_BACKUP}/${NOW}/database/alfresco_db_dump"
echo [$(date +${FORMAT})]" backup database with success!!!" >> ${LOG_FILE}


### STEP 3 ###
echo "\n" >> ${LOG_FILE}
echo "### STEP 3: BACKUP THE CONTENTSTORE" >>  ${LOG_FILE}
echo [$(date +${FORMAT})]" copy contentstore e contentstore.deleted in ${DIR_BACKUP}/${NOW}" >> ${LOG_FILE}
cd /
echo ${ALF_CONTENTSTORE}
echo ${DIR_BACKUP}/${NOW}
cp -R "${ALF_CONTENTSTORE}" "${DIR_BACKUP}/${NOW}"
cp -R "${ALF_CONTENTSTORE_DELETED}" "${DIR_BACKUP}/${NOW}/"
echo [$(date +${FORMAT})]" CONTENTSTORE directory copied with success!!!!!!" >> ${LOG_FILE}


### STEP 4 ###
echo "\n" >> ${LOG_FILE}
echo "### STEP 4: STORE ALL AS SINGLE UNIT" >>  ${LOG_FILE}
echo [$(date +${FORMAT})]" zip backup directory as ${NOW}.zip and remove ${NOW} directory in ${DIR_BACKUP}" >> ${LOG_FILE}
if [ "$ZIPBACKUP" = true ]; then
	cd /
	cd ${DIR_BACKUP}
	zip -r -q -T -m ${NOW}.zip ${NOW}
	rm -rf ${NOW}
	echo [$(date +${FORMAT})]" create archive zipped with success" >> ${LOG_FILE}
fi


### STEP 5 ###
echo "\n### STEP 5: START ALFRESCO CONTENT SERVICE ***"
cd /
cd $ALF_DIR_ROOT
sh alfresco.sh start
echo [$(date +${FORMAT})]" alfresco is running" >> ${LOG_FILE}


echo "\n" >> ${LOG_FILE}
echo "****************************************************" >> ${LOG_FILE} 
echo "******* END COLD BACKUP ALFRESCO PROCEDURE ********" >> ${LOG_FILE}
echo "****************************************************" >> ${LOG_FILE} 

