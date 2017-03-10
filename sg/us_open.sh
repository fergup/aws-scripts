#!/bin/bash
###################################################################################
#
# us_open.sh
# ----------
# Takes input from Service Now reports and processes them for daily report to UK
# management to track open Incidents
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 30/04/15 |  PRF   | First edition
# |   1.1   | 05/06/15 |  PRF   | With chaser emails for queue owners
# |   1.2   | 13/06/15 |  PRF   | With new calculations for >20 day tickets
# ---------------------------------------------------------------------------------
#
# TEST changes - 
#   - Iterated files, RRD, mutt to all
#
###################################################################################
# Set variables
TIXDIR=/data/sn
ALLEURTIX=$TIXDIR/USXOpenXIncidentsXPFXExport.csv
CLOSED=$TIXDIR/UKXClosedXYesterdayXINCXCHGXRITM.csv
RRDFILE=/data/rrd/us_open20.rrd
#RRDFILENEW=/data/rrd/us_open_new2.rrd	# New RRD file for 10/20/30 day iterations
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
INCOVER1020=$(for i in $(cat $ALLEURTIX |awk -F'",' '($18~"Incident") { print $7 }'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'| perl -ne 'print if grep {$_>20} /(\d{1,})/g' |wc -l)
INCNEWINSCOPE20=$(for i in $(cat $ALLEURTIX |awk -F'",' '($18~"Incident") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "20|21" |wc -l)
INCNEWINSCOPER20=$(for i in $(cat $ALLEURTIX |awk -F'",' '($18~"Incident")&&($5~"Resolved") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "20|21" |wc -l)
#INCNEWINSCOPER30=$(for i in $(cat $OPEN |awk -F'",' '($21~"Incident")&&($4~"Resolved") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "30|31" |wc -l)
#INCALL30=$(cat $OPEN|awk -F'",' '($21~"Incident")&&($4!~"Resolved") { print $0 }'|wc -l)
#INCCLOSEDY20=$(cat $CLOSED|awk -F'","' '($15~"Incident")&&($19>1728000) { print $0 }'|wc -l)
INCCLOSEDY20=$(cat $CLOSED|sed 's/"//g'|awk -F, '($15~"Incident")&&($19>1728000) { print $19 }'|wc -l)
INCRES20=$(cat $ALLEURTIX|awk -F'","' '($18~"Incident")&&($5~"Resolved")&&($20>1728000) { print $0 }'|wc -l)
INCMORE30=$(grep -iv ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000) { print $6 }' |wc -l)
INCMORE20=$(grep -iv ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $6 }' |wc -l)
INCMORE10=$(grep -iv ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>864000) { print $6 }' |wc -l)
INCIPDUMORE30=$(grep -i ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000) { print $6 }' |wc -l)
INCIPDUMORE20=$(grep -i ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $6 }' |wc -l)
INCIPDUMORE10=$(grep -i ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>864000) { print $6 }' |wc -l)
# RRD things
RRDGRAPHALL=/data/images/us_open_all.png
RRDGRAPHINC=/data/images/us_open_inc.png
RRDGRAPHINCNEW=/data/images/us_open_inc_non_ipdu.png
RRDGRAPHINCIPDU=/data/images/us_open_inc_ipdu.png
MAILFILE=/data/mail/us_open_mail
HTMLFILE=/data/mail/us_open.html
PDFFILE=/data/mail/us_open.pdf
PHTIX=/data/mail/us_open_tickets.txt
INCOUT=/data/mail/us-inc-twentya.html
INCOUTNEW=/data/mail/us-inc-twentyb.html
# RRD updates and graphs
rrdtool update $RRDFILENEW "$RRDDATE@$INCMORE30:$INCMORE20:$INCMORE10:$INCIPDUMORE30:$INCIPDUMORE20:$INCIPDUMORE10"
rrdtool update $RRDFILE "$RRDDATE@$INCMORE20:$INCRES20:$INCOVER1020:$INCNEWINSCOPE20:$INCNEWINSCOPER20:$INCCLOSEDY20"
#echo $RRDFILE "$RRDDATE@$INCALL:$INCRES:$INCOVER10:$INCNEWINSCOPE:$INCNEWINSCOPER:$INCCLOSEDY:$REQALL:$REQRES:$REQOVER10:$REQNEWINSCOPE:$REQNEWINSCOPER:$REQCLOSEDY:$CHGALL:$CHGRES:$CHGOVER10:$CHGNEWINSCOPE:$CHGNEWINSCOPER:$CHGCLOSEDY"
rrdtool graph $RRDGRAPHINC -a PNG --title="All Open Incidents - Europe (over 20 days old)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/us_open20.rrd:over20:AVERAGE' 'DEF:probe2=/data/rrd/us_open20.rrd:resolved:AVERAGE' 'DEF:probe3=/data/rrd/us_open20.rrd:notupdted:AVERAGE' 'DEF:probe4=/data/rrd/us_open20.rrd:newinscope:AVERAGE' 'DEF:probe5=/data/rrd/us_open20.rrd:newinscoper:AVERAGE' 'DEF:probe6=/data/rrd/us_open20.rrd:closedy:AVERAGE' 'AREA:probe1#FF0000:All Open Tickets:STACK' 'AREA:probe2#00FF00:Resolved:STACK' 'AREA:probe3#0000FF:Not Updated in Ten Days:STACK' 'AREA:probe4#000000:New In Scope:STACK' 'AREA:probe5#FFFF00:New In Scope (Resolved):STACK' 'AREA:probe6#48C4EC:Closed Yesterday:STACK' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-6w -e now+1d
rrdtool graph $RRDGRAPHINCNEW -a PNG --title="Open Incidents - Europe (non-IPDU)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/us_open_new2.rrd:thirty-nipdu:AVERAGE' 'DEF:probe2=/data/rrd/us_open_new2.rrd:twenty-nipdu:AVERAGE' 'DEF:probe3=/data/rrd/us_open_new2.rrd:ten-nipdu:AVERAGE'  'AREA:probe3#FF0000:Over 10 Days Old' 'AREA:probe2#00FF00:Over Twenty Days Old' 'AREA:probe1#0000FF:Over 30 Days Old' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-6w -e now+1d
rrdtool graph $RRDGRAPHINCIPDU -a PNG --title="Open Incidents - Europe (IPDU)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/us_open_new2.rrd:thirty-ipdu:AVERAGE' 'DEF:probe2=/data/rrd/us_open_new2.rrd:twenty-ipdu:AVERAGE' 'DEF:probe3=/data/rrd/us_open_new2.rrd:ten-ipdu:AVERAGE'  'AREA:probe3#FF0000:Over 10 Days Old' 'AREA:probe2#00FF00:Over Twenty Days Old' 'AREA:probe1#0000FF:Over 30 Days Old' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-6w -e now+1d
# Create mail file
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
printf "<span style='font-family:arial;text-align: center'><table border='1'><tr><td width="700" colspan="7" bgcolor="FF9999"><b>Incidents - 30/20/10 days old</b></td></tr><tr><td width=100 rowspan="2" bgcolor="FFBBBB"><b>Date</b><td width=300 colspan="3" bgcolor="66CCFF"><b>Non-IPDU related</b></td><td width=300 colspan="3" bgcolor="33CC33"><b>IPDU related<b></td><tr><td width=100 bgcolor="00EEFF"><b>Over 30 days old</b></td><td width=100 bgcolor="00EEFF"><b>Over 20 days old</b></td><td width=100 bgcolor="00EEFF"><b>Over 10 days old</b></td><td width=100 bgcolor="00EE22"><b>Over 30 days old</b></td><td width=100 bgcolor="00EE22"><b>Over 20 days old</b></td><td width=100 bgcolor="00EE22"><b>Over 10 days old</b></td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=100>$INCMORE30</td><td width=100>$INCMORE20</td><td width=100>$INCMORE10</td><td width=100>$INCIPDUMORE30</td><td width=100>$INCIPDUMORE20</td><td width=100>$INCIPDUMORE10</td></tr>" >> $INCOUTNEW
uniq $INCOUTNEW |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
printf "<br><span style='font-family:arial;text-align: center'><table border='1'><tr><td width=100 colspan="7" bgcolor="FFFF66"><b>Incidents over 20 days old - detailed view</b></td></tr><tr bgcolor="FFFFCC"><td width=100><b>Date</b></td><td width=100><b>Over 20 days old</b></td><td width=100><b>In resolved state</b></td><td width=100><b>Not updated in past 10 days</b></td><td width=100><b>New in scope</b></td><td width=100><b>New in scope resolved</b></td><td width=100><b>Closed yesterday</b></td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=100>$INCMORE20</td><td width=100>$INCRES20</td><td width=100>$INCOVER1020</td><td width=100>$INCNEWINSCOPE20</td><td width=100>$INCNEWINSCOPER20</td><td>$INCCLOSEDY20</td></tr>" >> $INCOUT
uniq $INCOUT |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
#[[ $CHECKSUM != 0 ]] && printf "<font color="red" face="arial">Checksum = $CHECKSUM! Please investigate.</html>" >> $MAILFILE 
# Create PDF
cp $MAILFILE $HTMLFILE
printf "<br><br><H4>Trend Graphs</H4>
<table>
<tr><img src="$RRDGRAPHINCNEW" width=600></tr>
<tr><img src="$RRDGRAPHINCIPDU" width=600></tr>
<tr><img src="$RRDGRAPHINC" width=600></tr>
<tr><img src="$RRDGRAPHREQ" width=600></tr>
<tr><img src="$RRDGRAPHCHG" width=600></tr>
</table>" >> $HTMLFILE
/usr/local/bin/wkhtmltopdf-amd64 $HTMLFILE $PDFFILE
# Create attachment for tickets > 30 days
printf "<br><b>Open Incidents older than 20 days by queue</b><br>" >> $MAILFILE
cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $10" - "$19"<br>" }' |sort|uniq -c |sort -rn >> $MAILFILE
echo " " >> $MAILFILE
printf "<br><span style='font-family:arial;text-align:left'><br><b>Open Incidents over 20 days old by queue owner
</b><br><br>" >> $MAILFILE
#for i in `cat $OPEN |awk -F'",' '($21~"Incident")&&($4!~"Resolved") { print $23 }' |sort|uniq -c |sort -rn|sed 's/ "/ - /g' |sed 's/"//g' |head -15 |awk -F- '{ print $2 }'`; do echo " ";printf "<b>Owner: $i</b>";echo " ";head -1 $OPEN | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$23"</td></tr>" }';cat $OPEN | awk -F'","' '($21~"Incident")&&($4!~"Resolved") { print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$23"</td></tr>" }' |grep $i; echo "</table></span><br>";done >> $MAILFILE
unset IFS
for i in `cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $21 }' |sort|uniq -c |sort -rn |awk  '{ print $2 }'|sed 's/"//g'`; do echo " ";printf "<b>Owner: $i</b>";echo " ";head -1 $ALLEURTIX | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }';cat $ALLEURTIX | awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print "<tr><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>"}'|sed 's/"//g'| grep $i; echo "</table></span><br>";done >> $MAILFILE
for OWNER in `cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $21 }' |sort|uniq -c |sort -rn|sed 's/ "/ - /g' |sed 's/"//g'  |awk  '{ print $2 }'|grep -v patrick.bays`
        do echo " ";printf "<b>Owner: $OWNER</b>";echo " ";head -1 $ALLEURTIX | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }'|tee /tmp/$OWNER.mail;cat $ALLEURTIX | awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print "<tr><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }'|sed 's/"//g' |grep $OWNER |tee -a /tmp/$OWNER.mail
        echo "</table></span><br>" |tee -a /tmp/$OWNER.mail
#        mutt -e 'set content_type="text/html"' "$OWNER" -c "paul.ferguson@sungardas.com" -s "Good morning. Your team have Incidents over 20 days old" < /tmp/$OWNER.mail
done
# Send emails
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "US Daily Open Ticket Report"  -a $RRDGRAPHINCNEW -a $RRDGRAPHINC -a $RRDGRAPHINCIPDU -a $PDFFILE < $MAILFILE
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "US Daily Open Ticket Report"  < $MAILFILE
# Tidy up
mv /tmp/*.mail /data/sn/archive
