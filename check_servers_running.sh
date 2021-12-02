reated by Lucia Zarbano ###

### This script takes following arguments in sequence
### SERVER1: Path of Server 1
### SERVER2: Path of Server 2
### SERVER3: Path of Server 3
### SERVER4: Path of Server 4
### SERVER5: Path of Server 5

SOURCE="/opt/"
SERVER1="alfresco-develop"
SERVER2="alfresco-community"
SERVER3="alfresco-community-52"
SERVER4="alfresco-ce52"
SERVER5="alfresco-community_boh1"

PORTTOMCATS1="8082"
PORTTOMCATS2="8080"
PORTTOMCATS3="9080"
PORTTOMCATS4="5080"
PORTTOMCATS2="8080"

PORTPOSTGRESS1="5432"
PORTPOSTGRESS2="5432"
PORTPOSTGRESS3="5433"
PORTPOSTGRESS4="5432"
PORTPOSTGRESS5="5432"

#OUTPUT=${SOURCE}/${SERVER1}
SERVER_STATUS="sh alfresco.sh status tomcat"
POSTGRES_STATUS="sh alfresco.sh status postgresql"
CHECKPOSTGRESS="postgresql already running"
CHECKPOSTOMCAT="tomcat already running"
CONT=0

for varServer in ${SERVER1} ${SERVER2} ${SERVER3} ${SERVER4} ${SERVER5}
do
CONT=$CONT+1
echo "--------------------------------------------\n" 
cd / 
echo "chek if ${varServer} is running"
echo "--------------------------------------------\n" 
OUTPUT=$(${SOURCE}/${varServer}/alfresco.sh status postgresql)
POSTGRES_STATUS=`echo $OUTPUT`
if [ "$POSTGRES_STATUS" = "$CHECKPOSTGRESS" ]; then 
echo "POSTGRESQL IS RUNNING\n"
else 
echo "postgress not running\n"
fi

OUTPUT_TOMCAT=$(${SOURCE}/${varServer}/alfresco.sh status tomcat)
TOMCAT_STATUS=`echo $OUTPUT_TOMCAT`
if [ "$TOMCAT_STATUS" = "$CHECKPOSTOMCAT" ]; then 
echo "TOMCAT IS RUNNING\n"
else 
echo "tomcat not running\n"
fi
done
