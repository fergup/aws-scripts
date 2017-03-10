#!/bin/bash
# Script to check open tickets for Pat Morley and Paul Higgins and generate some nice graphs
# Set variables
TICKETS=/data/sn/UKXPFXDirectorsXOpenXTasks.csv
RRDFILE=/data/rrd/sn_ph_pm.rrd
#PHALL=$(egrep -c "Paul Higgins|Clive Van Delden" $TICKETS)
PHALL=$(wc -l $TICKETS)
#PHINC=$(cat $TICKETS|awk -F, '($21~"Incident") { print $0 }'|egrep -c "Paul Higgins|Clive Van Delden")
PHINC=$(cat $TICKETS|awk -F, '($21~"Incident") { print $0 }'|wc -l)
#PHREQ=$(cat $TICKETS|awk -F, '($21~"Request") { print $0 }'|egrep -c "Paul Higgins|Clive Van Delden")
PHREQ=$(cat $TICKETS|awk -F, '($21~"Request") { print $0 }'|wc -l)
#PHCHG=$(cat $TICKETS|awk -F, '($21~"Change") { print $0 }'|egrep -c "Paul Higgins|Clive Van Delden")
PHCHG=$(cat $TICKETS|awk -F, '($21~"Change") { print $0 }'|wc -l)
PMALL=$(grep -c "Pat Morley" $TICKETS)
PMINC=$(cat $TICKETS|awk -F, '($21~"Incident") { print $0 }'|grep -c "Pat Morley")
PMREQ=$(cat $TICKETS|awk -F, '($21~"Request") { print $0 }'|grep -c "Pat Morley")
PMCHG=$(cat $TICKETS|awk -F, '($21~"Change") { print $0 }'|grep -c "Pat Morley")
RRDDATE=$(date +%m/%d/%Y" "%H:%M)
RRDGRAPHALL=/data/images/ph_pm_inc_all_nostack.png
RRDGRAPHPH=/data/images/ph_all_stack.png
RRDGRAPHPM=/data/images/pm_all_stack.png
MAILFILE=/data/mail/pmphmail
PHTIX=/data/mail/Paul_Higgins_Open_Tickets
PMTIX=/data/mail/Pat_Morley_Open_Tickets
# Build email
printf "Paul Higgins
Open Incidents: $PHINC
Open Requests: $PHREQ
Open Changes: $PHCHG

Pat Morley
Open Incidents: $PMINC
Open Requests: $PMREQ
Open Changes: $PMCHG" > $MAILFILE
# Do stuff
echo "$PHALL,$PHINC,$PHREQ,$PHCHG,$PMALL,$PMINC,$PMREQ,$PMCHG"
rrdtool update $RRDFILE "$RRDDATE@$PHALL:$PHINC:$PHREQ:$PHCHG:$PMALL:$PMINC:$PMREQ:$PMCHG"
#rrdtool update $RRDFILE "04/27/2015 00:13@$PHALL:$PHINC:$PHREQ:$PHCHG:$PMALL:$PMINC:$PMREQ:$PMCHG"
#rrdtool update $RRDFILE "04/28/2015 00:13@$PHALL:$PHINC:$PHREQ:$PHCHG:$PMALL:$PMINC:$PMREQ:$PMCHG"
rrdtool graph $RRDGRAPHALL -a PNG --title="Paul Higgins and Pat Morley Open Incidents +30 days" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/sn_ph_pm.rrd:ph-inc:AVERAGE' 'DEF:probe2=/data/rrd/sn_ph_pm.rrd:pm-inc:AVERAGE' 'AREA:probe1#48C4EC:Paul Higgins Open Incidents' 'AREA:probe2#54EC48:Pat Morley Open Incidents' -w 600 -h 100 -n TITLE:13: --alt-y-grid -l 0 -h 300 -s now-1w -e now+1d
rrdtool graph $RRDGRAPHPH -a PNG --title="Paul Higgins Open Tasks +30 days (stacked)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/sn_ph_pm.rrd:ph-inc:AVERAGE' 'DEF:probe2=/data/rrd/sn_ph_pm.rrd:ph-req:AVERAGE' 'DEF:probe3=/data/rrd/sn_ph_pm.rrd:ph-chg:AVERAGE' 'AREA:probe1#FF0000:Incidents:STACK' 'AREA:probe2#00FF00:Requests:STACK' 'AREA:probe2#0000FF:Changes:STACK' -w 600 -h 300 -n TITLE:13: --alt-y-grid -l 0 -s now-1w -e now+1d
rrdtool graph $RRDGRAPHPM -a PNG --title="Pat Morley Open Tasks +30 days (stacked)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/sn_ph_pm.rrd:pm-inc:AVERAGE' 'DEF:probe2=/data/rrd/sn_ph_pm.rrd:pm-req:AVERAGE' 'DEF:probe3=/data/rrd/sn_ph_pm.rrd:pm-chg:AVERAGE' 'AREA:probe1#FF0000:Incidents:STACK' 'AREA:probe2#00FF00:Requests:STACK' 'AREA:probe2#0000FF:Changes:STACK' -w 600 -h 300 -n TITLE:13: --alt-y-grid -l 0 -s now-1w -e now+1d
# Send mail
printf "

