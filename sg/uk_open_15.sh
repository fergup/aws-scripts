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
# |   1.3   | 24/07/15 |  PRF   | With new calculations for >15 day tickets
# |   1.4   | 27/09/15 |  PRF   | Now emails individuals with chaser mails
# |   1.5   | 04/10/15 |  PRF   | Changed to 14-day reporting
# |   1.6   | 14/10/15 |  PRF   | Removed 14-day tables, added European break-down
# |   1.7   | 07/02/16 |  PRF   | Added Serco, Menzies, etc
# ---------------------------------------------------------------------------------
#
###################################################################################
# Set variables
TIXDIR=/data/sn
OPEN=$TIXDIR/UKXOpenXINCXCHGXRITM.csv
ALLEURTIX=$TIXDIR/EuropeanXOpenXIncidentsXPFXExport.csv
CLOSED=$TIXDIR/UKXClosedXYesterdayXINCXCHGXRITM.csv
RRDFILE=/data/rrd/uk_strat.rrd
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
INCMORE15=$(grep -iv ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600) { print $6 }' |wc -l)
INCMORE30=$(grep -iv ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000) { print $6 }' |wc -l)
INCMORE7=$(grep -iv ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800) { print $6 }' |wc -l)
INCIPDUMORE15=$(grep -i ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600) { print $6 }' |wc -l)
INCIPDUMORE30=$(grep -i ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000) { print $6 }' |wc -l)
INCIPDUMORE7=$(grep -i ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800) { print $6 }' |wc -l)
INCCUSTMORE15=$(awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($22~"Customer")&&($20>1209600) { print $6 }' $ALLEURTIX |wc -l)
UK15=$(grep -iv ipdu $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($10!~/FR |IE |SE /) { print $6 }' |wc -l)
IE15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($10~"IE ") { print $6 }' |wc -l)
SE15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($10~"SE ") { print $6 }' |wc -l)
FR15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($10~"FR ") { print $6 }' |wc -l)
MNZ15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($12~"Menzies") { print $6 }' |wc -l)
SERCO15=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&($12~"Serco") { print $6 }' |wc -l)
UK7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($10!~/FR |IE |SE /) { print $6 }' |wc -l)
IE7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($10~"IE ") { print $6 }' |wc -l)
SE7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($10~"SE ") { print $6 }' |wc -l)
FR7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($10~"FR ") { print $6 }' |wc -l)
MNZ7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($12~"Menzies") { print $6 }' |wc -l)
SERCO7=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>604800)&&($12~"Serco") { print $6 }' |wc -l)
UK30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000)&&($10!~/FR |IE |SE /) { print $6 }' |wc -l)
IE30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000)&&($10~"IE ") { print $6 }' |wc -l)
SE30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000)&&($10~"SE ") { print $6 }' |wc -l)
FR30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000)&&($10~"FR ") { print $6 }' |wc -l)
MNZ30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000)&&($12~"Menzies") { print $6 }' |wc -l)
SERCO30=$(cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>2592000)&&($12~"Serco") { print $6 }' |wc -l)
# RRD things
RRDGRAPHINC=/data/images/uk_strat.png
MAILFILE=/data/mail/uk_open_mail_new
HTMLFILE=/data/mail/uk_open.html
PDFFILE=/data/mail/uk_open.pdf
PHTIX=/data/mail/uk_open_tickets.txt
INCOUT=/data/mail/open-inc-fifteena_new.html
INCOUT7=/data/mail/open-inc-fifteena_new7.html
INCOUT30=/data/mail/open-inc-fifteena_new30.html
INCOUTNEW=/data/mail/open-inc-fifteenb_new.html
LTCTLS="samuel.stewart@sungardas.com,david.sims@sungardas.com,gurdeep.chana@sungardas.com,william.ako@sungardas.com"
TC2TLS="steven.errington@sungardas.com,neil.longhurst@sungardas.com"
#
# RRD updates and graphs
#
rrdtool update $RRDFILE "$RRDDATE@$UK7:$UK15:$UK30:$IE7:$IE15:$IE30:$SE7:$SE15:$SE30:$FR7:$FR15:$FR30:$SERCO7:$SERCO15:$SERCO30:$MNZ7:$MNZ15:$MNZ30"
rrdtool graph $RRDGRAPHINC -a PNG --title="Open Incidents over 14 days old - EMEA Dedicated Accounts" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/uk_strat.rrd:ie14:AVERAGE' 'DEF:probe2=/data/rrd/uk_strat.rrd:se14:AVERAGE' 'DEF:probe3=/data/rrd/uk_strat.rrd:serco14:AVERAGE' 'DEF:probe4=/data/rrd/uk_strat.rrd:mnz14:AVERAGE' 'LINE2:probe1#FF0000:Ireland' 'LINE2:probe2#00FF00:Sweden' 'LINE2:probe3#0000FF:Serco' 'LINE2:probe4#000000:Menzies' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-1w -e now
#
# Create mail file
#
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
#
# Create top table of Incidents over x days old
#
printf "<span style='font-family:arial;text-align: center'><table border='1'><tr><td width="700" colspan="8" bgcolor="FF6699"><b>Incidents - 30/14/7 days old</b></td></tr><tr><td width=100 rowspan="2" bgcolor="FFBBBB"><b>Date</b><td width=20 colspan="3" bgcolor="66CCFF"><b>Non-IPDU related</b></td><td width=100 colspan="1" rowspan="2" bgcolor="FABF8F"><b>Over 14 Days Pending Customer</b><td width=300 colspan="3" bgcolor="33CC33"><b>IPDU related<b></td></tr><tr><td width=100 bgcolor="00EEFF"><b>Over 30 days old</b></td><td width=100 bgcolor="00EEFF"><b>Over 14 days old</b></td><td width=100 bgcolor="00EEFF"><b>Over 7 days old</b></td><td width=100 bgcolor="00EE22"><b>Over 30 days old</b></td><td width=100 bgcolor="00EE22"><b>Over 14 days old</b></td><td width=100 bgcolor="00EE22"><b>Over 7 days old</b></td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=100>$INCMORE30</td><td width=100>$INCMORE15</td><td width=100>$INCMORE7</td><td width=100>$INCCUSTMORE15</td><td width=100>$INCIPDUMORE30</td><td width=100>$INCIPDUMORE15</td><td width=100>$INCIPDUMORE7</td></tr>" >> $INCOUTNEW
uniq $INCOUTNEW |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
#
# Create per-area table for email
#
printf "<br><span style='font-family:arial;text-align: center'><table border='1'><tr><td width=100 colspan="7" bgcolor="FF9999"><b>Incidents over 7 days old - per-area view</b></td></tr><tr bgcolor="FFBBBB"><td width=100><b>Date</b></td><td width=100 bgcolor="8DB3E2"><b>UK</b></td><td width=100 bgcolor="92D050"><b>Ireland</b></td><td width=100 bgcolor="Blue"><b>France</b></td><td width=100 bgcolor="E5B8B7"><b>Sweden</b></td><td width=100 bgcolor="FFFFCC"><b>Menzies</b></td><td width=100 bgcolor="FFFFCC"><b>Serco</b></td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=100>$UK7</td><td width=100>$IE7</td><td width=100>$FR7</td><td width=100>$SE7</td><td width=100>$MNZ7</td><td width=100>$SERCO7</td></tr>" >> $INCOUT7
uniq $INCOUT7 |tail -3| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
#
# Create per-area table for email
#
printf "<br><span style='font-family:arial;text-align: center'><table border='1'><tr><td width=100 colspan="7" bgcolor="FFCC99"><b>Incidents over 14 days old - per-area view</b></td></tr><tr bgcolor="FFBBBB"><td width=100><b>Date</b></td><td width=100 bgcolor="8DB3E2"><b>UK</b></td><td width=100 bgcolor="92D050"><b>Ireland</b></td><td width=100 bgcolor="Blue"><b>France</b></td><td width=100 bgcolor="E5B8B7"><b>Sweden</b></td><td width=100 bgcolor="FFFFCC"><b>Menzies</b></td><td width=100 bgcolor="FFFFCC"><b>Serco</b></td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=100>$UK15</td><td width=100>$IE15</td><td width=100>$FR15</td><td width=100>$SE15</td><td width=100>$MNZ15</td><td width=100>$SERCO15</td></tr>" >> $INCOUT
uniq $INCOUT |tail -3| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
#
# Create per-area table for email
#
printf "<br><span style='font-family:arial;text-align: center'><table border='1'><tr><td width=100 colspan="7" bgcolor="FFFF99"><b>Incidents over 30 days old - per-area view</b></td></tr><tr bgcolor="FFBBBB"><td width=100><b>Date</b></td><td width=100 bgcolor="8DB3E2"><b>UK</b></td><td width=100 bgcolor="92D050"><b>Ireland</b></td><td width=100 bgcolor="Blue"><b>France</b></td><td width=100 bgcolor="E5B8B7"><b>Sweden</b></td><td width=100 bgcolor="FFFFCC"><b>Menzies</b></td><td width=100 bgcolor="FFFFCC"><b>Serco</b></td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=100>$UK30</td><td width=100>$IE30</td><td width=100>$FR30</td><td width=100>$SE30</td><td width=100>$MNZ30</td><td width=100>$SERCO30</td></tr>" >> $INCOUT30
uniq $INCOUT30 |tail -3| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
#
# Create list of open tickets for Strategic Accounts
#
printf "<br><b>Open Strategic Accounts Incidents older than 14 days by queue</b><br>" >> $MAILFILE
cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&(($10~/[IE ][SE ][FR ]/)||($12~"Serco"||$12~"Menzies")) { print $10" - "$19"<br>" }' |sort|uniq -c |sort -rn >> $MAILFILE
echo "<br>" >> $MAILFILE
unset IFS
#
# Create individual emails to assignment group owners and ticket assignees, starting with the Strategic Accounts ones
#
for i in `cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&(($10~/[IE ][SE ][FR ]/)||($12~"Serco"||$12~"Menzies")) { print $21 }' |sort|uniq -c |sort -rn |awk  '{ print $2 }'|sed 's/"//g'`; do echo " ";printf "<b>Owner: $i</b>";echo " ";head -1 $ALLEURTIX | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }';cat $ALLEURTIX | awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600)&&(($10~/[IE ][SE ][FR ]/)||($12~"Serco"||$12~"Menzies")) { print "<tr><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>"}'|sed 's/"//g'| grep $i; echo "</table></span><br>";done >> $MAILFILE
# Regular tickets
printf "<br><b>Open UK Incidents older than 14 days by queue</b><br>" >> $MAILFILE
cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600) { print $10" - "$19"<br>" }' |sort|uniq -c |sort -rn >> $MAILFILE
echo " " >> $MAILFILE
printf "<br><span style='font-family:arial;text-align:left'><b>Open Incidents over 14 days old by queue owner
</b><br><br>" >> $MAILFILE
unset IFS
# Create tables ot tickets
for i in `cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600) { print $21 }' |sort|uniq -c |sort -rn |awk  '{ print $2 }'|sed 's/"//g'`; do echo " ";printf "<b>Owner: $i</b>";echo " ";head -1 $ALLEURTIX | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }';cat $ALLEURTIX | awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600) { print "<tr><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>"}'|sed 's/"//g'| grep $i; echo "</table></span><br>";done >> $MAILFILE
for OWNER in `cat $ALLEURTIX |awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600) { print $21 }' |sort|uniq -c |sort -rn|sed 's/ "/ - /g' |sed 's/"//g'  |awk  '{ print $2 }'|grep -v "patrick.bays"`
        do echo " ";printf "<b>Owner: $OWNER</b>";echo " ";head -1 $ALLEURTIX | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }'|tee /tmp/$OWNER.mail15;cat $ALLEURTIX | awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1209600) { print "<tr><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }'|sed 's/"//g' |grep $OWNER |tee -a /tmp/$OWNER.mail15
        echo "</table></span><br>" |tee -a /tmp/$OWNER.mail15
	STAFF=$(awk -F'","' '($21~"'''$OWNER'''")&&($18~"Incident")&&($5!~"Resolved")&&($20>1209600) { if (!seen[$23]++) printf $23"," }' $ALLEURTIX|sed 's/"//g')
	OTHERS=$STAFF
	[[ $OWNER = ryan.bell@sungardas.com ]] && OTHERS="$STAFF,$LTCTLS,"
	[[ $OWNER = keith.murphy@sungardas.com ]] && OTHERS="$STAFF,$TC2TLS,"
	[[ $OWNER = deepanjanb@microland.com ]] && OTHERS="$STAFF,DheeraneH@microland.com,NagarajaKG@microland.com,"
        mutt -e 'set content_type="text/html"' "${OTHERS}${OWNER}" -c "paul.ferguson@sungardas.com" -s "Good morning. Your team have Incidents over 14 days old" < /tmp/$OWNER.mail15
done
#
# Send emails
#
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,paul.higgins@sungardas.com,stephen.carroll@sungardas.com,ryan.bell@sungardas.com,paul.labbett@sungardas.com,alistair.richardson@sungardas.com,chris.nicholson@sungardas.com,simon.wagstaff@sungardas.com,richard.williams@sungardas.com,jonathan.montgomery@sungardas.com,malcolm.rhodes@sungardas.com,david.wilcock@sungardas.com,hanish.nair@sungardas.com,nigel.harris@sungardas.com,sanjay.d.deshpande@sungardas.com,pushkar.shirolkar@sungardas.com,nikhil.kulkarni@sungardas.com,richard.monks@sungardas.com,daniel.clarke@sungardas.com,phil.duncan@sungardas.com,david.mcgowan@sungardas.com,as.ie.servicedesk@sungardas.com,julian.peter@sungardas.com,omc.duty.managers@microland.com,jan.clayton-adamson@sungardas.com,mark.hill@sungardas.com,grant.tobin@sungardas.com,robert.jones@sungardas.com,gurdeep.chana@sungardas.com,ann.wingard@sungardas.com" -s "Daily EMEA Open Ticket Report"  < $MAILFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "### CHANGE Daily EMEA Open Ticket Report ###"  -a $RRDGRAPHINC < $MAILFILE
# Tidy up
#
mv /tmp/*.mail15 /data/sn/archive
