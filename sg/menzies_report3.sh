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
SNFILE=/data/sn/MenziesXDailyXReport.csv
SCFILE=/data/sc-sasu-all.txt
HPSA=/data/hpsa_servers.csv
ZENOSS=$(ls -atr /data/uk-zenoss* |tail -1)
OPEN=$(ls -atr $TIXDIR/menzies-heat-*.csv|tail -1)
RRDSERV=/data/rrd/mz_serv.rrd
RRDTYPE=/data/rrd/mz_type.rrd
RRDSTATUS=/data/rrd/mz_status.rrd
RRDTOOLS=/data/rrd/mz_tools.rrd
RRDSERVIMG=/data/images/mz_serv.png
RRDTYPEIMG=/data/images/mz_type.png
RRDSTATUSIMG=/data/images/mz_status.png
RRDTOOLSIMG=/data/images/mz_tools.png
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
SVOTHER=$(awk -F, '($6!~"Data|Desktop|Freight|Network|Server|Website") { print }' $OPEN|wc -l)
# Countries
COUK=$(awk -F, '($15~"United Kingdom") { print }' $OPEN|wc -l)
COUS=$(awk -F, '($15~"United States") { print }' $OPEN|wc -l)
COAUS=$(awk -F, '($15~"Australia") { print }' $OPEN|wc -l)
COIND=$(awk -F, '($15~"India") { print }' $OPEN|wc -l)
COSA=$(awk -F, '($15~"South Africa") { print }' $OPEN|wc -l)
COOTH=$(awk -F, '($15!~"United Kingdom")&&($15!~"United States")&&($15!~"Australis")&&($15!~"India")&&($15!~"South Africa") { print }' $OPEN|wc -l)
# Ticket status
STATACT=$(awk -F, '($2~"Active") { print }' $OPEN|wc -l)
STATRES=$(awk -F, '($2~"Resolved") { print }' $OPEN|wc -l)
STATWRD=$(awk -F, '($2~"Waiting for 3rd Party") { print }' $OPEN|wc -l)
STATWCUS=$(awk -F, '($2~"Waiting for Customer") { print }' $OPEN|wc -l)
STATWRES=$(awk -F, '($2~"Waiting for Resolution") { print }' $OPEN|wc -l)
# Type of Incident
TYPEFAIL=$(awk -F, '($3~"Failure") { print }' $OPEN|wc -l)
TYPEREQ=$(awk -F, '($3~"Request") { print }' $OPEN|wc -l)
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
# Service Now variables
SNINC=$(awk -vcount=0 -F'","' '($11~"Incident") {count++} END { print count }' $SNFILE)
SNREQ=$(awk -vcount=0 -F'","' '($11~"Request") {count++} END { print count }' $SNFILE)
SNPRJ=$(awk -vcount=0 -F'","' '($11~"Project") {count++} END { print count }' $SNFILE)
SNCHG=$(awk -vcount=0 -F'","' '($11~"Change") {count++} END { print count }' $SNFILE)
SNOTH=$(awk -vcount=0 -F'","' '($11!~"Project|Change|Incident|Request") {count++} END { print count }' $SNFILE)
SNASSMZSUP=$(awk -vcount=0 -F'","' '($2~"Menzies Support") {count++} END { print count }' $SNFILE)
SNASSPRJ=$(awk -vcount=0 -F'","' '($2~"UK Project Management") {count++} END { print count }' $SNFILE)
SNASSUN=$(awk -vcount=0 -F'","' '($2!~" ")&&($2!~"assignment") {count++} END { print count }' $SNFILE)
SNASSOTH=$(awk -vcount=0 -F'","' '($2!~"UK Project Management")&&($2!~"Menzies Support")&&($2!~" ") {count++} END { print count }' $SNFILE)
# RRD things
MAILFILE=/data/mail/mz_open_mail
MZOUT=/data/mail/mz_out
ALLOUT=/data/mail/mz_all_out
SNOUT=/data/mail/mz_sn_out
# RRD updates and graphs
#rrdtool update $RRDFILENEW "$RRDDATE@$INCMORE30:$INCMORE20:$INCMORE10:$INCIPDUMORE30:$INCIPDUMORE20:$INCIPDUMORE10"
rrdtool update $RRDSERV "$RRDDATE@$SVDATA:$SVDESKTOP:$SVFREIGHT:$SVNET:$SVSVR:$SVWEB:$SVOTHER"
rrdtool update $RRDTYPE "$RRDDATE@$TYPEFAIL:$TYPEREQ"
rrdtool update $RRDSTATUS "$RRDDATE@$STATACT:$STATRES:$STATWRD:$STATWCUS:$STATWRES"
rrdtool update $RRDTOOLS "$RRDDATE@$SCSERVERS:$SCNETWORK:$SCSTORAGE:$SCOTHER:$ZNSERVERS:$ZNNETWORK:$ZNSTORAGE:$ZNOTHER:$HPSASVR"
#rrdtool update $RRDCOUNT "$RRDDATE@$COUK:$COUS:$COAUS:$COIND:$COSA:$COOTH"
rrdtool graph $RRDSERVIMG -a PNG '--title=Aviation Heat Tickets - Services Affected' --vertical-label 'Number of Tickets' DEF:probe1=/data/rrd/mz_serv.rrd:data:AVERAGE DEF:probe2=/data/rrd/mz_serv.rrd:desktop:AVERAGE DEF:probe3=/data/rrd/mz_serv.rrd:freight:AVERAGE DEF:probe4=/data/rrd/mz_serv.rrd:network:AVERAGE DEF:probe5=/data/rrd/mz_serv.rrd:server:AVERAGE DEF:probe6=/data/rrd/mz_serv.rrd:website:AVERAGE DEF:probe7=/data/rrd/mz_serv.rrd:other:AVERAGE 'AREA:probe1#FF0000:Data Service:STACK' 'AREA:probe2#00FF00:Desktops:STACK' 'AREA:probe3#FF3300:Freight Forwarding:STACK'  'AREA:probe4#FFFF00:Network Services:STACK'  'AREA:probe5#0000FF:Servers:STACK'  'AREA:probe6#000000:Websites:STACK'  'AREA:probe7#FF0099:Other Services:STACK' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-4w -e now+1d
rrdtool graph $RRDTYPEIMG -a PNG '--title=Aviation Heat Tickets - Incident Type' --vertical-label 'Number of Tickets' DEF:probe1=/data/rrd/mz_type.rrd:fail:AVERAGE DEF:probe2=/data/rrd/mz_type.rrd:req:AVERAGE 'AREA:probe1#000000:Failure:STACK'  'AREA:probe2#0000FF:Request:STACK'  -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-4w -e now+1d
rrdtool graph $RRDSTATUSIMG -a PNG '--title=Aviation Heat Tickets - Incident Status' --vertical-label 'Number of Tickets' DEF:probe1=/data/rrd/mz_status.rrd:active:AVERAGE DEF:probe2=/data/rrd/mz_status.rrd:resolved:AVERAGE DEF:probe3=/data/rrd/mz_status.rrd:wait3:AVERAGE DEF:probe4=/data/rrd/mz_status.rrd:waitcust:AVERAGE DEF:probe5=/data/rrd/mz_status.rrd:waitres:AVERAGE 'AREA:probe1#FF0000:Active:STACK' 'AREA:probe2#00FF00:Resolved:STACK' 'AREA:probe3#FF3300:Waiting 3rd Party:STACK'  'AREA:probe4#FFFF00:Waiting Customer:STACK'  'AREA:probe5#0000FF:Waiting Resolution:STACK' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-4w -e now+1d
rrdtool graph $RRDTOOLSIMG -a PNG '--title=Menzies Tools Migration - Progress' --vertical-label 'Number of Tickets' DEF:probe1=/data/rrd/mz_tools.rrd:scserv:AVERAGE DEF:probe2=/data/rrd/mz_tools.rrd:scnet:AVERAGE DEF:probe3=/data/rrd/mz_tools.rrd:scstor:AVERAGE DEF:probe4=/data/rrd/mz_tools.rrd:scoth:AVERAGE DEF:probe5=/data/rrd/mz_tools.rrd:zenserv:AVERAGE DEF:probe6=/data/rrd/mz_tools.rrd:zennet:AVERAGE DEF:probe7=/data/rrd/mz_tools.rrd:zenstor:AVERAGE DEF:probe8=/data/rrd/mz_tools.rrd:zenoth:AVERAGE DEF:probe9=/data/rrd/mz_tools.rrd:hpsa:AVERAGE 'AREA:probe1#FF9966:SC - servers:STACK' 'AREA:probe2#FF6633:SC - Networking:STACK' 'AREA:probe3#FF6600:SC - Storage:STACK'  'AREA:probe4#FF3300:SC - Other:STACK'  'AREA:probe5#FFFF99:Zenoss - Servers:STACK'  'AREA:probe6#FFFF33:Zenoss - Networking:STACK'  'AREA:probe7#FFCC00:Zenoss - Storage:STACK' 'AREA:probe8#CC9900:Zenoss - Other:STACK' 'AREA:probe9#00FF00:HPSA:STACK' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-4w -e now+1d
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

