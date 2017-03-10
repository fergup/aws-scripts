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
# 4. IL3 - a) Can we actually get this added to the daily report? b) How do we distinguish between IL3 and McDonalds when we're talking about McDonalds LCC on IL2?
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
ALLTIX=$TIXDIR/USXDedicatedXAccountsXAllXOpen.csv
CHGSLA=$TIXDIR/ChangeXSLA.csv
OPEN=$TIXDIR/GlobalXOpenXIncidentsXPFXExport.csv
CLOGATEGROUPD=$TIXDIR/UKXClosedXYesterdayXINCXCHGXRITM.csv
IL3FILE=$STRATDIR/il3
# Dates
DATE=$(date +%Y-%m-%d" "%H:%M:%S)
DDATE=$(date +%b" "%d)
CHDATE=$(date +%d" "%b)
MAILDATE=$(date +%d" "%B" "%Y)
FILEDATE=$(date +%d%b%Y)
datediff() {
     d1=$(date -d "$1" +%s)
     d2=$(date -d "" +%s)
     echo $(( (d1 - d2) / 86400 )) days
}
IFS='"'
IFS='"'
# Files
INCFILE=$STRATDIR/incidents3_us
INCFILEG=$STRATDIR/incidents_global_us
INCPERCENTFILE=$STRATDIR/incidents_percent_us
REQFILE=$STRATDIR/requests3_us
CHGFILE=$STRATDIR/changes_us
CHGFILEG=$STRATDIR/changes_global_us
AVAILFILE=$STRATDIR/availability_us
TEMPLATE=$STRATDIR/template4.html
MAILFILE=$STRATDIR/us-strat-$FILEDATE.html
URLFILE=$STRATDIR/us-url-$FILEDATE.html
#
# Incidents
#
GLOBALALL=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved") { print }' |wc -l)
ICONECTALL=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($12~"Telcordia ") { print }' |wc -l)
GATEGROUPALL=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($12~"GATEGROUP ") { print }' |wc -l)
THREEMALL=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($12~"3M Company") { print $6 }' |wc -l)
INFOMCDALL=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($12~"McDonalds") { print $6 }' |wc -l)
GLOBALINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600) { print $6 }' |wc -l)
ICONECTINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($12~"Telcordia ") { print $6 }' |wc -l)
GATEGROUPINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($12~"GATEGROUP ") { print $6 }' |wc -l)
GATEGROUPINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($12~"GATEGROUP ") { print $6 }' |wc -l)
THREEMINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($12~"3M Company") { print $6 }' |wc -l)
INFOMCDINC15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($12~"McDonalds") { print $6 }' |wc -l)
GLOBALINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800) { print $6 }' |wc -l)
ICONECTINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($12~"Telcordia ") { print $6 }' |wc -l)
GATEGROUPINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($12~"GATEGROUP ") { print $6 }' |wc -l)
GATEGROUPINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($12~"GATEGROUP ") { print $6 }' |wc -l)
THREEMINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($12~"3M Company") { print $6 }' |wc -l)
INFOMCDINC7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($12~"McDonalds") { print $6 }' |wc -l)
GLOBALINC30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000) { print $6 }' |wc -l)
ICONECTINCO30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000)&&($12~"Telcordia ") { print $6 }' |wc -l)
GATEGROUPINCO30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000)&&($12~"GATEGROUP ") { print $6 }' |wc -l)
THREEMINC30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000)&&($12~"3M Company") { print $6 }' |wc -l)
THREEMINCO30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&(>2592000)&&($12~"3M Company") { print $6 }' |wc -l)
INFOMCDINC30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20<2592000)&&($12~"McDonalds") { print $6 }' |wc -l)
INFOMCDINCO30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&(>2592000)&&($12~"McDonalds") { print $6 }' |wc -l)
GLOBALPERCENT30=$((GLOBALINC30*100/$GLOBALALL))
#ICONECTPERCENT30=$((ICONECTINC30*100/$ICONECTALL))
GATEGROUPPERCENT30=$((GATEGROUPINC30*100/$GATEGROUPALL))
THREEMPERCENT30=$((THREEMINC30*100/$THREEMALL))
INFOMCDPERCENT30=$((INFOMCDINC30*100/$INFOMCDALL))
#IL3PERCENT30=$((IL3INC30*100/$IL3ALL))
#
# Changes - all and late for each are
#
unset IFS # The Change stuff gets upset by the IFS setting
ICONECTCHGALL=$(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"Telcordia ") { print }' |wc -l)
ICONECTCHGLATE=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"Telcordia ") { print $7 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|awk '($1 >= 30) { print $1 }'  |wc -l)
ICONECTCHG7=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"Telcordia ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 7) { print $1 }'  |wc -l)
ICONECTCHG14=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"Telcordia ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 14) { print $1 }'  |wc -l)
ICONECTCHGO30=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"Telcordia ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30) { print $1 }'  |wc -l)
ICONECTCHG3060=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"Telcordia ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30)&&($1 <=60) { print $1 }'  |wc -l)
ICONECTCHG6090=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"Telcordia ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 60)&&($1 <= 90) { print $1 }'  |wc -l)
ICONECTCHG90=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"Telcordia ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 90) { print $1 }'  |wc -l)
ICONECTCHG30=$(cat $CHGSLA|awk -F'","' '($6<2592000)&&(($8~"Telcordia ")||($12~"Gategroup")||($13~"ICONECT")) { print }'|wc -l)
GATEGROUPCHGALL=$(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"GATEGROUP ") { print }' |wc -l)
GATEGROUPCHGLATE=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"GATEGROUP ") { print $7 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|awk '($1 >= 30) { print $1 }'  |wc -l)
GATEGROUPCHG7=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"GATEGROUP ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 7) { print $1 }'  |wc -l)
GATEGROUPCHG14=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"GATEGROUP ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 14) { print $1 }'  |wc -l)
GATEGROUPCHGO30=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"GATEGROUP ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30) { print $1 }'  |wc -l)
GATEGROUPCHG3060=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"GATEGROUP ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30)&&($1 <=60) { print $1 }'  |wc -l)
GATEGROUPCHG6090=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"GATEGROUP ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 60)&&($1 <= 90) { print $1 }'  |wc -l)
GATEGROUPCHG90=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"GATEGROUP ") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 90) { print $1 }'  |wc -l)
GATEGROUPCHG30=$(cat $CHGSLA|awk -F'","' '($6<2592000)&&(($8~"GATEGROUP ")||($12~"Iconectiv")||($13~"GATEGROUP")) { print }'|wc -l)
THREEMCHGALL=$(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"3M Company") { print }' |wc -l)
THREEMCHGLATE=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"3M Company") { print $7 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days|awk '($1 >= 30) { print $1 }'  |wc -l)
THREEMCHG7=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"3M Company") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 7) { print $1 }'  |wc -l)
THREEMCHG14=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"3M Company") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 14) { print $1 }'  |wc -l)
THREEMCHGO30=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"3M Company") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30) { print $1 }'  |wc -l)
THREEMCHG3060=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"3M Company") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30)&&($1 <=60) { print $1 }'  |wc -l)
THREEMCHG6090=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"3M Company") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 60)&&($1 <= 90) { print $1 }'  |wc -l)
THREEMCHG90=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"3M Company") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 90) { print $1 }'  |wc -l)
THREEMCHG30=$(cat $CHGSLA|awk -F'","' '($6<2592000)&&($12~"3M Company") { print }'|wc -l)
INFOMCDCHGALL=$(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"McDonalds") { print }' |wc -l)
INFOMCDCHGLATE=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"McDonalds") { print $7 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|awk '($1 > 90) { print $1 }'  |wc -l)
INFOMCDCHG7=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"McDonalds") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 7) { print $1 }'  |wc -l)
INFOMCDCHG14=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"McDonalds") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 14) { print $1 }'  |wc -l)
INFOMCDCHGO30=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"McDonalds") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30) { print $1 }'  |wc -l)
INFOMCDCHG3060=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"McDonalds") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 >= 30)&&($1 <=60) { print $1 }'  |wc -l)
INFOMCDCHG6090=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"McDonalds") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 60)&&($1 <= 90) { print $1 }'  |wc -l)
INFOMCDCHG90=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"McDonalds") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |awk '($1 > 90) { print $1 }'  |wc -l)
INFOMCDCHGO30=$(cat $CHGSLA|awk -F'","' '($6>2592000)&&($12~"McDonalds") { print }'|wc -l)
GATEGROUPCHGALL=$(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"GATEGROUP ") { print }'|wc -l)
GATEGROUPCHGLATE=$(for i in $(cat $ALLTIX |awk -F'",' '($13~"Change")&&($7~"GATEGROUP ") { print $7 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|awk '($1 >= 30) { print $1 }'  |wc -l)
#INFOMCDCHGLATE=$(for i in $(cat $ALLEURTIX |awk -F'",' '(1~"Change")&&($7~"McDonalds") { print $7 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|awk '($1 >= 30) { print $1 }'  |wc -l)
#
# Request tickets
#
ICONECTREQ=$(cat $ALLTIX |awk -F'","' '($13~"Requested Item")&&($7~"Telcordia ")&&($4!~"Resolved") { print }' |wc -l)
GATEGROUPREQ=$(cat $ALLTIX |awk -F'","' '($13~"Requested Item")&&($7~"GATEGROUP ")&&($4!~"Resolved") { print }' |wc -l)
THREEMREQ=$(cat $ALLTIX |awk -F'","' '($13~"Requested Item")&&($7~"3M Company")&&($4!~"Resolved") { print }' |wc -l)
INFOMCDREQ=$(cat $ALLTIX |awk -F'","' '($13~"Requested Item")&&($7~"McDonalds")&&($4!~"Resolved") { print }' |wc -l)
#
# Function to create variables
#
var() {
TIME=$1
TIME2=
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
awk -vtime=$SEC -vtime2=$SEC2 -vcomp=$COMPANY -vcount="$COUNTRY " -vtype=$TIK -F'","' '($18~type)&&($5!~"Resolved")&&((>time)&&($7<time2))&&($12~comp)&&($12~count) {print}' $ALLEURTIX |wc -l
}
#
# Create global variables
#
# Incident
THREEMI3060=$(var 30 60 3M Company I);THREEMI6090=$(var 60 90 3M Company I);THREEMIO90=$(var 90 0 3M Company)
GATEGROUPRI3060=$(var 30 60 McDonalds I);GATEGROUPRI6090=$(var 60 90 McDonalds I);GATEGROUPRIO90=$(var 90 0 McDonalds)
ICONECTI3060=$(var 30 60 0 I ICONECT);ICONECTI6090=$(var 60 90 0 I ICONECT);ICONECTIO90=$(var 90 0 0 I ICONECT)
GATEGROUPI3060=$(var 30 60 0 I GATEGROUP);GATEGROUPI6090=$(var 60 90 0 I GATEGROUP);GATEGROUPIO90=$(var 90 0 0 I GATEGROUP)
#TOTIL7=$(($THREEMINC7+$INFOMCDINC7+$ICONECTINC7+$GATEGROUPINC7+$IL3INC7))
#TOTIL14=$(($THREEMINC15+$INFOMCDINC15+$ICONECTINC15+$GATEGROUPINC15+$IL3INC15))
#TOTILO30=$(($THREEMINCO30+$INFOMCDINCO30+$ICONECTINCO30+$GATEGROUPINCO30+$IL3INCO30))
#TOTIL30=$(($THREEMINC30+$INFOMCDINC30+$ICONECTINC30+$GATEGROUPINC30+$IL3INC30))
#TOTIL3060=$(($THREEMI3060+$GATEGROUPRI3060+$ICONECTI3060+$GATEGROUPI3060+$IL3I3060))
#TOTIL6090=$(($THREEMI6090+$GATEGROUPRI6090+$ICONECTI6090+$GATEGROUPI6090+$IL3I6090))
#TOTILO90=$(($THREEMIO90+$GATEGROUPRIO90+$ICONECTIO90+$GATEGROUPIO90+$IL3IO90))
# Change
#THREEMCO7=$(var 7 0 3M Company C);THREEMCO14=$(var 14 0 3M Company C);THREEMCO30=$(var 30 0 3M Company C);THREEMCL30=$(var 0 30 3M Company C);THREEMC3060=$(var 30 60 3M Company C);THREEMC6090=$(var 60 90 3M Company C);THREEMCO90=$(var 90 0 3M Company C)
#INFOMCD7=$(var 7 0 "McDonalds" C);INFOMCD14=$(var 14 0 "McDonalds" C);INFOMCD30=$(var 30 0 McDonalds C);GATEGROUPRCL30=$(var 0 30 McDonalds C);GATEGROUPRC3060=$(var 30 60 McDonalds C);GATEGROUPRC6090=$(var 60 90 McDonalds C);INFOMCD90=$(var 90 0 McDonalds C)
#ICONECTCO7=$(var 7 0 0 C ICONECT);ICONECTCO14=$(var 14 0 0 C ICONECT);ICONECTCO30=$(var 30 0 0 C ICONECT);ICONECTCL30=$(var 0 30 0 C ICONECT);ICONECTC3060=$(var 30 60 0 C ICONECT);ICONECTC6090=$(var 60 90 0 C ICONECT);ICONECTCO90=$(var 90 0 0 C ICONECT)
#GATEGROUPCO7=$(var 7 0 0 C GATEGROUP);GATEGROUPCO14=$(var 14 0 0 C GATEGROUP);GATEGROUPCO30=$(var 30 0 0 C GATEGROUP);GATEGROUPCL30=$(var 0 30 0 C GATEGROUP);GATEGROUPC3060=$(var 30 60 0 C GATEGROUP);GATEGROUPC6090=$(var 60 90 0 C GATEGROUP);GATEGROUPCO90=$(var 90 0 0 C GATEGROUP)
#TOTCO7=$(($THREEMCHG7+$INFOMCDCHG7+$ICONECTCHG7+$GATEGROUPCHG7))
#TOTCO14=$(($THREEMCHG14+$INFOMCDCHG14+$ICONECTCHG14+$GATEGROUPCHG14))
#TOTCO30=$(($THREEMCHGO30+$INFOMCDCHGO30+$ICONECTCHGO30+$GATEGROUPCHGO30))
#TOTCL30=$(($THREEMCHG30+$INFOMCDCHG30+$ICONECTCHG30+$GATEGROUPCHG30))
#TOTCL3060=$(($THREEMCHG3060+$INFOMCDCHG3060+$ICONECTCHG3060+$GATEGROUPCHG3060))
#TOTCL6090=$(($THREEMCHG6090+$INFOMCDCHG6090+$ICONECTCHG6090+$GATEGROUPCHG6090))
#TOTCLO90=$(($THREEMCHG90+$INFOMCDCHG90+$ICONECTCHG90+$GATEGROUPCHG90))
#
# Populate data files
#
#printf "['$DDATE', $THREEMINC7, $INFOMCDINC7, $ICONECTINC7, $ICONECTINC7, $GATEGROUPINC7, $GATEGROUPINC7],
printf "['$DDATE', $THREEMINC7, $INFOMCDINC7, $GATEGROUPINC7, $ICONECTINC7 ],
" >> $INCFILE
printf "['$DDATE', $THREEMPERCENT30, $INFOMCDPERCENT30, $GATEGROUPPERCENT30, $ICONECTPERCENT30, $IL3PERCENT30, $UKPERCENT30, $GLOBALPERCENT30 ],
" >> $INCPERCENTFILE
#printf "['$DDATE', $THREEMREQ, $INFOMCDREQ, $ICONECTREQ, $ICONECTREQ, $GATEGROUPREQ, $GATEGROUPREQ],
printf "['$DDATE', $THREEMREQ, $INFOMCDREQ, $GATEGROUPREQ, $ICONECTREQ],
" >> $REQFILE
#
# Create mail file
#
echo "" > $MAILFILE
head -12 $TEMPLATE >> $MAILFILE
cat $INCFILE|uniq|tail -30 >> $MAILFILE
printf "   ]);
		
		 var data2 = new google.visualization.arrayToDataTable([
          ['Day', '3M Company', 'McDonalds', 'Iconectiv', 'Gategroup'],
" >> $MAILFILE
cat $REQFILE |uniq|tail -14 >> $MAILFILE
printf "   ]);
		
		var data3 = google.visualization.arrayToDataTable([
        ['Country', 'Open Changes', 'Overdue Changes'],
['Gategroup', $ICONECTCHGALL, $ICONECTCHGLATE ],
['Iconectiv', $GATEGROUPCHGALL, $GATEGROUPCHGLATE],
['McDonalds', $INFOMCDCHGALL, $INFOMCDCHGLATE],
['3M Company', $THREEMCHGALL, $THREEMCHGLATE]
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
<tr bgcolor="#EAE7E7"><td>3M Company</td><td>$THREEMINC7</td><td>$THREEMINC15</td><td>$THREEMINCO30</td><td>$THREEMI3060</td><td>$THREEMI6090</td><td>$THREEMIO90</td><tr>
<tr bgcolor="#EAE7E7"><td>McDonalds</td><td>$INFOMCDINC7</td><td>$INFOMCDINC15</td><td>$INFOMCDINCO30</td><td>$GATEGROUPRI3060</td><td>$GATEGROUPRI6090</td><td>$GATEGROUPRIO90</td><tr>
<tr bgcolor="#EAE7E7"><td>Gategroup</td><td>$ICONECTINC7</td><td>$ICONECTINC15</td><td>$ICONECTINCO30</td><td>$ICONECTI3060</td><td>$ICONECTI6090</td><td>$ICONECTIO90</td><tr>
<tr bgcolor="#EAE7E7"><td>Iconectiv</td><td>$GATEGROUPINC7</td><td>$GATEGROUPINC15</td><td>$GATEGROUPINCO30</td><td>$GATEGROUPI3060</td><td>$GATEGROUPI6090</td><td>$GATEGROUPIO90</td><tr>
<tr bgcolor="#B00014" style='font-family:Calibri;color:white'><td>Total</td><td>$TOTIL7</td><td>$TOTIL14</td><td>$TOTILO30</td><td>$TOTIL3060</td><td>$TOTIL6090</td><td>$TOTILO90</td><tr>
</table><div id="nav"></div>
<table  border=1 cellspacing=0 cellpadding=0 width=416 style='float: left;'><tr bgcolor="#B00014" style='font-family:Calibri;color:white'><td rowspan="2">Dedicated Customer<td colspan="6"><b>Open Changes (as of $DDATE)</b></td></tr>
<tr bgcolor="#B00014" style='font-family:Calibri;color:white'><td>>7 days</td><td>>14 days</td><td>>30 days</td><td>30-60 days</td><td>60-90 days</td><td>Over 90 days</td></tr>
<tr bgcolor="#EAE7E7"><td>3M Company</td><td>$THREEMCHG7</td><td>$THREEMCHG14</td><td>$THREEMCHGO30</td><td>$THREEMCHG3060</td><td>$THREEMCHG6090</td><td>$THREEMCHG90</td><tr>
<tr bgcolor="#EAE7E7"><td>McDonalds</td><td>$INFOMCDCHG7</td><td>$INFOMCDCHG14</td><td>$INFOMCDCHGO30</td><td>$INFOMCDCHG3060</td><td>$INFOMCDCHG6090</td><td>$INFOMCDCHG90</td><tr>
<tr bgcolor="#EAE7E7"><td>Gategroup</td><td>$ICONECTCHG7</td><td>$ICONECTCHG14</td><td>$ICONECTCHGO30</td><td>$ICONECTCHG3060</td><td>$ICONECTCHG6090</td><td>$ICONECTCHG90</td><tr>
<tr bgcolor="#EAE7E7"><td>Iconectiv</td><td>$GATEGROUPCHG7</td><td>$GATEGROUPCHG14</td><td>$GATEGROUPCHGO30</td><td>$GATEGROUPCHG3060</td><td>$GATEGROUPCHG6090</td><td>$GATEGROUPCHG90</td><tr>
<tr bgcolor="#B00014" style='font-family:Calibri;color:white'><td>Total</td><td>$TOTCO7</td><td>$TOTCO14</td><td>$TOTCO30</td><td>$TOTCL3060</td><td>$TOTCL6090</td><td>$TOTCLO90</td><tr>
</table></div>" >> $MAILFILE
}
sed -n 147,148p $TEMPLATE >> $MAILFILE
tab
printf "<br><span style='font-family:arial;color:#4863A0;float: left;'><H2>Delinquent Tickets (Incidents >14 days old, Changes >30 days past requested-by date)</H2><b>
<table><tr bgcolor=yellow><td>Type</td><td>Number</td><td>Assignment Group</td><td>Urgency</td><td>Priority</td><td>State</td><td>Short Description</td><td>Created</td><td>Updated</td><td>Company</td><td>Assignee</td></tr>" >> $MAILFILE
#awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($12~"Telcordia |GATEGROUP ") { print "<tr><td>"$18"</td><td>"$1"</td><td>"$12"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$76"</td></tr>"}' $ALLEURTIX |sed 's/"//g' >> $MAILFILE
#awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($12~"3M Company|McDonalds") { print "<tr><td>"$18"</td><td>"$1"</td><td>"$12"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$76"</td></tr>"}' $ALLEURTIX |sed 's/"//g' >> $MAILFILE
echo "</table>" >> $MAILFILE
#sed -n 149,151p $TEMPLATE >> $MAILFILE
#sed -n 158,160p $TEMPLATE >> $MAILFILE
#
# Add top issues, etc
#
#head -1 $ALLEURTIX | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$12"</td><td>"$11"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>""</td><td>"$12"</td><td>"$71"</td></tr>" }';cat $ALLEURTIX | awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($7$20>1209600) { print "<tr><td>"$1"</td><td>"$12"</td><td>"$11"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$71"</td></tr>"}'|sed 's/"//g'| grep $i; echo "</table></span><br>";done >> $MAILFILE
#
# Send mail
#
unset IFS
curl   -F "filecomment=Strategic Accounts Dashboard $MAILDATE" -F "userfile=@$MAILFILE" http://10.236.16.75/_int_api/index.php/uploading/do_upload > $URLFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,paul.higgins@sungardas.com,paul.sandhu@sungardas.com,ann.wingard@sungardas.com,grant.tobin@sungardas.com,julian.peter@sungardas.com"  -s "### Daily Strategic Accounts Dashboard - follow link (Beta) ###" < $URLFILE 
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com"  -s "### Daily Strategic Accounts Dashboard - follow link (Beta) ###" < $URLFILE 
# something
