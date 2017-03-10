!/bin/bash
###################################################################################
#
# ph_open.sh
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
OPEN=/data/sn/PHXOpenXTicketsXoverX30Xdays.csv
CLOSED=/data/sn/PHXClosedXYesterday.csv
RRDFILE=/data/rrd/sn_ph_open.rrd
DATE=$(date +%Y-%m-%d" "%H:%M:%S)
DDATE=$(date +%d/%m/%Y)
IFS='"'
datediff() {
     d1=$(date -d "$1" +%s)
     d2=$(date -d "$2" +%s)
     echo $(( (d1 - d2) / 86400 )) days
}
OVER10=$(for i in $(cat $OPEN |awk -F, '{ print $7 }'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|grep [1-9][1-9] |wc -l)
NEWINSCOPE=$(for i in $(cat $OPEN |awk -F, '{ print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "30|31" |wc -l)
NEWINSCOPER=$(for i in $(cat $OPEN |awk -F, '($5~"Resolved") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "30|31" |wc -l)
ALL=$(cat $OPEN|grep -v assigned_to.manager.manager|wc -l)
CLOSEDY=$(cat $CLOSED|grep -v company.u_oracle_id |wc -l)
RES=$(cat $OPEN|awk -F, '($5~"Resolved") { print $0 }'|wc -l)
RRDDATE=$(date +%m/%d/%Y" "%H:%M)
RRDFILE=/data/rrd/sn_ph_open.rrd
RRDGRAPHALL=/data/images/ph_pm_inc_all_nostack.png
RRDGRAPHPH=/data/images/ph_all_stack.png
RRDGRAPHOPEN=/data/images/ph_all_open.png
RRDGRAPHPM=/data/images/pm_all_stack.png
MAILFILE=/data/mail/pmphmail
PHTIX=/data/mail/Paul_Higgins_Open_Tickets
# Do stuff
rrdtool update $RRDFILE "$RRDDATE@$ALL:$RES:$OVER10:$NEWINSCOPE:$NEWINSCOPER:$CLOSEDY"
rrdtool graph $RRDGRAPHOPEN -a PNG --title="European Open Tickets" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/sn_ph_open.rrd:ph-all:AVERAGE' 'DEF:probe2=/data/rrd/sn_ph_open.rrd:ph-res:AVERAGE' 'DEF:probe3=/data/rrd/sn_ph_open.rrd:ph-notinten:AVERAGE' 'DEF:probe4=/data/rrd/sn_ph_open.rrd:ph-newinscope:AVERAGE' 'DEF:probe5=/data/rrd/sn_ph_open.rrd:ph-newinscoperes:AVERAGE' 'DEF:probe6=/data/rrd/sn_ph_open.rrd:ph-closedyes-inc:AVERAGE' 'AREA:probe1#FF0000:All Open Tickets:STACK' 'AREA:probe2#00FF00:Resolved:STACK' 'AREA:probe3#0000FF:Not Updated in Ten Days:STACK' 'AREA:probe4#000000:New In Scope:STACK' 'AREA:probe5#FFFF00:New In Scope (Resolved):STACK' 'AREA:probe6#48C4EC:Closed Yesterday:STACK' -w 600 -h 300 -n TITLE:13: --alt-y-grid -l 0 -s now-1w -e now+1d
echo "" > $MAILFILE
printf "<table border='1'><span style='font-family:arial'>
<tr><span style='font-family:arial;font-weight:normal'>
<td width=100><b>Date</b></font></td><td width=150><b>Open incident tickets raised over 30 days ago</b></td><td width=100><b>In resolved state</b></td><td width=100><b>Not updated in past 10 days</b><td width=100><b>New in scope</b></td><td width=100><b>New in scope resolved</b></td><td width=60><b>Closed yesterday</b></td></span></tr>
<tr><td width=100><center>$DDATE</font></td><td width=60><center>$ALL</td><td width=100><center>$RES</td><td width=60><center>$OVER10</td><td width=60><center>$NEWINSCOPE<td width=60><center>$NEWINSCOPER</td><td><center>$CLOSEDY</td></span></tr></table>" >> $MAILFILE

# Send mail
cat $OPEN |awk -F, '{ print $10" "$18 }' |sort|uniq -c|egrep "UK|IE|FR|OSS|SE" |sed 's/" "/ (/g' |sed 's/"$/)/g'|sed 's/"//g' |sort -rn > $PHTIX
# Send report
#mutt  -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "Daily PH Open Tickets"  -a $RRDGRAPHOPEN -a $PHTIX < $MAILFILE
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,ryan.bell@sungardas.com,stephen.carroll@sungardas.com,paul.higgins@sungardas.com" -s "Daily PH Open Tickets" -a $RRDGRAPHOPEN -a $PHTIX < $MAILFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "Daily PH Open Tickets" -a $RRDGRAPHOPEN -a $PHTIX < $MAILFILE
