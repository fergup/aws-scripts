#!/bin/bash
###################################################################################
#
# global_tickets.sh
# -----------------
# Takes input from Service Now reports and processes them for daily report to TOC
# management to track open Incidents, based on global_open.sh
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 15/01/16 |  PRF   | First edition
# ---------------------------------------------------------------------------------
# 
# Updates required:
# 1. Add 'Other' column to capture non-focus queue tickets
# 2. Highlight queues where >10% increase in tickets has occurre since previous day
###################################################################################
# Set variables
TIXDIR=/data/sn
OPEN=$TIXDIR/GlobalXOpenXIncidentsXPFXExport.csv
CLOSED=$TIXDIR/UKXClosedXYesterdayXINCXCHGXRITM.csv
RRDFILEGLOB=/data/rrd/sn_glob_all.rrd
RRDFILEQUEUE=/data/rrd/sn_glob_queues.rrd
RRDGLOBIMG=/data/images/global_tickets.png
RRDQUEUEIMG=/data/images/global_queues.png
RRDDATE=$(date +%m/%d/%Y" "%H:%M)
DATE=$(date +%Y-%m-%d" "%H:%M:%S)
DDATE=$(date +%d/%m/%Y)
IFS='"'
# Incidents
GLOB20=$(cat $OPEN|awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $0 }'|wc -l)
GLOB15=$(cat $OPEN|awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
GLOB10=$(cat $OPEN|awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>864000) { print $0 }'|wc -l)
GLOBCOMP=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($10~"compute|unix|window")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
GLOBNET=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($10~"net")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
GLOBSTOR=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($10~"stor")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
GLOBOTH=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($10!~"stor|net|compute|unix|window")&&($18~"Incident")&&($5!~"Resolved")&&($20>1296000) { print $0 }'|wc -l)
GLOBFS=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($18~"Incident")&&($5!~"Resolved")&&($20>1296000)&&($23~"true") { print $0 }'|wc -l)
GLOBNOFS=$(cat $OPEN|awk -F'","' 'BEGIN{IGNORECASE=1} ($18~"Incident")&&($5!~"Resolved")&&($20>1296000)&&($23!~"true") { print $0 }'|wc -l)
# RRD things
MAILFILE=/data/mail/glob_all_mail1
HTMLFILE=/data/mail/glob_all.html1
PDFFILE=/data/mail/glob_all.pdf
GLOBOUT=/data/mail/glob_all_out.html1
GLOBALL=/data/mail/glob_all_all.html1
GLOBTODAY=/data/mail/glob_all_today.html1
FOCUS_QUEUES=("TOC - Compute Tier 1" "NASH Security Services" "TOC - Backup Tier 1" "NARS R2C-SR-x86" "UK Vytalvault Pune" "NAMS DB SQL" "TOC - Network Tier 1" "UK Vaulting" "Enterprise Cloud Services" "OSS Tools" "UK DC Operations RESOLVED ONLY" "IE DUB SCC" "TOC - Network Tier 2" "TOC - Transport")
# RRD updates and graphs
#rrdtool update $RRDFILENEW "$RRDDATE@$INCMORE30:$INCMORE20:$INCMORE10:$INCIPDUMORE30:$INCIPDUMORE20:$INCIPDUMORE10"
rrdtool update $RRDFILE "$RRDDATE@$GLOB20:$GLOB15:$GLOB10:$GLOBCOMP:$GLOBNET:$GLOBSTOR:$GLOBOTH:$GLOBFS:$GLOBNOFS"
rrdtool graph $RRDGRAPH -a PNG '--title=All Open Incidents - GLOB' --vertical-label 'Number of Tickets' DEF:probe1=/data/rrd/sn_us.rrd:us20:AVERAGE DEF:probe2=/data/rrd/sn_us.rrd:us15:AVERAGE DEF:probe3=/data/rrd/sn_us.rrd:us10:AVERAGE 'AREA:probe3#FF0000:Over 10 days old' 'AREA:probe2#00FF00:Over 15 days old' 'AREA:probe1#0000FF:Over 20 days old' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-6w -e now+1d
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
td.dclass {
	margin-left: auto;
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
# GLOB table
printf "<span style='font-family:arial;text-align: center'><table border='1'><tr><td width="700" colspan="10" bgcolor="red"><b><font color="white">Incident Tickets</font></b></td></tr><tr><td width=100 rowspan="2" bgcolor="#DAEEF3" style="vertical-align:middle"><b>Date</b><td width=300 colspan="3" bgcolor="#00EEFF"><b>Over (x) days old</b></td><td width=400 colspan="4" bgcolor="#00EE22" style="vertical-align:middle"><b>Discipline (>15 days)<b></td><td width=200 colspan="2" bgcolor="yellow"><b>FS</td></tr>
<tr><td width=100 bgcolor="#79F5FF"><b>20</b></td><td width=100 bgcolor="#79F5FF"><b>15</b></td><td width=100 bgcolor="#79F5FF"><b>10</b></td><td width=100 bgcolor="#59FD61"><b>Compute</b></td><td width=100 bgcolor="#59FD61"><b>Network</b></td><td width=100 bgcolor="#59FD61"><b>Storage</b></td><td bgcolor="#59FD61"><b>Other</td><td bgcolor="#FFFF66" width=100><b>FS</td><td bgcolor="#FFFF66" width=100><b>Non-FS</td></tr>" >> $MAILFILE
# Insert variables into table
echo "<tr><td width=100>$DDATE</td><td width=100>$GLOB20</td><td width=100>$GLOB15</td><td width=100>$GLOB10</td><td width=100>$GLOBCOMP</td><td width=100>$GLOBNET</td><td width=100>$GLOBSTOR</td><td width=100>$GLOBOTH</td><td width=100>$GLOBFS</td><td width=100>$GLOBNOFS</td></tr>" >> $GLOBOUT
uniq $GLOBOUT |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
# Add total numbers for each queue in the fous list
echo "<br><b>Focus Queues - All Open Tickets</b>" >> $MAILFILE
printf "<br><span style='font-family:arial;text-align: center'><table border='1'><tr bgcolor="FF9933"><td><b>Date</b></td>" >> $MAILFILE
for QUEUE in ${FOCUS_QUEUES[@]}; do printf "<td width=100><b>$QUEUE</b></td>" >> $MAILFILE;done;printf "<td><b>Other</b></td></tr>" >> $MAILFILE
printf "<tr><td>$DDATE</td>" >> $GLOBALL
IFS=
for QUEUE in ${FOCUS_QUEUES[@]}; do awk -vcount=0 -vqueue="$QUEUE" -F'","' '($10~queue) {count++} END {printf "<td>"count"</td>"}' $OPEN ; done >> $GLOBALL
IFS=" "
FOCUSALL=0;for i in `grep $DDATE $GLOBALL |tail -1 |sed 's/<\/td><td>/ /g'|sed 's/<\/td><\/tr>//g'|sed 's/<\/td>//g' |cut -c 20-`; do FOCUSALL=$(($FOCUSALL+$i)); done
TIXALL=$(cat $OPEN|wc -l)
TIXLEFT=$(($TIXALL-$FOCUSALL))
printf "<td>$TIXLEFT</td></tr>
" >> $GLOBALL
IFS=
uniq $GLOBALL |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
# Add total numbers added in the past 24 hours for each queue in the focus list
echo "<br><b>Focus Queues - Tickets Opened Today</b>" >> $MAILFILE
printf "<br><span style='font-family:arial;text-align: center'><table border='1'><tr bgcolor="FF99CC"><td><b>Date</td>" >> $MAILFILE
for QUEUE in ${FOCUS_QUEUES[@]}; do printf "<td width=100><b>$QUEUE</b></td>" >> $MAILFILE;done;printf "<td><b>Other</b></td></tr>" >> $MAILFILE
printf "<tr><td>$DDATE</td>" >> $GLOBTODAY
today=$(date +%Y-%m-%d)   # Set up variables for today and yesterday to check for newly-created tickets
yesterday=$(date -d yesterday +%Y-%m-%d)
for QUEUE in ${FOCUS_QUEUES[@]}; do awk -vcount=0 -vtoday="$today" -vyesterday="$yesterday" -vqueue="$QUEUE"  -F'","'  '(($6~today)||($6~yesterday))&&($10~queue)  {count++} END {printf "<td>"count"</td>"}' $OPEN; done >> $GLOBTODAY
IFS=" "
FOCUSTODAY=0;for i in `grep $DDATE $GLOBTODAY |tail -1 |sed 's/<\/td><td>/ /g'|sed 's/<\/td><\/tr>//g'|sed 's/<\/td>//g' |cut -c 20-`; do FOCUSTODAY=$(($FOCUSTODAY+$i)); done
TIXTODAY=$(awk -vcount=0 -vtoday="$today" -vyesterday="$yesterday" -F'","' '(($6~today)||($6~yesterday)) { print }' $OPEN|wc -l)
TIXTODAYLEFT=$(($TIXTODAY-$FOCUSTODAY))
printf "<td>$TIXTODAYLEFT</td></tr>
" >> $GLOBTODAY
uniq $GLOBTODAY |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
# Create attachment for tickets > 30 days
printf "<br><b>Open Incidents older than 20 days by queue</b><br>" >> $MAILFILE
cat $OPEN |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $10" - "$19"<br>" }' |sort|uniq -c |sort -rn >> $MAILFILE
echo "</style></body></html>" >> $MAILFILE
unset IFS
# Create PDF
cp $MAILFILE $HTMLFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,pushkar.shirolkar@sungardas.com,jan.clayton-adamson@sungardas.com,kevin.erickson@sungardas.com,paul.higgins@sungardas.com,as.toc.network.management@sungardas.com,mark.hill@sungardas.com" -s "### Daily Global Open Ticket Report ###" -a $RRDGRAPH < $MAILFILE
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com"  -s "### TEST Daily Global Open Ticket Report ###" < $MAILFILE 
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,xande.craveiro-lopes@sungardas.com,jan.clayton-adamson@sungardas.com"  -s "### TEST Daily Global Open Ticket Report ###" < $MAILFILE 
#mv /tmp/*.mail /data/sn/archive
