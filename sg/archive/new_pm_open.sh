!/bin/bash
###################################################################################
#
# pm_open.sh
# ----------
# Takes input from Service Now reports and processes them for daily report to Pat
# Morley to track open tickets for his teams
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date     | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 11/05/2015 |  PRF   | First edition
# |   1.1   | 08/07/2015 |  PRF   | Second edition - with emails to queue managers
# ---------------------------------------------------------------------------------
#
###################################################################################
# Set variables
OPEN=/data/sn/PatXMorleyXOpenXticketsXOlderXThanX30XDays.csv
CLOSED=/data/sn/PMXClosedXYesterday.csv
RRDFILE=/data/rrd/pm_open.rrd
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
INCALL=$(cat $OPEN|awk -F'",' '($21~"Incident") { print $0 }'|wc -l)
INCCLOSEDY=$(cat $CLOSED|awk -F'",' '($15~"Incident") { print $0 }'|wc -l)
INCRES=$(cat $OPEN|awk -F'",' '($21~"Incident")&&($4~"Resolved") { print $0 }'|wc -l)
INCTOT=$(expr $INCALL - $INCRES)
# Request
REQOVER10=$(for i in $(cat $OPEN |awk -F'",' '($21~"Request") { print $12 }'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|grep [1-9][1-9] |wc -l)
REQNEWINSCOPE=$(for i in $(cat $OPEN |awk -F'",' '($21~"Request") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "30|31" |wc -l)
REQNEWINSCOPER=$(for i in $(cat $OPEN |awk -F'",' '($21~"Request")&&($4~"Resolved") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "30|31" |wc -l)
REQALL=$(cat $OPEN|awk -F'",' '($21~"Request") { print $0 }'|wc -l)
REQCLOSEDY=$(cat $CLOSED|awk -F'",' '($15~"Request") { print $0 }'|wc -l)
REQRES=$(cat $OPEN|awk -F'",' '($21~"Request")&&($4~"Resolved") { print $0 }'|wc -l)
# Change
CHGOVER10=$(for i in $(cat $OPEN |awk -F'",' '($21~"Change") { print $12 }'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|grep [1-9][1-9] |wc -l)
CHGNEWINSCOPE=$(for i in $(cat $OPEN |awk -F'",' '($21~"Change") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "30|31" |wc -l)
CHGNEWINSCOPER=$(for i in $(cat $OPEN |awk -F'",' '($21~"Change")&&($4~"Resolved") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "30|31" |wc -l)
CHGALL=$(cat $OPEN|awk -F'",' '($21~"Change") { print $0 }'|wc -l)
CHGCLOSEDY=$(cat $CLOSED|awk -F'",' '($15~"Change") { print $0 }'|wc -l)
CHGRES=$(cat $OPEN|awk -F'",' '($21~"Change")&&($4~"Resolved") { print $0 }'|wc -l)
# RRD things
RRDGRAPHALL=/data/images/pm_open_all.png
RRDGRAPHINC=/data/images/pm_open_inc.png
RRDGRAPHREQ=/data/images/pm_open_req.png
RRDGRAPHCHG=/data/images/pm_open_chg.png
MAILFILE=/data/mail/pm_open_mail
HTMLFILE=/data/mail/pm_open.html
PDFFILE=/data/mail/pm_open.pdf
PHTIX=/data/mail/pm_open_tickets.txt
INCOUT=/data/mail/pm-open-inc.html
REQOUT=/data/mail/pm-open-req.html
CHGOUT=/data/mail/pm-open-chg.html
INCYES=$(grep $(date -d yesterday +%d/%m/%Y) $INCOUT |tail -1|awk -F'<' '{ print $8 }'|sed 's/center>//g')
CHECKSUM=$(($INCALL-($INCYES-$INCCLOSEDY+$INCNEWINSCOPE)))
# Update RRD database file
rrdtool update $RRDFILE "$RRDDATE@$INCALL:$INCRES:$INCOVER10:$INCNEWINSCOPE:$INCNEWINSCOPER:$INCCLOSEDY:$REQALL:$REQRES:$REQOVER10:$REQNEWINSCOPE:$REQNEWINSCOPER:$REQCLOSEDY:$CHGALL:$CHGRES:$CHGOVER10:$CHGNEWINSCOPE:$CHGNEWINSCOPER:$CHGCLOSEDY"
#echo $RRDFILE "$RRDDATE@$INCALL:$INCRES:$INCOVER10:$INCNEWINSCOPE:$INCNEWINSCOPER:$INCCLOSEDY:$REQALL:$REQRES:$REQOVER10:$REQNEWINSCOPE:$REQNEWINSCOPER:$REQCLOSEDY:$CHGALL:$CHGRES:$CHGOVER10:$CHGNEWINSCOPE:$CHGNEWINSCOPER:$CHGCLOSEDY"
rrdtool graph $RRDGRAPHINC -a PNG --title="Open Incidents - Europe (week)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/pm_open.rrd:inc-all:AVERAGE' 'DEF:probe2=/data/rrd/pm_open.rrd:inc-res:AVERAGE' 'DEF:probe3=/data/rrd/pm_open.rrd:inc-notinten:AVERAGE' 'DEF:probe4=/data/rrd/pm_open.rrd:inc-newinscope:AVERAGE' 'DEF:probe5=/data/rrd/pm_open.rrd:inc-newinscoperes:AVERAGE' 'DEF:probe6=/data/rrd/pm_open.rrd:inc-closedyes:AVERAGE' 'AREA:probe1#FF0000:All Open Tickets:STACK' 'AREA:probe2#00FF00:Resolved:STACK' 'AREA:probe3#0000FF:Not Updated in Ten Days:STACK' 'AREA:probe4#000000:New In Scope:STACK' 'AREA:probe5#FFFF00:New In Scope (Resolved):STACK' 'AREA:probe6#48C4EC:Closed Yesterday:STACK' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-24w -e now+1d
rrdtool graph $RRDGRAPHREQ -a PNG --title="Open Requests - Europe (week)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/pm_open.rrd:req-all:AVERAGE' 'DEF:probe2=/data/rrd/pm_open.rrd:req-res:AVERAGE' 'DEF:probe3=/data/rrd/pm_open.rrd:req-notinten:AVERAGE' 'DEF:probe4=/data/rrd/pm_open.rrd:req-newinscope:AVERAGE' 'DEF:probe5=/data/rrd/pm_open.rrd:req-newinscoperes:AVERAGE' 'DEF:probe6=/data/rrd/pm_open.rrd:req-closedyes:AVERAGE' 'AREA:probe1#FF0000:All Open Tickets:STACK' 'AREA:probe2#00FF00:Resolved:STACK' 'AREA:probe3#0000FF:Not Updated in Ten Days:STACK' 'AREA:probe4#000000:New In Scope:STACK' 'AREA:probe5#FFFF00:New In Scope (Resolved):STACK' 'AREA:probe6#48C4EC:Closed Yesterday:STACK' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-24w -e now+1d
rrdtool graph $RRDGRAPHCHG -a PNG --title="Open Changes - Europe (week)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/pm_open.rrd:chg-all:AVERAGE' 'DEF:probe2=/data/rrd/pm_open.rrd:chg-res:AVERAGE' 'DEF:probe3=/data/rrd/pm_open.rrd:chg-notinten:AVERAGE' 'DEF:probe4=/data/rrd/pm_open.rrd:chg-newinscope:AVERAGE' 'DEF:probe5=/data/rrd/pm_open.rrd:chg-newinscoperes:AVERAGE' 'DEF:probe6=/data/rrd/pm_open.rrd:chg-closedyes:AVERAGE' 'AREA:probe1#FF0000:All Open Tickets:STACK' 'AREA:probe2#00FF00:Resolved:STACK' 'AREA:probe3#0000FF:Not Updated in Ten Days:STACK' 'AREA:probe4#000000:New In Scope:STACK' 'AREA:probe5#FFFF00:New In Scope (Resolved):STACK' 'AREA:probe6#48C4EC:Closed Yesterday:STACK' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-24w -e now+1d
echo "" > $MAILFILE
printf "<head><style>
        table {
                border-collapse: collapse;
                font-family: Arial;
                font-size: 14;
                text-align: Center;
        }
        table, th, td {
        border: 1px solid black;
        }

td {
    vertical-align: bottom;
        padding: 5px;
        font-family: Arial;
}

td.dclass {
        margin-left: auto;
    margin-right: auto;
    vertical-align: bottom;
        padding: 5px;
        text-align: Center;
        font-family: Arial;
        font-size: 14;
}

th {
        margin-left: auto;
    margin-right: auto;
    vertical-align: bottom;
        padding: 5px;
        text-align: Center;
        font-family: Arial;
        background-color: #FF9897;
}

</style></head><body>
" >> $MAILFILE

#[[ $CHECKSUM != 0 ]] && printf "<font color="red" face="arial">Checksum = $CHECKSUM! Please investigate.</html>" >> $MAILFILE 
printf "<table border='1'><span style='font-family:arial'>
<tr><td width=100 colspan="7" bgcolor="FF9999"><font face="Arial"><align="center"><b>Incidents</td></tr>
<tr bgcolor="FFBBBB"><span style='font-family:arial;font-weight:normal'>
<td width=100><b>Date</b></font></td><td width=100><b>Raised over 30 days ago</b></td><td width=100><b>In resolved state</b></td><td width=100><b>Not updated in past 10 days</b><td width=100><b>New in scope</b></td><td width=100><b>New in scope resolved</b></td><td width=100><b>Closed yesterday</b></td></span></tr>" >> $MAILFILE
echo "<tr><td width=100><"center">$DDATE</font></td><td width=100><"center">$INCALL</td><td width=100><"center">$INCRES</td><td width=100><"center">$INCOVER10</td><td width=100><"center">$INCNEWINSCOPE<td width=100><"center">$INCNEWINSCOPER</td><td><"center">$INCCLOSEDY</td></tr>" >> $INCOUT
uniq $INCOUT |tail -5| tac >> $MAILFILE;printf "</table>" >> $MAILFILE
printf "<br><table border='1'><span style='font-family:arial'>
<tr><td width=100 colspan="7" bgcolor="66CCFF"><font face="Arial"><align="center"><b>Requests</td></tr>
<tr bgcolor="00EEFF"><span style='font-family:arial;font-weight:normal'>
<td width=100><b>Date</b></font></td><td width=100><b>Raised over 30 days ago</b></td><td width=100><b>In resolved state</b></td><td width=100><b>Not updated in past 10 days</b><td width=100><b>New in scope</b></td><td width=100><b>New in scope resolved</b></td><td width=100><b>Closed yesterday</b></td></span></tr>" >> $MAILFILE
echo "<tr><td width=100><"center">$DDATE</font></td><td width=100><"center">$REQALL</td><td width=100><"center">$REQRES</td><td width=100><"center">$REQOVER10</td><td width=100><"center">$REQNEWINSCOPE<td width=100><"center">$REQNEWINSCOPER</td><td><"center">$REQCLOSEDY</td></tr>" >> $REQOUT
uniq $REQOUT |tail -5| tac >> $MAILFILE;printf "</table>" >> $MAILFILE
printf "<br><table border='1'><span style='font-family:arial'>
<tr><td width=100 colspan="7" bgcolor="33CC33"><font face="Arial"><align="center"><b>Changes</td></tr>
<tr bgcolor="00EE22"><span style='font-family:arial;font-weight:normal'>
<td width=100><b>Date</b></font></td><td width=100><b>Raised over 30 days ago</b></td><td width=100><b>In resolved state</b></td><td width=100><b>Not updated in past 10 days</b><td width=100><b>New in scope</b></td><td width=100><b>New in scope resolved</b></td><td width=100><b>Closed yesterday</b></td></span></tr>" >> $MAILFILE
echo "<tr><td width=100><"center">$DDATE</font></td><td width=100><"center">$CHGALL</td><td width=100><"center">$CHGRES</td><td width=100><"center">$CHGOVER10</td><td width=100><"center">$CHGNEWINSCOPE<td width=100><"center">$CHGNEWINSCOPER</td><td><"center">$CHGCLOSEDY</td></tr>" >> $CHGOUT
uniq $CHGOUT |tail -5| tac >> $MAILFILE ;printf "</table>" >> $MAILFILE
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
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "Daily Pat Morley Open Tickets Report" -a $RRDGRAPHINC -a $RRDGRAPHREQ -a $RRDGRAPHCHG -a $PHTIX -a $PDFFILE < $MAILFILE
#
# List Change queue owners with most open tickets in order of ticket numbers outstanding
#
printf "<br><span style='font-family:arial;text-align:left'><b>Open Incidents older than 30 days by queue</b><br>" >> $MAILFILE
cat $OPEN |awk -F'","' '($21~"Incident")&&($4!~"Resolved") { print $2" - "$13"<br>" }' |sort|uniq -c |sort -rn >> $MAILFILE
echo " " >> $MAILFILE
printf "<br><span style='font-family:arial;text-align:left'><br><b>Open Incidents over 30 days old by queue owner
</b><br><br>" >> $MAILFILE
unset IFS
for i in $(cat $OPEN |awk -F'","' '($21~"Incident")&&($4!~"Resolved") { print $23 }' |sort|uniq -c |sort -rn |awk  '{ print $2 }'|sed 's/"//g'|sed '/^$/d'); do echo " ";printf "<b>Owner: $i</b>";echo " ";head -1 $OPEN | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$2"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$23"</td></tr>" }';cat $OPEN | awk -F'","' '($21~"Incident")&&($4!~"Resolved") { print "<tr><td>"$1"</td><td>"$2"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$23"</td></tr>"}'|sed 's/"//g'| grep $i; echo "</table></span><br>";done >> $MAILFILE
#
# List Change queue owners with most open tickets in order of ticket numbers outstanding
#
printf "<br><br><span style='font-family:arial;text-align:left'><b>Open Changes older than 30 days by queue</b><br>" >> $MAILFILE
cat $OPEN |awk -F'","' '($21~"Change Request") { print $2" - "$13"<br>" }' |sort|uniq -c |sort -rn >> $MAILFILE
echo " " >> $MAILFILE
printf "<br><span style='font-family:arial;text-align:left'><br><b>Open Changes over 30 days old by queue owner
</b><br><br>" >> $MAILFILE
unset IFS
for i in $(cat $OPEN |awk -F'","' '($21~"Change Request") { print $23 }' |sort|uniq -c |sort -rn |awk  '{ print $2 }'|sed 's/"//g'|sed '/^$/d'); do echo " ";printf "<b>Owner: $i</b>";echo " ";head -1 $OPEN | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$2"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$23"</td></tr>" }';cat $OPEN | awk -F'","' '($21~"Change Request") { print "<tr><td>"$1"</td><td>"$2"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$23"</td></tr>"}'|sed 's/"//g'| grep $i; echo "</table></span><br>";done >> $MAILFILE
#
# Email individual queue owners about their open tickets
#
for OWNER in $(cat $OPEN |awk -F'","' '($21~"Incident")&&($4!~"Resolved") { print $23 }'|sed 's/"//g'|sort|uniq|sed '/^$/d')
        do echo " ";printf "<b>Owner: $OWNER</b>";echo " ";head -1 $OPEN | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$2"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$23"</td></tr>" }'|tee /tmp/$OWNER.mail;cat $OPEN | awk -F'","' '($21~"Incident")&&($4!~"Resolved") { print "<tr><td>"$1"</td><td>"$2"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$23"</td></tr>" }'|sed 's/"//g' |grep $OWNER |tee -a /tmp/$OWNER.mail
        echo "</table></span><br>" |tee -a /tmp/$OWNER.mail
#        mutt -e 'set content_type="text/html"' "$OWNER" -c "patrick.morley@sungardas.com,paul.ferguson@sungardas.com" -s "Good morning. Your team have Incident tickets over 30 days old" < /tmp/$OWNER.mail
done
#
# Where there's no queue owner, mail the person direct
#
for ASSIGNEE in $(cat $OPEN |awk -F'","' '($21~"Incident")&&($4!~"Resolved")&&($23!~".com") { print $24 }'|sed 's/"//g'|sort|uniq|sed '/^$/d')
	do head -1 $OPEN | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$2"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$24"</td></tr>" }'|tee /tmp/$ASSIGNEE.mail;cat $OPEN | awk -F'","' '($21~"Incident")&&($4!~"Resolved")&&($23!~".com") { print "<tr><td>"$1"</td><td>"$2"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$24"</td></tr>" }'|sed 's/"//g' |grep $ASSIGNEE |tee -a /tmp/$ASSIGNEE.mail
        echo "</table></span><br>" |tee -a /tmp/$ASSIGNEE.mail
#        mutt -e 'set content_type="text/html"' "$ASSIGNEE" -c "patrick.morley@sungardas.com,paul.ferguson@sungardas.com" -s "Good morning. You have Incident ticket/s over 30 days old" < /tmp/$ASSIGNEE.mail
done
#
# Mail owners of Change tickets
#
for ASSIGNEE in $(cat $OPEN |awk -F'","' '($21~"Change Request") { print $24 }'|sed 's/"//g'|sort|uniq|sed '/^$/d')
	do head -1 $OPEN | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$2"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$24"</td></tr>" }'|tee /tmp/$ASSIGNEE.mail;cat $OPEN | awk -F'","' '($21~"Change Request") { print "<tr><td>"$1"</td><td>"$2"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$24"</td></tr>" }'|sed 's/"//g' |grep $ASSIGNEE |tee -a /tmp/$ASSIGNEE.mail
        echo "</table></span><br>" |tee -a /tmp/$ASSIGNEE.mail
#        mutt -e 'set content_type="text/html"' "$ASSIGNEE" -c "patrick.morley@sungardas.com,paul.ferguson@sungardas.com" -s "You have Change ticket/s over 30 days old. Please update or close them." < /tmp/$ASSIGNEE.mail
done
#
# Send master mail
#
#[[ $INCTOT != 0 ]] && mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,patrick.morley@sungardas.com,stephen.carroll@sungardas.com" -s "Daily Pat Morley Open Tickets Report" -a $RRDGRAPHINC -a $RRDGRAPHREQ -a $RRDGRAPHCHG -a $PHTIX -a $PDFFILE < $MAILFILE
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "Daily Pat Morley Open Tickets Report" -a $RRDGRAPHINC -a $RRDGRAPHREQ -a $RRDGRAPHCHG -a $PHTIX -a $PDFFILE < $MAILFILE
