#!/bin/bash

### ALFRESCO HOT BACKUP ###
# 1. Check if solr4Backup exists under dir.root
# 2. Backup solr4Backup
# 3. Backup Database
# 4. Backup the others dir.root directories (contentstore, contentstore.deleted)
# 5. Store database e dir.root directory toghether as a singole unit (opzionale)


 
# load file of properties
if [ -f ./hot_backup_alfresco.properties ]; then
         . ./hot_backup_alfresco.properties
else
        echo missing hot_backup_alfresco.properties
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
echo "******* START HOT BACKUP ALFRESCO PROCEDURE ********" >> ${LOG_FILE}
echo "****************************************************" >> ${LOG_FILE} 


### STEP 1 ###
echo "\n" >> ${LOG_FILE}
echo "### STEP 1:CHECK IF  solrBackup EXISTS ###" >> ${LOG_FILE}
#check if solr4backup exists
if [ ! -d "${SOLR_DIR_BACKUP}" ]; then
	    echo [$(date +${FORMAT})]" solrBackup doesn't exists!" >> ${LOG_FILE}
        exit 1
else
        echo [$(date +${FORMAT})]" solrBackup exists in ${SOLR_DIR_BACKUP}!" >> ${LOG_FILE}
fi


### STEP 2 ###
echo "\n" >> ${LOG_FILE}
echo "### STEP 2: BACKUP SOLR4INDEX ###" >> ${LOG_FILE}
echo [$(date +${FORMAT})]" copy solr4backup in ${DIR_BACKUP}/$NOW"  >> ${LOG_FILE}
cp -R "${SOLR_DIR_BACKUP}" "${DIR_BACKUP}/$NOW"
echo [$(date +${FORMAT})]" SOLR4INDEX directory copied with success!!!" >> ${LOG_FILE}


### STEP 3 ###
echo "\n" >> ${LOG_FILE}
echo "### STEP 3: BACKUP THE DATABASE ###" >>  ${LOG_FILE}
#check if postgresql is running and dump the database
OUTPUT=$(${ALF_DIR_ROOT}/alfresco.sh status postgresql)
POSTGRES_STATUS=`echo $OUTPUT`
CHECK="postgresql already running"
if [ "$POSTGRES_STATUS" = "$CHECK" ]; then
        echo [$(date +${FORMAT})]" backup the database in ${DIR_BACKUP}/${NOW}/database as alfresco_db_dump" >>  ${LOG_FILE}
        cd ${POSTGRESQL_DB_DIR}/bin
#       PGPASSWORD=${DBPASS} pg_dump -h ${DBHOST} -p ${DBPORT} -U ${DBUSER} > "${DIR_BACKUP}/${NOW}/database/alfresco_db_dump"
        PGPASSWORD=${DBPASS} pg_dump -h ${DBHOST} -p ${DBPORT} -U ${DBUSER} > "${DIR_BACKUP}/${NOW}/database/alfresco_db_dump"
        echo [$(date +${FORMAT})]" backup database with success!!!" >> ${LOG_FILE}

else
        echo [$(date +${FORMAT})]"Postgresql Database Server is not running, aborting alfresco backup" 
        exit 2
fi


### STEP 4 ###
echo "\n" >> ${LOG_FILE}
echo "### STEP 4: BACKUP THE CONTENTSTORE" >>  ${LOG_FILE}
echo [$(date +${FORMAT})]" copy contentstore e contentstore.deleted in ${DIR_BACKUP}/${NOW}" >> ${LOG_FILE}
cd /
cp -R "${ALF_CONTENTSTORE}" "${DIR_BACKUP}/${NOW}"
cp -R "${ALF_CONTENTSTORE_DELETED}" "${DIR_BACKUP}/${NOW}/"
echo [$(date +${FORMAT})]" CONTENTSTORE directory copied with success!!!!!!" >> ${LOG_FILE}



### STEP 5 ###
echo "\n" >> ${LOG_FILE}
echo "### STEP 5: STORE ALL AS SINGLE UNIT" >>  ${LOG_FILE}
echo [$(date +${FORMAT})]" zip backup directory as ${NOW}.zip and remove ${NOW} directory in ${DIR_BACKUP}" >> ${LOG_FILE}
if [ "$ZIPBACKUP" = true ]; then
	cd /
	cd ${DIR_BACKUP}
	zip -r -q -T -m ${NOW}.zip ${NOW}
	rm -rf ${NOW}
	echo [$(date +${FORMAT})]" create archive zipped with success" >> ${LOG_FILE}
fi

echo "\n" >> ${LOG_FILE}
echo "****************************************************" >> ${LOG_FILE} 
echo "******* END HOT BACKUP ALFRESCO PROCEDURE ********" >> ${LOG_FILE}
echo "****************************************************" >> ${LOG_FILE} 
