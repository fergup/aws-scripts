#!/bin/bash
###################################################################################
#
# menzies_report2.sh
# -----------------
# Updated daily report for Menzies
# 
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 13/01/16 |  PRF   | First edition
# ---------------------------------------------------------------------------------
#
###################################################################################
# Set variables
DATE=$(date +%d%m%Y)
TIXDIR=/data/menzies
SCFILE=/data/sc-sasu-all.txt
HPSA=/data/hpsa_servers.csv
ZENOSS=$(ls -atr /data/uk-zenoss* |tail -1)
OPEN=$TIXDIR/menzies-heat-$DATE.csv
RRDSERV=/data/rrd/mz_serv.rrd
RRDCOUNT=/data/rrd/mz_count.rrd
RRDSERVIMG=/data/images/mz_serv.png
RRDCOUNTIMG=/data/images/mz_count.png
RRDDATE=$(date +%m/%d/%Y" "%H:%M)
DATE=$(date +%Y-%m-%d" "%H:%M:%S)
DDATE=$(date +%d/%m/%Y)
IFS='"'
datediff() {
     d1=$(date -d "$1" +%s)
     d2=$(date -d "$2" +%s)
     echo $(( (d1 - d2) / 86400 )) days
}
# Services
SVDATA=$(awk -F, '($6~"Data") { print $6 }' $OPEN |wc -l)
SVDESKTOP=$(awk -F, '($6~"Desktop") { print $6 }' $OPEN |wc -l)
SVFREIGHT=$(awk -F, '($6~"Freight") { print $6 }' $OPEN|wc -l)
SVNET=$(awk -F, '($6~"Network") { print $6 }' $OPEN|wc -l)
SVSVR=$(awk -F, '($6~"Server") { print $6 }' $OPEN|wc -l)
SVWEB=$(awk -F, '($6~"Website") { print $6 }' $OPEN|wc -l)
SVOTHER=$(awk -F, '($6!~"Data")&&($6!~"Dekstop")&&($6!~"Freight")&&($6!~"Network")&&($6!~"Server")&&($6!~"Website") { print }' $OPEN|wc -l)
# Countries
COUK=$(awk -F, '($15~"United Kingdom") { print }' $OPEN|wc -l)
COUS=$(awk -F, '($15~"United States") { print }' $OPEN|wc -l)
COAUS=$(awk -F, '($15~"Australia") { print }' $OPEN|wc -l)
COIND=$(awk -F, '($15~"India") { print }' $OPEN|wc -l)
COSA=$(awk -F, '($15~"South Africa") { print }' $OPEN|wc -l)
COOTH=$(awk -F, '($15!~"United Kingdom")&&($15!~"United States")&&($15!~"Australis")&&($15!~"India")&&($15!~"South Africa") { print }' $OPEN|wc -l)
STATACT=$(awk -F, '($2~"Active") { print }' $OPEN|wc -l)
STATRES=$(awk -F, '($2~"Resolved") { print }' $OPEN|wc -l)
STATW3RD=$(awk -F, '($2~"Waiting for 3rd Party") { print }' $OPEN|wc -l)
STATWCUS=$(awk -F, '($2~"Waiting for Customer") { print }' $OPEN|wc -l)
STATWRES=$(awk -F, '($2~"Waiting for Resolution") { print }' $OPEN|wc -l)
# Type of Incident
TYPEFAIL=
TYPEREQ

