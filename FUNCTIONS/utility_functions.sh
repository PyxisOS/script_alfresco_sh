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
# UTILITY FUNCTIONS
#########################################################################################
# This script contains generic functions



# load file of properties
if [ -f ./alfresco_prop.properties ]; then
         . ./alfresco_prop.properties
else
        echo missing alfresco_prop.properties
fi



#######################################
# Configure the directory for backup
#######################################
configure_dir_backup(){
	# create dir backup
        echo "### Create dir backup ####"
	cd $DIR_BACKUP
	NOW=$(date +"%m-%d-%Y-%H-%M-%S")
	mkdir "$NOW"
	cd ${NOW}


	# create database dir backup
	mkdir database
        echo "created directory: "$(pwd)"/database"	

	# create log file
	cd ../
	LOG_FILE=$(pwd)/${NOW}_logging.log
}
