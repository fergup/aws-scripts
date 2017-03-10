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
OPEN=$TIXDIR/UKXOpenXINCXCHGXRITM.csv
ALLEURTIX=$TIXDIR/EuropeanXOpenXIncidentsXPFXExport.csv
CLOSED=$TIXDIR/UKXClosedXYesterdayXINCXCHGXRITM.csv
RRDFILE=/data/rrd/uk_open20.rrd
RRDFILENEW=/data/rrd/uk_open_new2.rrd	# New RRD file for 10/20/30 day iterations
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
INCCLOSEDY20=$(cat $CLOSED|sed 's/"//g'|awk -F, '($15~"Incident")&&($19>1728000) { print $0 }'|wc -l)
INCRES20=$(cat $ALLEURTIX|sed 's/"//g'|awk -F, '($18~"Incident")&&($5~"Resolved")&&($20>1728000) { print $0 }'|wc -l)
INCMORE30=$(grep -iv ipdu $ALLEURTIX |sed 's/"//g' |awk -F, '($18~"Incident")&&($5!~"Resolved")&&($20>2592000) { print $6 }' |wc -l)
INCMORE20=$(grep -iv ipdu $ALLEURTIX |sed 's/"//g' |awk -F, '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $6 }' |wc -l)
INCMORE10=$(grep -iv ipdu $ALLEURTIX |sed 's/"//g' |awk -F, '($18~"Incident")&&($5!~"Resolved")&&($20>864000) { print $6 }' |wc -l)
INCMORE5=$(grep -iv ipdu $ALLEURTIX |sed 's/"//g' |awk -F, '($18~"Incident")&&($5!~"Resolved")&&($20>432000) { print $6 }' |wc -l)
INCIPDUMORE30=$(grep -i ipdu $ALLEURTIX |sed 's/"//g' |awk -F, '($18~"Incident")&&($5!~"Resolved")&&($20>2592000) { print $6 }' |wc -l)
INCIPDUMORE20=$(grep -i ipdu $ALLEURTIX |sed 's/"//g' |awk -F, '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $6 }' |wc -l)
INCIPDUMORE10=$(grep -i ipdu $ALLEURTIX |sed 's/"//g' |awk -F, '($18~"Incident")&&($5!~"Resolved")&&($20>864000) { print $6 }' |wc -l)
INCIPDUMORE5=$(grep -i ipdu $ALLEURTIX |sed 's/"//g' |awk -F, '($18~"Incident")&&($5!~"Resolved")&&($20>432000) { print $6 }' |wc -l)
# RRD things
RRDGRAPHALL=/data/images/uk_open_all.png
RRDGRAPHINC=/data/images/uk_open_inc.png
RRDGRAPHINCNEW=/data/images/uk_open_inc_non_ipdu.png
RRDGRAPHINCIPDU=/data/images/uk_open_inc_ipdu.png
MAILFILE=/data/mail/uk_open_mail
HTMLFILE=/data/mail/uk_open.html
PDFFILE=/data/mail/uk_open.pdf
PHTIX=/data/mail/uk_open_tickets.txt
INCOUT=/data/mail/open-inc-twentya.html
INCOUTNEW=/data/mail/open-inc-twentyb.html
# RRD updates and graphs
rrdtool update $RRDFILENEW "$RRDDATE@$INCMORE30:$INCMORE20:$INCMORE10:$INCIPDUMORE30:$INCIPDUMORE20:$INCIPDUMORE10"
rrdtool update $RRDFILE "$RRDDATE@$INCMORE20:$INCRES20:$INCOVER1020:$INCNEWINSCOPE20:$INCNEWINSCOPER20:$INCCLOSEDY20"
#echo $RRDFILE "$RRDDATE@$INCALL:$INCRES:$INCOVER10:$INCNEWINSCOPE:$INCNEWINSCOPER:$INCCLOSEDY:$REQALL:$REQRES:$REQOVER10:$REQNEWINSCOPE:$REQNEWINSCOPER:$REQCLOSEDY:$CHGALL:$CHGRES:$CHGOVER10:$CHGNEWINSCOPE:$CHGNEWINSCOPER:$CHGCLOSEDY"
rrdtool graph $RRDGRAPHINC -a PNG --title="All Open Incidents - Europe (over 20 days old)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/uk_open20.rrd:over20:AVERAGE' 'DEF:probe2=/data/rrd/uk_open20.rrd:resolved:AVERAGE' 'DEF:probe3=/data/rrd/uk_open20.rrd:notupdted:AVERAGE' 'DEF:probe4=/data/rrd/uk_open20.rrd:newinscope:AVERAGE' 'DEF:probe5=/data/rrd/uk_open20.rrd:newinscoper:AVERAGE' 'DEF:probe6=/data/rrd/uk_open20.rrd:closedy:AVERAGE' 'AREA:probe1#FF0000:All Open Tickets:STACK' 'AREA:probe2#00FF00:Resolved:STACK' 'AREA:probe3#0000FF:Not Updated in Ten Days:STACK' 'AREA:probe4#000000:New In Scope:STACK' 'AREA:probe5#FFFF00:New In Scope (Resolved):STACK' 'AREA:probe6#48C4EC:Closed Yesterday:STACK' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-1w -e now+1d
rrdtool graph $RRDGRAPHINCNEW -a PNG --title="Open Incidents - Europe (non-IPDU)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/uk_open_new2.rrd:thirty-nipdu:AVERAGE' 'DEF:probe2=/data/rrd/uk_open_new2.rrd:twenty-nipdu:AVERAGE' 'DEF:probe3=/data/rrd/uk_open_new2.rrd:ten-nipdu:AVERAGE'  'AREA:probe3#FF0000:Over 10 Days Old' 'AREA:probe2#00FF00:Over Twenty Days Old' 'AREA:probe1#0000FF:Over 30 Days Old' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-2w -e now+1d
rrdtool graph $RRDGRAPHINCIPDU -a PNG --title="Open Incidents - Europe (IPDU)" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/uk_open_new2.rrd:thirty-ipdu:AVERAGE' 'DEF:probe2=/data/rrd/uk_open_new2.rrd:twenty-ipdu:AVERAGE' 'DEF:probe3=/data/rrd/uk_open_new2.rrd:ten-ipdu:AVERAGE'  'AREA:probe3#FF0000:Over 10 Days Old' 'AREA:probe2#00FF00:Over Twenty Days Old' 'AREA:probe1#0000FF:Over 30 Days Old' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-2w -e now+1d
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
printf "<span style='font-family:arial;text-align: center'><table border='1'><tr><td width="900" colspan="9" bgcolor="FF9999"><b>Incidents - 30/20/10 days old</b></td></tr><tr><td width=100 rowspan="2" bgcolor="FFBBBB"><b>Date</b><td width=300 colspan="4" bgcolor="66CCFF"><b>Non-IPDU related</b></td><td width=300 colspan="4" bgcolor="33CC33"><b>IPDU related<b></td><tr><td width=100 bgcolor="00EEFF"><b>Over 30 days old</b></td><td width=100 bgcolor="00EEFF"><b>Over 20 days old</b></td><td width=100 bgcolor="00EEFF"><b>Over 10 days old</b></td><td width=100 bgcolor="00EEFF"><b>Over 5 days old</b></td><td width=100 bgcolor="00EE22"><b>Over 30 days old</b></td><td width=100 bgcolor="00EE22"><b>Over 20 days old</b></td><td width=100 bgcolor="00EE22"><b>Over 10 days old</b></td><td width=100 bgcolor="00EE22"><b>Over 5 days old</b></td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=100>$INCMORE30</td><td width=100>$INCMORE20</td><td width=100>$INCMORE10</td><td width=100>$INCMORE5</td><td width=100>$INCIPDUMORE30</td><td width=100>$INCIPDUMORE20</td><td width=100>$INCIPDUMORE10</td><td width=100>$INCIPDUMORE5</td></tr>" >> $INCOUTNEW
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
cat $ALLEURTIX |sed 's/"//g'|awk -F, '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $10" - "$19"<br>" }' |sort|uniq -c |sort -rn >> $MAILFILE
echo " " >> $MAILFILE
printf "<br><span style='font-family:arial;text-align:left'><br><b>Open Incidents over 20 days old by queue owner
</b><br><br>" >> $MAILFILE
#for i in `cat $OPEN |awk -F'",' '($21~"Incident")&&($4!~"Resolved") { print $23 }' |sort|uniq -c |sort -rn|sed 's/ "/ - /g' |sed 's/"//g' |head -15 |awk -F- '{ print $2 }'`; do echo " ";printf "<b>Owner: $i</b>";echo " ";head -1 $OPEN | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$23"</td></tr>" }';cat $OPEN | awk -F'","' '($21~"Incident")&&($4!~"Resolved") { print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$23"</td></tr>" }' |grep $i; echo "</table></span><br>";done >> $MAILFILE
unset IFS
for i in `cat $ALLEURTIX |sed 's/"//g'|awk -F, '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $21 }' |sort|uniq -c |sort -rn |awk  '{ print $2 }'`; do echo " ";printf "<b>Owner: $i</b>";echo " ";head -1 $ALLEURTIX | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }';cat $ALLEURTIX |sed 's/"//g'| awk -F, '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print "<tr><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>"}'|grep $i; echo "</table></span><br>";done >> $MAILFILE
for OWNER in `cat $ALLEURTIX |sed 's/"//g'|awk -F, '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print $21 }' |sort|uniq -c |sort -rn|sed 's/ "/ - /g' |sed 's/"//g'  |awk  '{ print $2 }'|grep -v patrick.bays`
        do echo " ";printf "<b>Owner: $OWNER</b>";echo " ";head -1 $ALLEURTIX | awk -F'","' '{ print "<table border='1'><tr bgcolor="999999"><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }'|tee /tmp/$OWNER.mail;cat $ALLEURTIX | awk -F'","' '($18~"Incident")&&($5!~"Resolved")&&($20>1728000) { print "<tr><td>"$1"</td><td>"$10"</td><td>"$11"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$21"</td></tr>" }'|grep $OWNER |tee -a /tmp/$OWNER.mail
        echo "</table></span><br>" |tee -a /tmp/$OWNER.mail
