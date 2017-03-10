#!/bin/bash
# A script to query Zenoss availability stats for Menzies
#
GUID=ee13de6f-db16-40c8-a0ad-4855284d117a
DATE=$(date +%d%B%Y)
DAY=$(date +%d)
[[ $DAY == 0? ]] && DAY=$(echo $DAY |cut -c 2-)
MONTHYEAR=$(date +%m%Y)
TODAY=$(date +%Y%m%d)
STARTLASTMONTH=$(date -d "$(date +%Y-%m-01) -1 month" +%Y%m01)
ENDLASTMONTH=$(date -d "$(date +%Y-%m-01) -1 day" +%Y%m%d)
DIR=/data/menzies
MONTHSOFAR=$DIR/monthsofar/menzies-avail-monthsofar-$DATE
LASTMONTH=$(date -d "$(date +%Y-%m-01) -1 month" +%b%Y)
LASTMONTHOUT=$DIR/avail-$LASTMONTH
FIRSTDAYOFMONTH=$(date +%Y%m01)
# Do stuff
su - zenoss -c "ssh hounu122 company_availability_report -c $GUID -s $FIRSTDAYOFMONTH -e $TODAY --csv --raw-data" > $MONTHSOFAR
[[ $(date +%d) = 01 ]] && su - zenoss -c "ssh hounu122 company_availability_report -c $GUID -s $STARTLASTMONTH -e $ENDLASTMONTH --csv --raw-data" > $LASTMONTHOUT
su - zenoss -c "ssh hounu122 company_availability_report -c $GUID -s $STARTLASTMONTH -e $ENDLASTMONTH --csv --raw-data" > $LASTMONTHOUT
# Post to DB
for DEVICE in $(egrep "Server|Power|Network" $MONTHSOFAR|awk -F, '{ print $2 }')
	do
	CUST=$(grep -w $DEVICE $MONTHSOFAR| awk -F, '{ print $1 }')
	DEV=$(grep -w $DEVICE $MONTHSOFAR| awk -F, '{ print $2 }')
	CLASS=$(grep -w $DEVICE $MONTHSOFAR| awk -F, '{ print $3 }')
	VAL=$(grep -w $DEVICE $MONTHSOFAR| awk -F, '{ print $4 }'|sed 's/%//g')
	ssh sun5dub5sv02 curl -X POST -F \"customer=$CUST\" -F \"device=$DEV\" -F \"class=$CLASS\" -F \"value=$VAL\" https://reporting.sungardeurope.com/index.php/scripting/LogDeviceAvailability
done