Paul Higgins Open Incidents by Group
=============================
" >> $MAILFILE
cat $TICKETS |awk -F, '($21~"Incident") { print $0 }'|grep -v "Pat Morley" |awk -F, '{ print $2" "$13 }' |uniq -c|sed 's/" "/ (/g' |sed 's/"$/)/g'|sed 's/"//g' |sort -rn >> $MAILFILE
printf "
Pat Morley Open Incidents by Group
=============================
" >> $MAILFILE
cat $TICKETS |awk -F, '($21~"Incident") { print $0 }'|grep "Pat Morley" |awk -F, '{ print $2" "$13 }' |uniq -c|sed 's/" "/ (/g' |sed 's/"$/)/g'|sed 's/"//g' |sort -rn >> $MAILFILE
printf "

Paul Higgins Open Requests by group
=============================
" > $PHTIX
cat $TICKETS |awk -F, '($21~"Request") { print $0 }'|grep -v "Pat Morley" |awk -F, '{ print $2" "$13 }' |uniq -c|sed 's/" "/ (/g' |sed 's/"$/)/g'|sed 's/"//g' |sort -rn >> $PHTIX
printf "

Paul Higgins Open Change by group
=============================
" >> $PHTIX
cat $TICKETS |awk -F, '($21~"Change") { print $0 }'|grep -v "Pat Morley" |awk -F, '{ print $2" "$13 }' |uniq -c|sed 's/" "/ (/g' |sed 's/"$/)/g'|sed 's/"//g' |sort -rn >> $PHTIX
printf "

Pat Morley Open Requests by group
=============================
" > $PMTIX
cat $TICKETS |awk -F, '($21~"Request") { print $0 }'|grep "Pat Morley" |awk -F, '{ print $2" "$13 }' |uniq -c|sed 's/" "/ (/g' |sed 's/"$/)/g'|sed 's/"//g' |sort -rn >> $PMTIX
printf "

Pat Morley Open Change by group
=============================
" >> $PMTIX
cat $TICKETS |awk -F, '($21~"Change") { print $0 }'|grep "Pat Morley" |awk -F, '{ print $2" "$13 }' |uniq -c|sed 's/" "/ (/g' |sed 's/"$/)/g'|sed 's/"//g' |sort -rn >> $PMTIX
#mutt "paul.ferguson@sungardas.com" -s "Daily PH/PM Open Tickets" -a $RRDGRAPHALL -a $RRDGRAPHPH -a $RRDGRAPHPM -a $PHTIX -a $PMTIX < $MAILFILE
mutt "paul.ferguson@sungardas.com,ryan.bell@sungardas.com" -s "Daily PH/PM Open Tickets" -a $RRDGRAPHALL -a $RRDGRAPHPH -a $RRDGRAPHPM -a $PHTIX -a $PMTIX < $MAILFILE