#        mutt -e 'set content_type="text/html"' "$OWNER" -c "paul.ferguson@sungardas.com" -s "Good morning. Your team have Incidents over 20 days old" < /tmp/$OWNER.mail
done
# Send emails
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "NEW Daily UK Open Ticket Report"  -a $RRDGRAPHINCNEW -a $RRDGRAPHINC -a $RRDGRAPHINCIPDU -a $PDFFILE < $MAILFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,paul.higgins@sungardas.com,stephen.carroll@sungardas.com,ryan.bell@sungardas.com,paul.labbett@sungardas.com,alistair.richardson@sungardas.com,chris.nicholson@sungardas.com,simon.wagstaff@sungardas.com,richard.williams@sungardas.com,jonathan.montgomery@sungardas.com,malcolm.rhodes@sungardas.com,david.wilcock@sungardas.com,hanish.nair@sungardas.com,nigel.harris@sungardas.com,sanjay.d.deshpande@sungardas.com,pushkar.shirolkar@sungardas.com,nikhil.kulkarni@sungardas.com,richard.monks@sungardas.com,daniel.clarke@sungardas.com,phil.duncan@sungardas.com" -s "Daily UK Open Ticket Report" -a $RRDGRAPHINCNEW -a $RRDGRAPHINC -a $RRDGRAPHINCIPDU -a $PDFFILE < $MAILFILE
# Email indivduals chasing open tickets
#cp ~/.muttrc-ph ~/.muttrc
#for OWNER in `cat $OPEN |grep ryan.bell|awk -F'",' '($21~"Incident")&&($4!~"Resolved") { print $23 }' |sort|uniq -c |sort -rn|sed 's/ "/ - /g' |sed 's/"//g' |awk -F- '{ print $2 }'`
#	do # echo " ";printf "<b>Owner: $OWNER</b>";echo " "
#	NAME=$(grep $OWNER $OPEN |awk -F'","' '{ print $13 }' |awk '{ print $1 }'|uniq)
#	TICKET=tickets
#	ARE=are
#	NUMBER=$(cat $OPEN |awk -F'",' '($21~"Incident")&&($4!~"Resolved") { print $23 }'|grep -c $OWNER)
#	[[ $NUMBER == 1 ]] && NUMBER=a && TICKET=ticket && ARE=is
#	printf "Dear $NAME,<br>
#I understand you have $NUMBER Service Now Incident $TICKET assigned to a group you manage which $ARE over 30 days old. <br>
#As you may be aware, we're currently attempting to reduce the volume of old tickets in the system so I would appreciate your assistance in getting your tickets and those assigned to your teams resolved or, where necessary, translated to a more suitable ticket type (e.g. Request, Change or Problem). The ticket details are below.<br> 
#Thanks for your help in this matter.<br>
#Regards,<br>
#Paul<br><br>
#" | tee /tmp/$OWNER.mail
##	head -1 $OPEN | awk -F'","' '{ print "<table border='1'><tr bgcolor="006699"><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$23"</td></tr>" }'|sed 's/"//g'|tee -a /tmp/$OWNER.mail;cat $OPEN | awk -F'","' '($21~"Incident")&&($4!~"Resolved") { print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$23"</td></tr>" }'|sed 's/"//g'|grep $OWNER |tee -a /tmp/$OWNER.mail
#	echo "</table></span><br>" |tee -a /tmp/$OWNER.mail
#	mutt -e 'set content_type="text/html"' "$OWNER" -b "paul.higgins@sungardas.com,paul.ferguson@sungardas.com" -s "Incident tickets over 30 days old" < /tmp/$OWNER.mail
#done
#cp ~/.muttrc-sav ~/.muttrc
# Tidy up
mv /tmp/*.mail /data/sn/archive
