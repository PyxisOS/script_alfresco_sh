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
if [ -f ./acs_functions.sh ]; then
         . ./acs_functions.sh
else
        echo missing ./acs_functions.sh
fi


# load file of postgresql methods
if [ -f ./postgresql_functions.sh ]; then
         . ./postgresql_functions.sh
else
        echo missing ./postgresql_functions.sh
fi


# load file of utility methods
if [ -f ./utility_functions.sh ]; then
         . ./utility_functions.sh
else
        echo missing ./utility_functions.sh
fi


# load file of data methods
if [ -f ./data_functions.sh ]; then
         . ./data_functions.sh
else
        echo missing ./data_functions.sh
fi


### COLD BACKUP PROCEDURE ###

# 0. Configure directory of backup 
# 1. Stop Alfresco Content Service
# 2. Backup Database
# 3. Backup ContentStore
# 4. Backup Indexes
# 5. Start Alfresco

# 0. configure dir backup
configure_dir_backup

# 1.Stop ACS
stop_alfresco ${ALF_DIR_ROOT}

# 2.Backup Database
backup_database ${ALF_DIR_ROOT}

# 3. Backup Contentstore
backup_contentstore ${ALF_DIR_ROOT}

# 4. Backup Indexes
backup_indexes ${ALF_DIR_ROOT}

# 5. Start ACS
start_alfresco ${ALF_DIR_ROOT}
