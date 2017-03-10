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
OPEN=$TIXDIR/GlobalXOpenXIncidentsXPFXExport.csv
CLOSED=$TIXDIR/UKXClosedXYesterdayXINCXCHGXRITM.csv
RRDFILE=/data/rrd/sn_us.rrd
RRDGRAPH=/data/images/us_tickets.png
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
#INCNEWINSCOPER30=$(for i in $(cat $OPEN |awk -F'",' '($21~"Incident")&&($4~"Resolved") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "30|31" |wc -l)
#INCALL30=$(cat $OPEN|awk -F'",' '($21~"Incident")&&($4!~"Resolved") { print $0 }'|wc -l)
#INCCLOSEDY20=$(cat $CLOSED|awk -F'","' '($15~"Incident")&&($19>1728000) { print $0 }'|wc -l)
EU20=$(cat $OPEN|awk -F'","' '($18~"Incident")&&($22~"Europe")&&($5!~"Resolved")&&($20>1728000) { print $0 }'|wc -l)
EU15=$(cat $OPEN|awk -F'","' '($18~"Incident")&&($22~"Europe")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
EU10=$(cat $OPEN|awk -F'","' '($18~"Incident")&&($22~"Europe")&&($5!~"Resolved")&&($20>864000) { print $0 }'|wc -l)
EUCOMP=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($10~"compute|unix|window")&&($22~"Europe")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
EUNET=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($10~"net")&&($22~"Europe")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
EUSTOR=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($10~"stor")&&($22~"Europe")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
EUOTH=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($10!~"stor|net|compute|unix|window")&&($22~"Europe")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
EUFS=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($22~"Europe")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000)&&($23~"true") { print $0 }'|wc -l)
EUNOFS=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($22~"Europe")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000)&&($23!~"true") { print $0 }'|wc -l)
US20=$(cat $OPEN|awk -F'","' '($18~"Incident")&&($22~"US")&&($5!~"Resolved")&&($20>1728000) { print $0 }'|wc -l)
US15=$(cat $OPEN|awk -F'","' '($18~"Incident")&&($22~"US")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
US10=$(cat $OPEN|awk -F'","' '($18~"Incident")&&($22~"US")&&($5!~"Resolved")&&($20>864000) { print $0 }'|wc -l)
USCOMP=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($10~"compute|unix|window")&&($22~"US")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
USNET=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($10~"net")&&($22~"US")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
USSTOR=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($10~"stor")&&($22~"US")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
USOTH=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($10!~"stor|net|compute|unix|window")&&($22~"US")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
USFS=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($22~"US")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000)&&($23~"true") { print $0 }'|wc -l)
USNOFS=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($22~"US")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000)&&($23!~"true") { print $0 }'|wc -l)
# RRD things
RRDGRAPHEU=/data/images/eu_open_all.png
RRDGRAPHUS=/data/images/eu_open_all.png
MAILFILE=/data/mail/glob_open_mail
HTMLFILE=/data/mail/glob_open.html
PDFFILE=/data/mail/glob_open.pdf
EUOUT=/data/mail/glob_open_eu.html
USOUT=/data/mail/glob_open_us.html
# RRD updates and graphs
#rrdtool update $RRDFILENEW "$RRDDATE@$INCMORE30:$INCMORE20:$INCMORE10:$INCIPDUMORE30:$INCIPDUMORE20:$INCIPDUMORE10"
rrdtool update $RRDFILE "$RRDDATE@$US20:$US15:$US10:$USCOMP:$USNET:$USSTOR:$USOTH:$USFS:$USNOFS"
rrdtool graph $RRDGRAPH -a PNG '--title=All Open Incidents - US' --vertical-label 'Number of Tickets' DEF:probe1=/data/rrd/sn_us.rrd:us20:AVERAGE DEF:probe2=/data/rrd/sn_us.rrd:us15:AVERAGE DEF:probe3=/data/rrd/sn_us.rrd:us10:AVERAGE 'AREA:probe3#FF0000:Over 10 days old' 'AREA:probe2#00FF00:Over 15 days old' 'AREA:probe1#0000FF:Over 20 days old' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-6w -e now+1d
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
" > $MAILFILE
printf "<span style='font-family:arial;text-align: center'><table border='1'><tr><td width="700" colspan="10" bgcolor="#4F81BD"><b><font color="#FFFF66">Europe</font></b></td></tr><tr><td width=100 rowspan="2" bgcolor="#DAEEF3" style="vertical-align:middle"><b>Date</b><td width=300 colspan="3" bgcolor="#00EEFF"><b>Over (x) days old</b></td><td width=400 colspan="4" bgcolor="#00EE22" style="vertical-align:middle"><b>Discipline (>15 days)<b></td><td width=200 colspan="2" bgcolor="yellow"><b>FS</td></tr>
<tr><td width=100 bgcolor="#79F5FF"><b>20</b></td><td width=100 bgcolor="#79F5FF"><b>15</b></td><td width=100 bgcolor="#79F5FF"><b>10</b></td><td width=100 bgcolor="#59FD61"><b>Compute</b></td><td width=100 bgcolor="#59FD61"><b>Network</b></td><td width=100 bgcolor="#59FD61"><b>Storage</b></td><td bgcolor="#59FD61"><b>Other</td><td bgcolor="#FFFF66" width=100><b>FS</td><td bgcolor="#FFFF66" width=100><b>Non-FS</td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=100>$EU20</td><td width=100>$EU15</td><td width=100>$EU10</td><td width=100>$EUCOMP</td><td width=100>$EUNET</td><td width=100>$EUSTOR</td><td width=100>$EUOTH</td><td width=100>$EUFS</td><td width=100>$EUNOFS</td></tr>" >> $EUOUT
uniq $EUOUT |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
# US table
printf "<br><br><span style='font-family:arial;text-align: center'><table border='1'><tr><td width="700" colspan="10" bgcolor="red"><b><font color="white">North America</font></b></td></tr><tr><td width=100 rowspan="2" bgcolor="#DAEEF3" style="vertical-align:middle"><b>Date</b><td width=300 colspan="3" bgcolor="#00EEFF"><b>Over (x) days old</b></td><td width=400 colspan="4" bgcolor="#00EE22" style="vertical-align:middle"><b>Discipline (>15 days)<b></td><td width=200 colspan="2" bgcolor="yellow"><b>FS</td></tr>
<tr><td width=100 bgcolor="#79F5FF"><b>20</b></td><td width=100 bgcolor="#79F5FF"><b>15</b></td><td width=100 bgcolor="#79F5FF"><b>10</b></td><td width=100 bgcolor="#59FD61"><b>Compute</b></td><td width=100 bgcolor="#59FD61"><b>Network</b></td><td width=100 bgcolor="#59FD61"><b>Storage</b></td><td bgcolor="#59FD61"><b>Other</td><td bgcolor="#FFFF66" width=100><b>FS</td><td bgcolor="#FFFF66" width=100><b>Non-FS</td></tr>" >> $MAILFILE
# Insert variables into table
echo "<tr><td width=100>$DDATE</td><td width=100>$US20</td><td width=100>$US15</td><td width=100>$US10</td><td width=100>$USCOMP</td><td width=100>$USNET</td><td width=100>$USSTOR</td><td width=100>$USOTH</td><td width=100>$USFS</td><td width=100>$USNOFS</td></tr>" >> $USOUT
uniq $USOUT |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
#uniq $INCOUTNEW |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
#printf "<br><span style='font-family:arial;text-align: center'><table border='1'><tr><td width=100 colspan="7" bgcolor="FFFF66"><b>Incidents over 20 days old - detailed view</b></td></tr><tr bgcolor="FFFFCC"><td width=100><b>Date</b></td><td width=100><b>Over 20 days old</b></td><td width=100><b>In resolved state</b></td><td width=100><b>Not updated in past 10 days</b></td><td width=100><b>New in scope</b></td><td width=100><b>New in scope resolved</b></td><td width=100><b>Closed yesterday</b></td></tr>" >> $MAILFILE
#echo "<tr><td width=100>$DDATE</td><td width=100>$INCMORE20</td><td width=100>$INCRES20</td><td width=100>$INCOVER1020</td><td width=100>$INCNEWINSCOPE20</td><td width=100>$INCNEWINSCOPER20</td><td>$INCCLOSEDY20</td></tr>" >> $INCOUT
#uniq $INCOUT |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
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
cat $OPEN |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $10" - "$19"<br>" }' |sort|uniq -c |sort -rn >> $MAILFILE
#echo " " >> $MAILFILE
#printf "<br><span style='font-family:arial;text-align:left'><br><b>Open Incidents over 20 days old by queue owner
#</b><br><br>" >> $MAILFILE
#for i in `cat $OPEN |awk -F'",' '($21~"Incident")&&($4!~"Resolved") { print $23 }' |sort|uniq -c |sort -rn|sed 's/ "/ - /g' |sed 's/"//g' |head -15 |awk -F- '{ print $2 }'`; do echo " ";printf "<b>Owner: $i</b>";echo " ";head -1 $OPEN | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$23"</td></tr>" }';cat $OPEN | awk -F'","' '($21~"Incident")&&($4!~"Resolved") { print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$23"</td></tr>" }' |grep $i; echo "</table></span><br>";done >> $MAILFILE
unset IFS
#for i in `cat $OPEN |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $21 }' |sort|uniq -c |sort -rn |awk  '{ print $2 }'|sed 's/"//g'`; do echo " ";printf "<b>Owner: $i</b>";echo " ";head -1 $OPEN | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }';cat $OPEN | awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print "<tr><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>"}'|sed 's/"//g'| grep $i; echo "</table></span><br>";done >> $MAILFILE
#for OWNER in `cat $OPEN |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $21 }' |sort|uniq -c |sort -rn|sed 's/ "/ - /g' |sed 's/"//g'  |awk  '{ print $2 }'|grep -v patrick.bays`
#        do echo " ";printf "<b>Owner: $OWNER</b>";echo " ";head -1 $OPEN | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }'|tee /tmp/$OWNER.mail;cat $OPEN | awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print "<tr><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }'|sed 's/"//g' |grep $OWNER |tee -a /tmp/$OWNER.mail
#        echo "</table></span><br>" |tee -a /tmp/$OWNER.mail
#        mutt -e 'set content_type="text/html"' "$OWNER" -c "paul.ferguson@sungardas.com" -s "Good morning. Your team have Incidents over 20 days old" < /tmp/$OWNER.mail
#done
# Send emails
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "### TEST Daily Global Open Ticket Report ###" -a $RRDGRAPH  < $MAILFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,pushkar.shirolkar@sungardas.com,jan.clayton-adamson@sungardas.com,kevin.erickson@sungardas.com,paul.higgins@sungardas.com" -s "### Daily Global Open Ticket Report ###" -a $RRDGRAPH < $MAILFILE
#mv /tmp/*.mail /data/sn/archive
