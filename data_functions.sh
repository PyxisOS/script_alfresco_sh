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
# Backup dir.root 
#######################################
backup_dir_root(){
	echo "\n### Backup dir.root of "$1
	echo [$(date +${FORMAT})]" copy dir.root in ${DIR_BACKUP}/${NOW}"
	cd /
	cp -R "$1/$DIR_ROOT_NAME" "${DIR_BACKUP}/${NOW}"
	echo [$(date +${FORMAT})]" $1/$DIR_ROOT_NAME directory copied with success!!!!!!"
}


#######################################
# Backup solr4 indexes
#######################################
#sistemare
backup_indexes(){
	echo "\n### Backup Solr4Backup"
	CHECK_INDEXES="$(check_if_dirindexes_exists $1)"
	if [ "$CHECK_INDEXES" = "exists" ]; then
		echo [$(date +${FORMAT})]" copy solr4backup in ${DIR_BACKUP}/$NOW"
		cd /
		cp -R "$1/$DIR_ROOT_NAME/$SOLR_BACKUP_DIR" "${DIR_BACKUP}/${NOW}"
		echo [$(date +${FORMAT})]" $1/$DIR_ROOT_NAME/$SOLR_BACKUP_DIR directory copied with success!"
	else 
		echo "solr4backup directory doesn't exists, aborting backup indexes"
	fi
}


#######################################
# Backup solr4 indexes
#######################################
backup_contentstore(){
	echo "\n### Backup contentstore and contentstore.deleted"
	echo [$(date +${FORMAT})]" copy contentstore in ${DIR_BACKUP}/$NOW"
	echo [$(date +${FORMAT})]" copy contentstore.deleted in ${DIR_BACKUP}/$NOW"
	cd /
	cp -R "$1/$DIR_ROOT_NAME/contentstore" "${DIR_BACKUP}/${NOW}"
	cp -R "$1/$DIR_ROOT_NAME/contentstore.deleted" "${DIR_BACKUP}/${NOW}"
	echo [$(date +${FORMAT})]" $1/$DIR_ROOT_NAME/contentstore directory copied with success!"
	echo [$(date +${FORMAT})]" $1/$DIR_ROOT_NAME/contentstore.deleted directory copied with success!"

}


#######################################
# Check if solr4dirbackup exists
#######################################
check_if_dirindexes_exists(){
	echo "\n### Check if solr4Backup exists under $1/$ALF_DIR_NAME ###"
	#check if solr4backup exists
	if [ -d "$1/$ALF_DIR_NAME" ]; then
		echo "exists"
	else
	    echo "not exists"
	fi
}