# Service Center
SCSERVERS=$(awk -F'\t' '($21~"server")&&($9~"MENZIES") { print $0 }' $SCFILE|wc -l)
SCNETWORK=$(awk -F'\t' '($21~"router|switch|firewall|loadbalancer")&&($9~"MENZIES") { print $0 }' $SCFILE|wc -l)
SCSTORAGE=$(awk -F'\t' '($21~"sanarray|sanswitch")&&($9~"MENZIES") { print $0 }' $SCFILE|wc -l)
SCOTHER=$(awk -F'\t' '($21!~"router|switch|firewall|loadbalancer|server|sanswitch|sanarray")&&($9~"MENZIES") { print $0 }' $SCFILE|wc -l)
# Zenoss
ZNSERVERS=$(awk -F, '($14~"MENZ")&&($17~"Server") { print }' $ZENOSS |wc -l)
ZNNETWORK=$(awk -F, '($14~"MENZ")&&($17~"Network") { print }' $ZENOSS |wc -l)
ZNSTORAGE=$(awk -F, '($14~"MENZ")&&($17~"Storage") { print }' $ZENOSS |wc -l)
ZNOTHER=$(awk -F, '($14~"MENZ")&&($17!~"Server|Network|Storage") { print }' $ZENOSS |wc -l)
# HPSA
HPSASVR=$(awk -F, '($4~"Menz") { print  }' $HPSA|wc -l)
# RRD things
MAILFILE=/data/mail/mz_open_mail
MZOUT=/data/mail/mz_out
ALLOUT=/data/mail/mz_all_out
# RRD updates and graphs
#rrdtool update $RRDFILENEW "$RRDDATE@$INCMORE30:$INCMORE20:$INCMORE10:$INCIPDUMORE30:$INCIPDUMORE20:$INCIPDUMORE10"
rrdtool update $RRDSERV "$RRDDATE@$SVDATA:$SVDESKTOP:$SVFREIGHT:$SVNET:$SVSVR:$SVWEB:$SVOTHER"
rrdtool update $RRDCOUNT "$RRDDATE@$COUK:$COUS:$COAUS:$COIND:$COSA:$COOTH"
rrdtool graph $RRDSERVIMG -a PNG '--title=Aviation Heat Tickets - Services Affected' --vertical-label 'Number of Tickets' DEF:probe1=/data/rrd/mz_serv.rrd:data:AVERAGE DEF:probe2=/data/rrd/mz_serv.rrd:desktop:AVERAGE DEF:probe3=/data/rrd/mz_serv.rrd:freight:AVERAGE DEF:probe4=/data/rrd/mz_serv.rrd:network:AVERAGE DEF:probe5=/data/rrd/mz_serv.rrd:server:AVERAGE DEF:probe6=/data/rrd/mz_serv.rrd:website:AVERAGE DEF:probe7=/data/rrd/mz_serv.rrd:other:AVERAGE 'LINE2:probe1#FF0000:Data Service' 'LINE2:probe2#00FF00:Desktops' 'LINE2:probe3#FF3300:Freight Forwarding'  'LINE2:probe4#FFFF00:Network Services'  'LINE2:probe5#0000FF:Servers'  'LINE2:probe6#000000:Websites'  'LINE2:probe7#FF0099:Other Services' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-1w -e now+1d
rrdtool graph $RRDCOUNTIMG -a PNG '--title=Aviation Heat Tickets - Countries Affected' --vertical-label 'Number of Tickets' DEF:probe1=/data/rrd/mz_count.rrd:uk:AVERAGE DEF:probe2=/data/rrd/mz_count.rrd:us:AVERAGE DEF:probe3=/data/rrd/mz_count.rrd:aus:AVERAGE DEF:probe4=/data/rrd/mz_count.rrd:ind:AVERAGE DEF:probe5=/data/rrd/mz_count.rrd:sa:AVERAGE DEF:probe6=/data/rrd/mz_count.rrd:other:AVERAGE 'LINE2:probe1#00FF00:UK' 'LINE2:probe2#0000FF:US'  'LINE2:probe3#FF3300:Australia'  'LINE2:probe4#9900CC:India'  'LINE2:probe5#FFFF00:South Africa'  'LINE2:probe6#000000:Other' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-1w -e now+1d
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
# Aviation table
aviation() {
printf "<br><br><span style='font-family:arial;text-align: center'><table border='1'><tr><td width="700" colspan="14" bgcolor="red"><b><font color="white">Aviation Heat Tickets</font></b></td></tr><tr><td width=100 rowspan="2" bgcolor="#DAEEF3" style="vertical-align:middle"><b>Date</b><td width=560 colspan="7" bgcolor="#00EEFF"><b>Service Affected</b></td><td width=480 colspan="6" bgcolor="#00EE22" style="vertical-align:middle"><b>Country Affected<b></td></tr>
<tr><td width=80 bgcolor="#79F5FF"><b>Data</b></td><td width=80 bgcolor="#79F5FF"><b>Desktop</b></td><td width=80 bgcolor="#79F5FF"><b>Freight</b></td><td width=80 bgcolor="#79F5FF"><b>Network</b></td><td width=80 bgcolor="#79F5FF"><b>Server</b></td><td width=80 bgcolor="#79F5FF"><b>Website</b></td><td width=80 bgcolor="#79F5FF"><b>Other</b></td><td width=80 bgcolor="#59FD61"><b>UK</b></td><td width=80 bgcolor="#59FD61"><b>US</b></td><td width=80 bgcolor="#59FD61"><b>Australia</b></td><td bgcolor="#59FD61"><b>India</td><td bgcolor="#59FD61"><b>South Africa</td><td bgcolor="#59FD61"><b>Other</td></tr>" >> $MAILFILE
# Insert variables into table
echo "<tr><td width=100>$DDATE</td><td width=80>$SVDATA</td><td width=80>$SVDESKTOP</td><td width=80>$SVFREIGHT</td><td width=80>$SVNET</td><td width=80>$SVSVR</td><td width=80>$SVWEB</td><td width=80>$SVOTHER</td><td width=80>$COUK</td><td width=80>$COUS</td><td width=80>$COAUS</td><td width=80>$COIND</td><td width=80>$COSA</td><td width=80>$COOTH</td></tr>" >> $MZOUT
uniq $MZOUT |tail -5| tac >> $MAILFILE;printf "</span></table><br>" >> $MAILFILE
}
# General numbers
all() {
printf "<span style='font-family:arial;text-align: center'><table border='1'><tr><td width="700" colspan="10" bgcolor="#4F81BD"><b><font color="#FFFF66">Menzies Devices - All Tools</font></b></td></tr><tr><td width=100 rowspan="2" bgcolor="#DAEEF3" style="vertical-align:middle"><b>Date</b><td width=320 colspan="4" bgcolor="#00EEFF"><b>Service Center</b></td><td width=320 colspan="4" bgcolor="#00EE22" style="vertical-align:middle"><b>Zenoss<b></td><td width=100 colspan="1" bgcolor="yellow"><b>HPSA</td></tr>
<tr><td width=80 bgcolor="#79F5FF"><b>Servers</b></td><td width=80 bgcolor="#79F5FF"><b>Networking</b></td><td width=80 bgcolor="#79F5FF"><b>Storage</b></td><td width=80 bgcolor="#79F5FF"><b>Other</b></td><td width=80 bgcolor="#59FD61"><b>Servers</b></td><td width=80 bgcolor="#59FD61"><b>Networking</b></td><td width=80 bgcolor="#59FD61"><b>Storage</b></td><td bgcolor="#59FD61"><b>Other</td><td bgcolor="#FFFF66" width=100><b>Servers</td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=80>$SCSERVERS</td><td width=80>$SCNETWORK</td><td width=80>$SCSTORAGE</td><td width=80>$SCOTHER</td><td width=80>$ZNSERVERS</td><td width=80>$ZNNETWORK</td><td width=80>$ZNSTORAGE</td><td width=80>$ZNOTHER</td><td width=80>$HPSASVR</td></tr>" >> $ALLOUT
uniq $ALLOUT |tail -5| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
}
all
aviation
unset IFS
# Send emails
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "### TEST Menzies Daily Report TEST ###" -a $RRDSERVIMG -a $RRDCOUNTIMG  < $MAILFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,pushkar.shirolkar@sungardas.com,jan.clayton-adamson@sungardas.com,kevin.erickson@sungardas.com,paul.higgins@sungardas.com,as.toc.network.management@sungardas.com,mark.hill@sungardas.com" -s "### Daily Global Open Ticket Report ###" -a $RRDGRAPH < $MAILFILE
#mv /tmp/*.mail /data/sn/archive
