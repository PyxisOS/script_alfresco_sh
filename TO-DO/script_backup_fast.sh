reated by ContCentric IT Services Pvt. Ltd.- http//www.contcentric.com ###

### This script takes following arguments in sequence
### DBUSER: Postgresql databse user
### DBPASS: Postgresql database password
### DBPORT: Port on which your postgresql is running
### SOURCE: Alfresco home path - e.g. /opt/alfresco-community
### DESTINATION: Path to the directory where you want to store backup e.g /home/admin/backup

### e.g. sh alfresco-backup.sh alfresco admin 5432 /opt/alfresco-community /home/admin/backup

### *note - Destination folder must be present
###       - Default database host name is taken 'localhost', you have to change it accordingly

DBUSER=alfresco
DBPASS=alfresco
DBPORT=5432
SOURCE=/opt/alfresco-community
DESTINATION=/root/COMPLETE-BACKUP

OUTPUT=$(${SOURCE}/alfresco.sh status postgresql)
POSTGRES_STATUS=`echo $OUTPUT`
CHECK="postgresql already running"
NOW=$(date +"%m-%d-%Y-%H-%M-%S")
FORMAT="%m-%d-%Y-%H-%M-%S"

if [ "$POSTGRES_STATUS" = "$CHECK" ]; then 
CONTENTSTORE=${SOURCE}/alf_data/ 
POSTGRESQL=${SOURCE}/postgresql/ 

echo [$(date +${FORMAT})]"Performing Database Backup" 
echo "--------------------------------------------\n" 

cd / 
cd $DESTINATION 
mkdir "$NOW" 
cd "$NOW" 
mkdir alf_data 
mkdir database 

cd $POSTGRESQL/bin
pwd 
PGPASSWORD=${DBPASS} ${POSTGRESQL}bin/pg_dump -h localhost -p ${DBPORT} -U ${DBUSER} > "${DESTINATION}/${NOW}/database/alfresco_db_dump" 
echo [$(date +${FORMAT})]"Performing ContentStore backup" 

echo "--------------------------------------------\n" 
cp -R ${CONTENTSTORE} "${DESTINATION}/$NOW" 
echo [$(date +${FORMAT})]"Backup Completed" 

echo "--------------------------------------------\n" 

#echo [$(date +${FORMAT})]"Deleting old backups" 
### Following two lines are meant to retain only last 5 backups at destination 
#cd ${DESTINATION} #ls -1tr | head -n -5 | xargs -d '\n' rm -rf -f -- 
#echo "--------------------------------------------\n" 

else 

echo [$(date +${FORMAT})]"Postgresql Database Server is not running, aborting alfresco backup" 

fi
