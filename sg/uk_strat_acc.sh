#!/bin/bash
###################################################################################
#
# uk_strat_acc.sh
# -----------------
# Takes input from Service Now reports and processes them for daily report to TOC
# management to track open Incidents, based on global_open.sh
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 13/02/16 |  PRF   | First edition
# ---------------------------------------------------------------------------------
# 
# Improvements:
# 1. I will include descriptions of how the data is gathered . i.e. what it means when it says .late Changes.
# 2. I will include details of the overdue Change, Requests and Incidents in a table of dates, names, assignment groups, etc. at the bottom of the report
# 3. Availability . we can perhaps  use tickets relating to the lack of availability rather than a % figure
# 4. IL3 - a) Can we actually get this added to the daily report? b) How do we distinguish between IL3 and Serco when we're talking about Serco LCC on IL2?
# DONE Incidents . I.ll track those affecting Swedish/Irish customers not just those assigned to Irish/Swedish resources
# 6. Format - we could use bar charts rather than line or area graphs
# 7. Requests - it'd be useful to see those days when these are overdue, not just total numbers.
# 8. Grant . suggested total number of open tickets and % of open tickets that are overdue
# 9. IL2/3 - first time fix? Can we do this in SN? We do it in Cherwell.
###################################################################################
# Set variables
TIXDIR=/data/sn
STRATDIR=/data/strat
ALLEURTIX=$TIXDIR/GlobalXOpenXIncidentsXPFXExport.csv
ALLTIX=$TIXDIR/UKXOpenXINCXCHGXRITM.csv
CHGSLA=$TIXDIR/ChangeXSLA.csv
OPEN=$TIXDIR/GlobalXOpenXIncidentsXPFXExport.csv
CLOSED=$TIXDIR/UKXClosedXYesterdayXINCXCHGXRITM.csv
IL3FILE=$STRATDIR/il3
# Dates
DATE=$(date +%Y-%m-%d" "%H:%M:%S)
DDATE=$(date +%b" "%d)
CHDATE=$(date +%d" "%b)
MAILDATE=$(date +%d" "%B" "%Y)
FILEDATE=$(date +%d%b%Y)
datediff() {
     d1=$(date -d "$1" +%s)
     d2=$(date -d "$2" +%s)
     echo $(( (d1 - d2) / 86400 )) days
}
IFS='"'
IFS='"'
# Files
INCFILE=$STRATDIR/incidents3
INCFILEG=$STRATDIR/incidents_global
INCPERCENTFILE=$STRATDIR/incidents_percent
REQFILE=$STRATDIR/requests3
CHGFILE=$STRATDIR/changes
CHGFILEG=$STRATDIR/changes_global
AVAILFILE=$STRATDIR/availability
TEMPLATE=$STRATDIR/template3.html
MAILFILE=$STRATDIR/strat-$FILEDATE.html
URLFILE=$STRATDIR/url-$FILEDATE.html
#
# Incidents
#
GLOBALALL=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved") { print }' |wc -l)
UKALL=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($10!~/FR |IE |SE /) { print }' |wc -l)
IEALL=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($10~"IE ") { print }' |wc -l)
SEALL=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($10~"SE ") { print }' |wc -l)
FRALL=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($10~"FR ") { print }' |wc -l)
MNZALL=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($12~"Menzies") { print $6 }' |wc -l)
SERCOALL=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($12~"Serco") { print $6 }' |wc -l)
GLOBALINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600) { print $6 }' |wc -l)
UKINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($10!~/FR |IE |SE /) { print $6 }' |wc -l)
IEINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($10~"IE ") { print $6 }' |wc -l)
SEINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($10~"SE ") { print $6 }' |wc -l)
IEINCCUST15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($27~"Ireland") { print $6 }' |wc -l)
SEINCCUST15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($27~"Sweden") { print $6 }' |wc -l)
FRINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($10~"FR ") { print $6 }' |wc -l)
MNZINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($12~"Menzies") { print $6 }' |wc -l)
SERCOINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($12~"Serco") { print $6 }' |wc -l)
GLOBALINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800) { print $6 }' |wc -l)
UKINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($10!~/FR |IE |SE /) { print $6 }' |wc -l)
IEINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($10~"IE ") { print $6 }' |wc -l)
SEINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($10~"SE ") { print $6 }' |wc -l)
IEINCCUST7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&(($27~"Ireland") { print $6 }' |wc -l)
SEINCCUST7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($27~"Sweden") { print $6 }' |wc -l)
FRINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($10~"FR ") { print $6 }' |wc -l)
MNZINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($12~"Menzies") { print $6 }' |wc -l)
SERCOINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($12~"Serco") { print $6 }' |wc -l)
GLOBALINC30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000) { print $6 }' |wc -l)
UKINC30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000)&&($10!~/FR |IE |SE /) { print $6 }' |wc -l)
IEINC30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000)&&($10~"IE ") { print $6 }' |wc -l)
SEINC30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000)&&($10~"SE ") { print $6 }' |wc -l)
IEINCCUST30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000)&&($27~"Ireland") { print $6 }' |wc -l)
IEINCCUSTO30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000)&&($27~"Ireland") { print $6 }' |wc -l)
SEINCCUST30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000)&&($27~"Sweden") { print $6 }' |wc -l)
SEINCCUSTO30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000)&&($27~"Sweden") { print $6 }' |wc -l)
FRINC30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000)&&($10~"FR ") { print $6 }' |wc -l)
MNZINC30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000)&&($12~"Menzies") { print $6 }' |wc -l)
MNZINCO30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000)&&($12~"Menzies") { print $6 }' |wc -l)
SERCOINC30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000)&&($12~"Serco") { print $6 }' |wc -l)
SERCOINCO30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000)&&($12~"Serco") { print $6 }' |wc -l)
GLOBALPERCENT30=$((GLOBALINC30*100/$GLOBALALL))
UKPERCENT30=$((UKINC30*100/$UKALL))
IEPERCENT30=$((IEINC30*100/$IEALL))
SEPERCENT30=$((SEINC30*100/$SEALL))
MNZPERCENT30=$((MNZINC30*100/$MNZALL))
SERCOPERCENT30=$((SERCOINC30*100/$SERCOALL))
#IL3PERCENT30=$((IL3INC30*100/$IL3ALL))
IL3INC7=$(tail -1 $IL3FILE |awk -F, '{ print $3 }')	
IL3INC15=$(tail -1 $IL3FILE |awk -F, '{ print $4 }')	
IL3INCO30=$(tail -1 $IL3FILE |awk -F, '{ print $5 }')	
IL3INC30=$(($IL3INC7+$IL3INC15))
IL3INC3060=$(tail -1 $IL3FILE |awk -F, '{ print $6 }')
IL3INC6090=$(tail -1 $IL3FILE |awk -F, '{ print $7 }')
IL3INC90=$(tail -1 $IL3FILE |awk -F, '{ print $8 }')
#
# Changes - all and late for each are
#
unset IFS # The Change stuff gets upset by the IFS setting
IECHGALL=$(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"IE ") { print }' |wc -l)
IECHGLATE=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"IE ") { print $22 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|awk '($1 >= 7) { print $1 }'  |wc -l)
IECHG7=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"IE ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 7) { print $1 }'  |wc -l)
IECHG14=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"IE ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 14) { print $1 }'  |wc -l)
IECHGO30=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"IE ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30) { print $1 }'  |wc -l)
IECHG3060=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"IE ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30)&&($1 <=60) { print $1 }'  |wc -l)
IECHG6090=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"IE ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 60)&&($1 <= 90) { print $1 }'  |wc -l)
IECHG90=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"IE ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 90) { print $1 }'  |wc -l)
IECHG30=$(cat $CHGSLA|awk -F'","' '($6<2592000)&&(($8~"IE ")||($10~"Ireland")||($13~"IE")) { print }'|wc -l)
SECHGALL=$(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"SE ") { print }' |wc -l)
SECHGLATE=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"SE ") { print $22 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|awk '($1 >= 7) { print $1 }'  |wc -l)
SECHG7=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"SE ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 7) { print $1 }'  |wc -l)
SECHG14=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"SE ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 14) { print $1 }'  |wc -l)
SECHGO30=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"SE ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30) { print $1 }'  |wc -l)
SECHG3060=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"SE ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30)&&($1 <=60) { print $1 }'  |wc -l)
SECHG6090=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"SE ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 60)&&($1 <= 90) { print $1 }'  |wc -l)
SECHG90=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"SE ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 90) { print $1 }'  |wc -l)
SECHG30=$(cat $CHGSLA|awk -F'","' '($6<2592000)&&(($8~"SE ")||($10~"Sweden")||($13~"SE")) { print }'|wc -l)
MNZCHGALL=$(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Menzies") { print }' |wc -l)
MNZCHGLATE=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Menzies") { print $22 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days|awk '($1 >= 7) { print $1 }'  |wc -l)
MNZCHG7=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Menzies") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 7) { print $1 }'  |wc -l)
MNZCHG14=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Menzies") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 14) { print $1 }'  |wc -l)
MNZCHGO30=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Menzies") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30) { print $1 }'  |wc -l)
MNZCHG3060=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Menzies") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30)&&($1 <=60) { print $1 }'  |wc -l)
MNZCHG6090=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Menzies") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 60)&&($1 <= 90) { print $1 }'  |wc -l)
MNZCHG90=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Menzies") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 90) { print $1 }'  |wc -l)
MNZCHG30=$(cat $CHGSLA|awk -F'","' '($6<2592000)&&($12~"Menzies") { print }'|wc -l)
SERCOCHGALL=$(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Serco") { print }' |wc -l)
SERCOCHGLATE=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Serco") { print $22 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30) { print $1 }'  |wc -l)
SERCOCHG7=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Serco") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 7) { print $1 }'  |wc -l)
SERCOCHG14=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Serco") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 14) { print $1 }'  |wc -l)
SERCOCHGO30=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Serco") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30) { print $1 }'  |wc -l)
SERCOCHG3060=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Serco") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30)&&($1 <=60) { print $1 }'  |wc -l)
SERCOCHG6090=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Serco") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 60)&&($1 <= 90) { print $1 }'  |wc -l)
SERCOCHG90=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($7~"Serco") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 90) { print $1 }'  |wc -l)
SERCOCHGO30=$(cat $CHGSLA|awk -F'","' '($6>2592000)&&($12~"Serco") { print }'|wc -l)
FRCHGALL=$(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"FR ") { print }'|wc -l)
FRCHGLATE=$(for i in $(cat $ALLTIX |awk -F'",' '($21~"Change")&&($2~"FR ") { print $22 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|awk '($1 >= 30) { print $1 }'  |wc -l)
IL3CHGALL=$(tail -1 $IL3FILE |awk -F, '{ print $9 }')
IL3CHGLATE=$(tail -1 $IL3FILE |awk -F, '{ print $10 }')
IL3CHG7=$(tail -1 $IL3FILE |awk -F, '{ print $11 }')
IL3CHG14=$(tail -1 $IL3FILE |awk -F, '{ print $12 }')
IL3CHG30=$(tail -1 $IL3FILE |awk -F, '{ print $13 }')
IL3CHG3060=$(tail -1 $IL3FILE |awk -F, '{ print $14 }')
IL3CHG6090=$(tail -1 $IL3FILE |awk -F, '{ print $15 }')
IL3CHG90=$(tail -1 $IL3FILE |awk -F, '{ print $16 }')
#SERCOCHGLATE=$(for i in $(cat $ALLEURTIX |awk -F'",' '($21~"Change")&&($7~"Serco") { print $22 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|awk '($1 >= 30) { print $1 }'  |wc -l)
#
# Request tickets
#
IEREQ=$(cat $ALLTIX |awk -F'","' '($21~"Requested Item")&&($2~"IE ")&&($4!~"Resolved") { print }' |wc -l)
IECUSTREQ=$(cat $ALLTIX |awk -F'","' '($21~"Requested Item")&&(($24~"Ireland")||($2~"IE "))&&($4!~"Resolved") { print }' |wc -l)
SEREQ=$(cat $ALLTIX |awk -F'","' '($21~"Requested Item")&&($2~"SE ")&&($4!~"Resolved") { print }' |wc -l)
SECUSTREQ=$(cat $ALLTIX |awk -F'","' '($21~"Requested Item")&&(($24~"Sweden")||($2~"SE "))&&($4!~"Resolved") { print }' |wc -l)
FRREQ=$(cat $ALLTIX |awk -F'","' '($21~"Requested Item")&&($2~"FR ")&&($4!~"Resolved") { print }' |wc -l)
MNZREQ=$(cat $ALLTIX |awk -F'","' '($21~"Requested Item")&&($7~"Menzies")&&($4!~"Resolved") { print }' |wc -l)
SERCOREQ=$(cat $ALLTIX |awk -F'","' '($21~"Requested Item")&&($7~"Serco")&&($4!~"Resolved") { print }' |wc -l)
IL3REQ=$(tail -1 $IL3FILE |awk -F, '{ print $6 }')
#
# Function to create variables
#
var() {
TIME=$1
TIME2=$2
COMPANY=$3
TYPE=$4
COUNTRY=$5
case $TIME in # More than x days
        0) SEC=0
        ;;
        7) SEC=604800
        ;;
        14) SEC=1209600
        ;;
        30) SEC=2592000
        ;;
        60) SEC=5184000
        ;;
        90) SEC=7776000
        ;;
