#!/bin/bash
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


### COLD BACKUP PROCEDURE ###

# 0. Configure directory of backup 
# 1. Stop Alfresco Content Service
# 2. Backup Database
# 3. Backup ContentStore
# 4. Backup Indexes
# 5. Start Alfresco

###  SETTING LOG FILE ###
LOG_FILE=$(pwd)/logging.log

### LOAD FILE ###

# load file of properties
if [ -f ./alfresco_prop.properties ]; then
         . ./alfresco_prop.properties
else
        echo missing alfresco_prop.properties
fi


# load file of acs methods
if [ -f ./FUNCTIONS/acs_functions.sh ]; then
         . ./FUNCTIONS/acs_functions.sh
else
        echo missing ./FUNCTIONS/acs_functions.sh
fi


# load file of postgresql methods
if [ -f ./FUNCTIONS/postgresql_functions.sh ]; then
         . ./FUNCTIONS/postgresql_functions.sh
else
        echo missing ./FUNCTIONS/postgresql_functions.sh
fi


# load file of utility methods
if [ -f ./FUNCTIONS/utility_functions.sh ]; then
         . ./FUNCTIONS/utility_functions.sh
else
        echo missing ./FUNCTIONS/utility_functions.sh
fi


# load file of data methods
if [ -f ./FUNCTIONS/data_functions.sh ]; then
         . ./FUNCTIONS/data_functions.sh
else
        echo missing ./FUNCTIONS/data_functions.sh
fi


### COLD BACKUP PROCEDURE ###

# 0. Configure directory of backup 
# 1. Stop Alfresco Content Service
# 2. Backup Database
# 3. Backup ContentStore
# 4. Backup Indexes
# 5. Start Alfresco

echo "\n\n"

# 0. configure dir backup
echo "******** STEP 0: CONFIGURE DIRECTORY OF BACKUP ********"
configure_dir_backup
echo "******************************************************"

# 1.Stop ACS
echo "******** STEP 1: STOPPING ALFRESCO  ********"
stop_alfresco ${ALF_DIR_ROOT}
echo "******************************************************"
echo "\n\n"

echo "******** STEP 2: BACKUP DATABASE  ********"
# 2.Backup Database
backup_database ${ALF_DIR_ROOT}
echo "******************************************************"
echo "\n\n"

echo "******** STEP 3: BACKUP CONTENTSTORE  ********"
# 3. Backup Contentstore
backup_contentstore ${ALF_DIR_ROOT}
echo "******************************************************"
echo "\n\n"


echo "******** STEP 4: BACKUP INDEXES  ********"
# 4. Backup Indexes
backup_indexes ${ALF_DIR_ROOT}
echo "******************************************************"
echo "\n\n"


echo "******** STEP 5: START ALFRESCO CONTENT SERVICE  ********"
# 5. Start ACS
start_alfresco ${ALF_DIR_ROOT}
echo "******************************************************"
echo "\n\n"
