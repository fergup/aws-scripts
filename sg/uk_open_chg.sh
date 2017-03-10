#!/bin/bash
###################################################################################
#
# uk_open.sh
# ----------
# Takes input from Service Now reports and processes them for daily report to UK
# management to track open Incidents
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 30/04/15 |  PRF   | First edition
# ---------------------------------------------------------------------------------
#
###################################################################################
# Set variables
TIXDIR=/data/sn
OPEN=$TIXDIR/UKXOpenXINCXCHGXRITM.csv
ALLEURTIX=$TIXDIR/EuropeanXOpenXIncidentsXPFXExport.csv
CLOSED=$TIXDIR/UKXClosedXYesterdayXINCXCHGXRITM.csv
#CLOSED=$TIXDIR/PHXClosedXYesterday.csv
RRDFILE=/data/rrd/uk_open.rrd
RRDFILENEW=/data/rrd/uk_open_new.rrd	# New RRD file for 10/20/30 day iterations
RRDDATE=$(date +%m/%d/%Y" "%H:%M)
DATE=$(date +%Y-%m-%d" "%H:%M:%S)
DDATE=$(date +%d/%m/%Y)
IFS='"'
datediff() {
     d1=$(date -d "$1" +%s)
     d2=$(date -d "$2" +%s)
     echo $(( (d1 - d2) / 86400 )) days
}
# Incidents
INCOVER10=$(for i in $(cat $OPEN |awk -F'",' '($21~"Incident") { print $12 }'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|grep [1-9][1-9] |wc -l)
INCNEWINSCOPE=$(for i in $(cat $OPEN |awk -F'",' '($21~"Incident") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "30|31" |wc -l)
INCNEWINSCOPER=$(for i in $(cat $OPEN |awk -F'",' '($21~"Incident")&&($4~"Resolved") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "30|31" |wc -l)
INCALL=$(cat $OPEN|awk -F'",' '($21~"Incident")&&($4!~"Resolved") { print $0 }'|wc -l)
INCCLOSEDY=$(cat $CLOSED|awk -F'",' '($15~"Incident") { print $0 }'|wc -l)
INCRES=$(cat $OPEN|awk -F'",' '($21~"Incident")&&($4~"Resolved") { print $0 }'|wc -l)
INCMORE30=$(for i in $(cat $ALLEURTIX |awk -F'",' '($18~"Incident")&&($5!~"Resolved") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|perl -ne 'print if grep {$_>30} /(\d{1,})/g' |wc -l)
INCMORE20=$(for i in $(cat $ALLEURTIX |awk -F'",' '($18~"Incident")&&($5!~"Resolved") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'| perl -ne 'print if grep {$_>20} /(\d{1,})/g' |wc -l)
INCMORE10=$(for i in $(cat $ALLEURTIX |awk -F'",' '($18~"Incident")&&($5!~"Resolved") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'| perl -ne 'print if grep {$_>10} /(\d{1,})/g' |wc -l)
# Request
REQOVER10=$(for i in $(cat $OPEN |awk -F'",' '($21~"Request") { print $12 }'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|grep [1-9][1-9] |wc -l)
REQNEWINSCOPE=$(for i in $(cat $OPEN |awk -F'",' '($21~"Request") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "30|31" |wc -l)
REQNEWINSCOPER=$(for i in $(cat $OPEN |awk -F'",' '($21~"Request")&&($4~"Resolved") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "30|31" |wc -l)
REQALL=$(cat $OPEN|awk -F'",' '($21~"Request") { print $0 }'|wc -l)
REQCLOSEDY=$(cat $CLOSED|awk -F'",' '($15~"Request") { print $0 }'|wc -l)
REQRES=$(cat $OPEN|awk -F'",' '($21~"Request")&&($4~"Resolved") { print $0 }'|wc -l)
# Change
unset IFS # The Change stuff gets upset by the IFS setting
CHGOVER10=$(for i in $(cat $OPEN |awk -F'",' '($21~"Change")&&($4~"Execution/Validation") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|awk '($1 >= 10) { print $1 }'  |wc -l)
CHGNEWINSCOPE=$(cat $OPEN |awk -F'","' '($21~"Change")&&($3=="") { print $3 }' |wc -l)
CHGNEWINSCOPER=$(cat $OPEN |awk -F'","' '($21~"Change")&&($4=="Resolved") { print $1 }'|wc -l)
CHGALL=$(for i in $(cat $OPEN |awk -F'",' '($21~"Change") { print $6 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|awk '($1 >= 90) { print $1 }' |wc -l)
CHGCLOSEDY=$(cat $CLOSED|awk -F'",' '($15~"Change Request") { print $0 }'|wc -l)
CHGRES=$(for i in $(cat $OPEN |awk -F'",' '($21~"Change") { print $22 }'|sed 's/"//g'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|awk '($1 >= 30) { print $1 }'  |wc -l)
# RRD things
RRDGRAPHALL=/data/images/uk_open_all.png
RRDGRAPHINC=/data/images/uk_open_inc.png
RRDGRAPHINCNEW=/data/images/uk_open_inc_new.png
RRDGRAPHREQ=/data/images/uk_open_req.png
RRDGRAPHCHG=/data/images/uk_open_chg.png
MAILFILE=/data/mail/uk_open_mail
HTMLFILE=/data/mail/uk_open.html
PDFFILE=/data/mail/uk_open.pdf
PHTIX=/data/mail/uk_open_tickets.txt
INCOUT=/data/mail/open-inc-new.html
INCOUTNEW=/data/mail/open-inc-new1.html
REQOUT=/data/mail/open-req-new.html
CHGOUT=/data/mail/open-chg-new.html
#oINCYES=$(grep $(date -d yesterday +%d/%m/%Y) $INCOUT |tail -1|awk -F'<' '{ print $8 }'|sed 's/center>//g')
#INCYES=$(grep $(date -d yesterday +%d/%m/%Y) $INCOUT |tail -1|awk -F'<' '{ print $5 }'|sed 's/td width=100>//g')
#CHECKSUM=$(($INCALL-($INCYES-$INCCLOSEDY+$INCNEWINSCOPE)))
# Update RRD database file
rrdtool update $RRDFILE "$RRDDATE@$INCALL:$INCRES:$INCOVER10:$INCNEWINSCOPE:$INCNEWINSCOPER:$INCCLOSEDY:$REQALL:$REQRES:$REQOVER10:$REQNEWINSCOPE:$REQNEWINSCOPER:$REQCLOSEDY:$CHGALL:$CHGRES:$CHGOVER10:$CHGNEWINSCOPE:$CHGNEWINSCOPER:$CHGCLOSEDY"
rrdtool update $RRDFILENEW "$RRDDATE@$INCMORE30:$INCMORE20:$INCMORE10"
#echo $RRDFILE "$RRDDATE@$INCALL:$INCRES:$INCOVER10:$INCNEWINSCOPE:$INCNEWINSCOPER:$INCCLOSEDY:$REQALL:$REQRES:$REQOVER10:$REQNEWINSCOPE:$REQNEWINSCOPER:$REQCLOSEDY:$CHGALL:$CHGRES:$CHGOVER10:$CHGNEWINSCOPE:$CHGNEWINSCOPER:$CHGCLOSEDY"
rrdtool graph $RRDGRAPHINC -a PNG --title="Open Incidents - Europe (2 weeks)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/uk_open.rrd:inc-all:AVERAGE' 'DEF:probe2=/data/rrd/uk_open.rrd:inc-res:AVERAGE' 'DEF:probe3=/data/rrd/uk_open.rrd:inc-notinten:AVERAGE' 'DEF:probe4=/data/rrd/uk_open.rrd:inc-newinscope:AVERAGE' 'DEF:probe5=/data/rrd/uk_open.rrd:inc-newinscoperes:AVERAGE' 'DEF:probe6=/data/rrd/uk_open.rrd:inc-closedyes:AVERAGE' 'AREA:probe1#FF0000:All Open Tickets:STACK' 'AREA:probe2#00FF00:Resolved:STACK' 'AREA:probe3#0000FF:Not Updated in Ten Days:STACK' 'AREA:probe4#000000:New In Scope:STACK' 'AREA:probe5#FFFF00:New In Scope (Resolved):STACK' 'AREA:probe6#48C4EC:Closed Yesterday:STACK' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-12w -e now+1d
rrdtool graph $RRDGRAPHREQ -a PNG --title="Open Requests - Europe (2 weeks)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/uk_open.rrd:req-all:AVERAGE' 'DEF:probe2=/data/rrd/uk_open.rrd:req-res:AVERAGE' 'DEF:probe3=/data/rrd/uk_open.rrd:req-notinten:AVERAGE' 'DEF:probe4=/data/rrd/uk_open.rrd:req-newinscope:AVERAGE' 'DEF:probe5=/data/rrd/uk_open.rrd:req-newinscoperes:AVERAGE' 'DEF:probe6=/data/rrd/uk_open.rrd:req-closedyes:AVERAGE' 'AREA:probe1#FF0000:All Open Tickets:STACK' 'AREA:probe2#00FF00:Resolved:STACK' 'AREA:probe3#0000FF:Not Updated in Ten Days:STACK' 'AREA:probe4#000000:New In Scope:STACK' 'AREA:probe5#FFFF00:New In Scope (Resolved):STACK' 'AREA:probe6#48C4EC:Closed Yesterday:STACK' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-12w -e now+1d
rrdtool graph $RRDGRAPHCHG -a PNG --title="Open Changes - Europe (2 weeks)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/uk_open.rrd:chg-all:AVERAGE' 'DEF:probe2=/data/rrd/uk_open.rrd:chg-res:AVERAGE' 'DEF:probe3=/data/rrd/uk_open.rrd:chg-notinten:AVERAGE' 'DEF:probe4=/data/rrd/uk_open.rrd:chg-newinscope:AVERAGE' 'DEF:probe5=/data/rrd/uk_open.rrd:chg-newinscoperes:AVERAGE' 'DEF:probe6=/data/rrd/uk_open.rrd:chg-closedyes:AVERAGE' 'AREA:probe1#FF0000:Open over 90 days ago:STACK' 'AREA:probe2#00FF00:Planned to finish over 30 days ago:STACK' 'AREA:probe3#0000FF:Execute/Validate & over 10 days old:STACK' 'AREA:probe4#000000:No Individual Assigned:STACK' 'AREA:probe5#FFFF00:Resolved:STACK' 'AREA:probe6#48C4EC:Closed Yesterday:STACK' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-12w -e now
rrdtool graph $RRDGRAPHINCNEW -a PNG --title="Open Incidents - Europe" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/uk_open_new.rrd:thirty:AVERAGE' 'DEF:probe2=/data/rrd/uk_open_new.rrd:twenty:AVERAGE' 'DEF:probe3=/data/rrd/uk_open_new.rrd:ten:AVERAGE'  'AREA:probe3#FF0000:Over 10 Days Old' 'AREA:probe2#00FF00:Over Twenty Days Old' 'AREA:probe1#0000FF:Over 30 Days Old' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-12w -e now
# Create mail file
echo "" > $MAILFILE
printf "<span style='font-family:arial;text-align: center'><table border='1'><tr><td width=100 colspan="4" bgcolor="FF9999"><b>Incidents - 30/20/10</b></td></tr><tr><td width=100><b>Date</b></td><td width=100><b>Raised over 30 days ago</b></td><td width=100><b>Raised over 20 days ago</b></td><td width=100><b>Raised over 10 days ago</b></td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=100>$INCMORE30</td><td width=100>$INCMORE20</td><td width=100>$INCMORE10</td></tr>" >> $INCOUTNEW
uniq $INCOUTNEW |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
printf "<br><span style='font-family:arial;text-align: center'><table border='1'><tr><td width=100 colspan="7" bgcolor="FF9999"><b>Incidents</b></td></tr><tr><td width=100><b>Date</b></td><td width=100><b>Raised over 30 days ago</b></td><td width=100><b>In resolved state</b></td><td width=100><b>Not updated in past 10 days</b></td><td width=100><b>New in scope</b></td><td width=100><b>New in scope resolved</b></td><td width=100><b>Closed yesterday</b></td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=100>$INCALL</td><td width=100>$INCRES</td><td width=100>$INCOVER10</td><td width=100>$INCNEWINSCOPE</td><td width=100>$INCNEWINSCOPER</td><td>$INCCLOSEDY</td></tr>" >> $INCOUT
uniq $INCOUT |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
printf "<br><span style='font-family:arial;text-align: center'><table border='1'><tr><td width=100 colspan="7" bgcolor="66CCFF"><b>Requests</b></td></tr><tr><td width=100><b>Date</b></td><td width=100><b>Raised over 30 days ago</b></td><td width=100><b>In resolved state</b></td><td width=100><b>Not updated in past 10 days</b></td><td width=100><b>New in scope</b></td><td width=100><b>New in scope resolved</b></td><td width=100><b>Closed yesterday</b></td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=100>$REQALL</td><td width=100>$REQRES</td><td width=100>$REQOVER10</td><td width=100>$REQNEWINSCOPE</td><td width=100>$REQNEWINSCOPER</td><td>$REQCLOSEDY</td></tr>" >> $REQOUT
uniq $REQOUT |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
printf "<br><span style='font-family:arial;text-align: center'><table border='1'><tr><td width=100 colspan="7" bgcolor="33CC33"><b>Changes</b></td></tr><tr><td width=100><b>Date</b></td><td width=100><b>Opened over 90 days ago</b></td><td width=100><b>'Planned Date' is over 30 days ago</b></td><td width=100><b>'Execute/Validate' & last update is over 10 days ago</b></td><td width=100><b>No Individual Assigned</b></td><td width=100><b>Resolved</b></td><td width=100><b>Closed yesterday</b></td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=100>$CHGALL</td><td width=100>$CHGRES</td><td width=100>$CHGOVER10</td><td width=100>$CHGNEWINSCOPE</td><td width=100>$CHGNEWINSCOPER</td><td>$CHGCLOSEDY</td></tr>" >> $CHGOUT
uniq $CHGOUT |tail -5| tac >> $MAILFILE ;printf "</span></table>" >> $MAILFILE
#printf "<br>Over 10 days = $INCMORE10" >> $MAILFILE
#printf "<br>Over 20 days = $INCMORE20" >> $MAILFILE
#[[ $CHECKSUM != 0 ]] && printf "<font color="red" face="arial">Checksum = $CHECKSUM! Please investigate.</html>" >> $MAILFILE 
# Create PDF
cp $MAILFILE $HTMLFILE
printf "<br><br><H4>Trend Graphs</H4>
<table>
<tr><img src="$RRDGRAPHINC" width=600></td></tr>
<tr><img src="$RRDGRAPHREQ" width=600></tr>
<tr><img src="$RRDGRAPHCHG" width=600></tr>
</table>" >> $HTMLFILE
/usr/local/bin/wkhtmltopdf-amd64 $HTMLFILE $PDFFILE
# Send mail
#cat $OPEN |awk -F'",' '{ print $10" "$18 }' |sort|uniq -c|egrep "UK|IE|FR|OSS|SE" |sed 's/" "/ (/g' |sed 's/"$/)/g'|sed 's/"//g' |sort -rn > $PHTIX
printf "Open Incidents
==============
" > $PHTIX
cat $OPEN |awk -F'",' '($21~"Incident") { print $2" "$13 }' |sort|uniq -c |sort -rn|sed 's/ "/ - /g' |head -15 >> $PHTIX
echo " " >> $PHTIX
printf "Open Requests
=============
" >> $PHTIX
cat $OPEN |awk -F'",' '($21~"Request") { print $2" "$13 }' |sort|uniq -c |sort -rn|sed 's/ "/ - /g' |head -15 >> $PHTIX
echo " " >> $PHTIX
printf "Open Changes
============
" >> $PHTIX
cat $OPEN |awk -F'",' '($21~"Change") { print $2" "$13 }' |sort|uniq -c |sort -rn|sed 's/ "/ - /g' |head -15 >> $PHTIX
echo " " >> $PHTIX
# Send report
mutt -e 'set content_type="text/html"' "david.wilcock@sungardas.com" -s  "Daily UK Open Change and Incident Report" -a $RRDGRAPHINCNEW -a $RRDGRAPHINC -a $RRDGRAPHREQ -a $RRDGRAPHCHG -a $PHTIX -a $PDFFILE < $MAILFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s  "Daily UK Open Change and Incident Report" -a $RRDGRAPHINCNEW -a $RRDGRAPHINC -a $RRDGRAPHREQ -a $RRDGRAPHCHG -a $PHTIX -a $PDFFILE < $MAILFILE