esac
case $TIME2 in # Less than x days
        0) SEC2=777600000 # Essentially an infinite number (9000 days), for use when you're only intereted in 'tickets older than X days'
        ;;
        7) SEC2=604800
        ;;
        14) SEC2=1209600
        ;;
        30) SEC2=2592000
        ;;
        60) SEC2=5184000
        ;;
        90) SEC2=7776000
        ;;
esac
[[ $COMPANY = 0 ]] && COMPANY=""
case $TYPE in
        I) TIK=Incident 
        ;;
        C) TIK=Change 
        ;;
        R) TIK=Request
        ;;
esac
[[ -z $COUNTRY ]] && COUNTRY=""
awk -vtime=$SEC -vtime2=$SEC2 -vcomp=$COMPANY -vcount="$COUNTRY " -vtype=$TIK -F'","' '($18~type)&&($5!~"Resolved")&&(($20>time)&&($20<time2))&&($12~comp)&&($10~count) {print}' $ALLEURTIX |wc -l
}
#
# Create global variables
#
# Incident
MNZI3060=$(var 30 60 Menzies I);MNZI6090=$(var 60 90 Menzies I);MNZIO90=$(var 90 0 Menzies)
SERI3060=$(var 30 60 Serco I);SERI6090=$(var 60 90 Serco I);SERIO90=$(var 90 0 Serco)
IEI3060=$(var 30 60 0 I IE);IEI6090=$(var 60 90 0 I IE);IEIO90=$(var 90 0 0 I IE)
SEI3060=$(var 30 60 0 I SE);SEI6090=$(var 60 90 0 I SE);SEIO90=$(var 90 0 0 I SE)
IL3I3060=0;IL3I6090=0;IL3IO90=0
TOTIL7=$(($MNZINC7+$SERCOINC7+$IEINCCUST7+$SEINCCUST7+$IL3INC7))
TOTIL14=$(($MNZINC15+$SERCOINC15+$IEINCCUST15+$SEINCCUST15+$IL3INC15))
TOTILO30=$(($MNZINCO30+$SERCOINCO30+$IEINCCUSTO30+$SEINCCUSTO30+$IL3INCO30))
TOTIL30=$(($MNZINC30+$SERCOINC30+$IEINCCUST30+$SEINCCUST30+$IL3INC30))
TOTIL3060=$(($MNZI3060+$SERI3060+$IEI3060+$SEI3060+$IL3I3060))
TOTIL6090=$(($MNZI6090+$SERI6090+$IEI6090+$SEI6090+$IL3I6090))
TOTILO90=$(($MNZIO90+$SERIO90+$IEIO90+$SEIO90+$IL3IO90))
# Change
MNZCO7=$(var 7 0 Menzies C);MNZCO14=$(var 14 0 Menzies C);MNZCO30=$(var 30 0 Menzies C);MNZCL30=$(var 0 30 Menzies C);MNZC3060=$(var 30 60 Menzies C);MNZC6090=$(var 60 90 Menzies C);MNZCO90=$(var 90 0 Menzies C)
SERCO7=$(var 7 0 "Serco" C);SERCO14=$(var 14 0 "Serco" C);SERCO30=$(var 30 0 Serco C);SERCL30=$(var 0 30 Serco C);SERC3060=$(var 30 60 Serco C);SERC6090=$(var 60 90 Serco C);SERCO90=$(var 90 0 Serco C)
IECO7=$(var 7 0 0 C IE);IECO14=$(var 14 0 0 C IE);IECO30=$(var 30 0 0 C IE);IECL30=$(var 0 30 0 C IE);IEC3060=$(var 30 60 0 C IE);IEC6090=$(var 60 90 0 C IE);IECO90=$(var 90 0 0 C IE)
SECO7=$(var 7 0 0 C SE);SECO14=$(var 14 0 0 C SE);SECO30=$(var 30 0 0 C SE);SECL30=$(var 0 30 0 C SE);SEC3060=$(var 30 60 0 C SE);SEC6090=$(var 60 90 0 C SE);SECO90=$(var 90 0 0 C SE)
TOTCO7=$(($MNZCHG7+$SERCOCHG7+$IECHG7+$SECHG7))
TOTCO14=$(($MNZCHG14+$SERCOCHG14+$IECHG14+$SECHG14))
TOTCO30=$(($MNZCHGO30+$SERCOCHGO30+$IECHGO30+$SECHGO30))
TOTCL30=$(($MNZCHG30+$SERCOCHG30+$IECHG30+$SECHG30))
TOTCL3060=$(($MNZCHG3060+$SERCOCHG3060+$IECHG3060+$SECHG3060))
TOTCL6090=$(($MNZCHG6090+$SERCOCHG6090+$IECHG6090+$SECHG6090))
TOTCLO90=$(($MNZCHG90+$SERCOCHG90+$IECHG90+$SECHG90))
#
# Populate data files
#
#printf "['$DDATE', $MNZINC7, $SERCOINC7, $IEINC7, $IEINCCUST7, $SEINC7, $SEINCCUST7],
printf "['$DDATE', $MNZINC7, $SERCOINC7, $SEINCCUST7, $IEINCCUST7, $IL3INC7 ],
" >> $INCFILE
printf "['$DDATE', $MNZPERCENT30, $SERCOPERCENT30, $SEPERCENT30, $IEPERCENT30, $IL3PERCENT30, $UKPERCENT30, $GLOBALPERCENT30 ],
" >> $INCPERCENTFILE
#printf "['$DDATE', $MNZREQ, $SERCOREQ, $IEREQ, $IECUSTREQ, $SEREQ, $SECUSTREQ],
printf "['$DDATE', $MNZREQ, $SERCOREQ, $SECUSTREQ, $IECUSTREQ, $IL3REQ],
" >> $REQFILE
#
# Create mail file
#
echo "" > $MAILFILE
head -12 $TEMPLATE >> $MAILFILE
cat $INCFILE|uniq|tail -30 >> $MAILFILE
printf "   ]);
		
		 var data2 = new google.visualization.arrayToDataTable([
          ['Day', 'Menzies', 'Serco', 'Sweden', 'Ireland', 'Secure IL3 & Sovereign'],
" >> $MAILFILE
cat $REQFILE |uniq|tail -14 >> $MAILFILE
printf "   ]);
		
		var data3 = google.visualization.arrayToDataTable([
        ['Country', 'Open Changes', 'Overdue Changes'],
['Ireland', $IECHGALL, $IECHGLATE ],
['Sweden', $SECHGALL, $SECHGLATE],
['Serco', $SERCOCHGALL, $SERCOCHGLATE],
['Menzies', $MNZCHGALL, $MNZCHGLATE],
['Secure IL3 & Sovereign', $IL3CHGALL, $IL3CHGLATE]
     ]);

" >> $MAILFILE
sed -n 41,93p $TEMPLATE >> $MAILFILE
sed -n 94,145p $TEMPLATE >> $MAILFILE
printf "<H1 style='font-family:arial;color:#4863A0'> Strategic Accounts Dashboard - $MAILDATE</H1>" >> $MAILFILE
#
# Create table of Open Incidents using the global model
#
tab() {
printf "<div><span style='font-family:Calibri';float: left'>
<div id="nav"></div><table  border=1 cellspacing=0 cellpadding=0 width=416 style='float: left;'><tr bgcolor="#B00014" style='font-family:Calibri;color:white'><td rowspan="2">Dedicated Customer<td colspan="6"><b>Open Incidents (as of $DDATE)</b></td></tr>
<tr bgcolor="#B00014" style='font-family:Calibri;color:white'><td>>7 days</td><td>>14 days</td><td>>30 days</td><td>30-60 days</td><td>60-90 days</td><td>Over 90 days</td></tr>
<tr bgcolor="#EAE7E7"><td>Menzies</td><td>$MNZINC7</td><td>$MNZINC15</td><td>$MNZINCO30</td><td>$MNZI3060</td><td>$MNZI6090</td><td>$MNZIO90</td><tr>
<tr bgcolor="#EAE7E7"><td>Serco</td><td>$SERCOINC7</td><td>$SERCOINC15</td><td>$SERCOINCO30</td><td>$SERI3060</td><td>$SERI6090</td><td>$SERIO90</td><tr>
<tr bgcolor="#EAE7E7"><td>Ireland</td><td>$IEINCCUST7</td><td>$IEINCCUST15</td><td>$IEINCCUSTO30</td><td>$IEI3060</td><td>$IEI6090</td><td>$IEIO90</td><tr>
<tr bgcolor="#EAE7E7"><td>Sweden</td><td>$SEINCCUST7</td><td>$SEINCCUST15</td><td>$SEINCCUSTO30</td><td>$SEI3060</td><td>$SEI6090</td><td>$SEIO90</td><tr>
<tr bgcolor="#EAE7E7"><td>Secure IL3 & Sovereign</td><td>$IL3INC7</td><td>$IL3INC15</td><td>$IL3INCO30</td><td>$IL3I3060</td><td>$IL3I6090</td><td>$IL3IO90</td><tr>
<tr bgcolor="#B00014" style='font-family:Calibri;color:white'><td>Total</td><td>$TOTIL7</td><td>$TOTIL14</td><td>$TOTILO30</td><td>$TOTIL3060</td><td>$TOTIL6090</td><td>$TOTILO90</td><tr>
</table><div id="nav"></div>
<table  border=1 cellspacing=0 cellpadding=0 width=416 style='float: left;'><tr bgcolor="#B00014" style='font-family:Calibri;color:white'><td rowspan="2">Dedicated Customer<td colspan="6"><b>Open Changes (as of $DDATE)</b></td></tr>
<tr bgcolor="#B00014" style='font-family:Calibri;color:white'><td>>7 days</td><td>>14 days</td><td>>30 days</td><td>30-60 days</td><td>60-90 days</td><td>Over 90 days</td></tr>
<tr bgcolor="#EAE7E7"><td>Menzies</td><td>$MNZCHG7</td><td>$MNZCHG14</td><td>$MNZCHGO30</td><td>$MNZCHG3060</td><td>$MNZCHG6090</td><td>$MNZCHG90</td><tr>
<tr bgcolor="#EAE7E7"><td>Serco</td><td>$SERCOCHG7</td><td>$SERCOCHG14</td><td>$SERCOCHGO30</td><td>$SERCOCHG3060</td><td>$SERCOCHG6090</td><td>$SERCOCHG90</td><tr>
<tr bgcolor="#EAE7E7"><td>Ireland</td><td>$IECHG7</td><td>$IECHG14</td><td>$IECHGO30</td><td>$IECHG3060</td><td>$IECHG6090</td><td>$IECHG90</td><tr>
<tr bgcolor="#EAE7E7"><td>Sweden</td><td>$SECHG7</td><td>$SECHG14</td><td>$SECHGO30</td><td>$SECHG3060</td><td>$SECHG6090</td><td>$SECHG90</td><tr>
<tr bgcolor="#EAE7E7"><td>Secure IL3 & Sovereign</td><td>$IL3CHG7</td><td>$IL3CHG14</td><td>$IL3CHG30</td><td>$IL3CHG3060</td><td>$IL3CHG6090</td><td>$IL3CHG90</td><tr>
<tr bgcolor="#B00014" style='font-family:Calibri;color:white'><td>Total</td><td>$TOTCO7</td><td>$TOTCO14</td><td>$TOTCO30</td><td>$TOTCL3060</td><td>$TOTCL6090</td><td>$TOTCLO90</td><tr>
</table></div>" >> $MAILFILE
}
sed -n 147,148p $TEMPLATE >> $MAILFILE
tab
printf "<br><span style='font-family:arial;color:#4863A0;float: left;'><H2>Delinquent Tickets (Incidents >14 days old, Changes >30 days past requested-by date)</H2><b>
<table><tr bgcolor=yellow><td>Type</td><td>Number</td><td>Assignment Group</td><td>Urgency</td><td>Priority</td><td>State</td><td>Short Description</td><td>Created</td><td>Updated</td><td>Company</td><td>Assignee</td></tr>" >> $MAILFILE
awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($10~"IE |SE ") { print "<tr><td>"$18"</td><td>"$1"</td><td>"$10"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$26"</td></tr>"}' $ALLEURTIX |sed 's/"//g' >> $MAILFILE
awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($12~"Menzies|Serco") { print "<tr><td>"$18"</td><td>"$1"</td><td>"$10"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$26"</td></tr>"}' $ALLEURTIX |sed 's/"//g' >> $MAILFILE
echo "</table>" >> $MAILFILE
#sed -n 149,151p $TEMPLATE >> $MAILFILE
#sed -n 158,160p $TEMPLATE >> $MAILFILE
#
# Add top issues, etc
#
#head -1 $ALLEURTIX | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }';cat $ALLEURTIX | awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600) { print "<tr><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>"}'|sed 's/"//g'| grep $i; echo "</table></span><br>";done >> $MAILFILE
#
# Send mail
#
unset IFS
curl   -F "filecomment=Strategic Accounts Dashboard $MAILDATE" -F "userfile=@$MAILFILE" http://10.236.16.75/_int_api/index.php/uploading/do_upload > $URLFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,paul.higgins@sungardas.com,paul.sandhu@sungardas.com,ann.wingard@sungardas.com,grant.tobin@sungardas.com,julian.peter@sungardas.com"  -s "### Daily Strategic Accounts Dashboard - follow link (Beta) ###" < $URLFILE 
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com"  -s "### Daily Strategic Accounts Dashboard - follow link (Beta) ###" < $URLFILE 
# something