</style></head><body>" >> $MAILFILE

# Aviation table
aviation() {
printf "<br><span style='font-family:arial;text-align: center'><table border='1'><tr><td width="600" colspan="15" bgcolor="red"><b><font color="white">Aviation Heat Tickets</font></b></td></tr><tr><td width=100 rowspan="2" bgcolor="#DAEEF3" style="vertical-align:middle"><b>Date</b><td width=160 colspan="2" bgcolor="#00EEFF" style="vertical-align:middle"><b>Type of Incident<b></td><td width=490 colspan="7" bgcolor="#00EE22"><b>Service Affected</b></td><td width=400 colspan="5" bgcolor="yellow" style="vertical-align:middle"><b>Status<b></td></tr>
<tr><td bgcolor="#79F5FF"><b>Failure</td><td bgcolor="#79F5FF"><b>Request</td><td width=70 bgcolor="#59FD61"><b>Data</b></td><td width=70 bgcolor="#59FD61"><b>Desktop</b></td><td width=70 bgcolor="#59FD61"><b>Freight</b></td><td width=70 bgcolor="#59FD61"><b>Network</b></td><td width=70 bgcolor="#59FD61"><b>Server</b></td><td width=70 bgcolor="#59FD61"><b>Website</b></td><td width=70 bgcolor="#59FD61"><b>Other</b></td><td width=80 bgcolor="#FFFF66"><b>Active</b></td><td width=80 bgcolor="#FFFF66"><b>Resolved</b></td><td width=80 bgcolor="#FFFF66"><b>Waiting 3rd Party</b></td><td bgcolor="#FFFF66"><b>Waiting Customer</td><td bgcolor="#FFFF66"><b>Waiting Resolution</td></tr>" >> $MAILFILE
# Insert variables into table
echo "<tr><td width=100>$DDATE</td><td width=80>$TYPEFAIL</td><td width=80>$TYPEREQ</td><td width=80>$SVDATA</td><td width=80>$SVDESKTOP</td><td width=80>$SVFREIGHT</td><td width=80>$SVNET</td><td width=80>$SVSVR</td><td width=80>$SVWEB</td><td width=80>$SVOTHER</td><td width=80>$STATACT</td><td width=80>$STATRES</td><td width=80>$STATWRD</td><td width=80>$STATWCUS</td><td width=80>$STATWRES</td></tr>" >> $MZOUT
uniq $MZOUT |tail -3| tac >> $MAILFILE;printf "</span></table><br>" >> $MAILFILE
}
# General numbers
all() {
printf "<span style='font-family:arial;text-align: center'><table border='1'><tr><td width="700" colspan="10" bgcolor="#4F81BD"><b><font color="#FFFF66">Menzies Devices - All Tools</font></b></td></tr><tr><td width=100 rowspan="2" bgcolor="#DAEEF3" style="vertical-align:middle"><b>Date</b><td width=320 colspan="4" bgcolor="#00EEFF"><b>Service Center</b></td><td width=320 colspan="4" bgcolor="#00EE22" style="vertical-align:middle"><b>Zenoss<b></td><td width=100 colspan="1" bgcolor="yellow"><b>HPSA</td></tr>
<tr><td width=80 bgcolor="#79F5FF"><b>Servers</b></td><td width=80 bgcolor="#79F5FF"><b>Networking</b></td><td width=80 bgcolor="#79F5FF"><b>Storage</b></td><td width=80 bgcolor="#79F5FF"><b>Other</b></td><td width=80 bgcolor="#59FD61"><b>Servers</b></td><td width=80 bgcolor="#59FD61"><b>Networking</b></td><td width=80 bgcolor="#59FD61"><b>Storage</b></td><td bgcolor="#59FD61"><b>Other</td><td bgcolor="#FFFF66" width=100><b>Servers</td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=80>$SCSERVERS</td><td width=80>$SCNETWORK</td><td width=80>$SCSTORAGE</td><td width=80>$SCOTHER</td><td width=80>$ZNSERVERS</td><td width=80>$ZNNETWORK</td><td width=80>$ZNSTORAGE</td><td width=80>$ZNOTHER</td><td width=80>$HPSASVR</td></tr>" >> $ALLOUT
uniq $ALLOUT |tail -3| tac >> $MAILFILE;printf "</span></table><br>" >> $MAILFILE
}
# Service Now tickets
sn() {
printf "<span style='font-family:arial;text-align: center'><table border='1'><tr><td width="700" colspan="10" bgcolor="orange"><b><font color="black">Menzies All Service Now Tickets</font></b></td></tr><tr><td width=100 rowspan="2" bgcolor="#DAEEF3" style="vertical-align:middle"><b>Date</b><td width=320 colspan="5" bgcolor="#00EEFF"><b>Ticket Type</b></td><td width=320 colspan="4" bgcolor="#00EE22" style="vertical-align:middle"><b>Assignment Group<b></td></tr>
<tr><td width=80 bgcolor="#79F5FF"><b>Incident</b></td><td width=80 bgcolor="#79F5FF"><b>Change</b></td><td width=80 bgcolor="#79F5FF"><b>Request</b></td><td width=80 bgcolor="#79F5FF"><b>Project</b></td><td width=80 bgcolor="#79F5FF"><b>Other</b></td><td width=80 bgcolor="#59FD61"><b>Menzies Support</b></td><td width=80 bgcolor="#59FD61"><b>Project Management</b></td><td bgcolor="#59FD61"><b>Other</td><td bgcolor="#59FD61"><b>Unassigned</td></tr>" >> $MAILFILE
echo "<tr><td width=100>$DDATE</td><td width=80>$SNINC</td><td width=80>$SNCHG</td><td width=80>$SNREQ</td><td width=80>$SNPRJ</td><td width=80>$SNOTH</td><td width=80>$SNASSMZSUP</td><td width=80>$SNASSPRJ</td><td width=80>$SNASSOTH</td><td width=80>$SNASSUN</td></tr>" >> $SNOUT
uniq $SNOUT |tail -3| tac >> $MAILFILE;printf "</span></table>" >> $MAILFILE
}
# Do stuff
all
sn
aviation
unset IFS
# Send emails
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,ian.mitchell@sungardas.com,stuart.brook@sungardas.com,mayuri.patel@sungardas.com" -s "### TEST Menzies Daily Report TEST ###" -a $RRDSERVIMG -a $RRDTYPEIMG -a $RRDSTATUSIMG -a $RRDTOOLSIMG  < $MAILFILE
#mutt -e 'set content_type="text/html"' paul.ferguson@sungardas.com -s "### TEST Menzies Daily Report TEST ###" -a $RRDSERVIMG -a $RRDTYPEIMG -a $RRDSTATUSIMG -a $RRDTOOLSIMG  < $MAILFILE
#mv /tmp/*.mail /data/sn/archive
