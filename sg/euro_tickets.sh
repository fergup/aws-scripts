#!/bin/bash
###################################################################################
#
# euro_tickets.sh
# ---------------
# Reports on status of European ticketing
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 01/05/15 |  PRF   | First edition
# ---------------------------------------------------------------------------------
#
###################################################################################
#
# Declare variables
#
###################################################################################
DATE=$(date +%Y%m%d)
PDFDATE=$(date +%A" "%d" "%B" "%Y)
RRDDATE=$(date +%m/%d/%Y" "%H:%M)
DATADIR=/data
MAILDIR=$DATADIR/mail
RRDDIR=$DATADIR/rrd
IMGDIR=$DATADIR/images
ZNFILE=$DATADIR/uk-zenoss-dump-$DATE.csv
SCFILE=$DATADIR/sc-sasu-all.txt
SAFILE=$DATADIR/hpsa_servers.csv
DAY=$(date +%d" "%b" "%Y)
SACUSTFILE=$MAILDIR/$DATE.euromail.txt
HTMAILFILE=$MAILDIR/$DATE.euromail.html
HTMAILFILE2=$MAILDIR/$DATE.pdf.html
PDF=$MAILDIR/$DATE.pdf
SNFILE=$DATADIR/sn/EuropeanXTicketsXPFXexport.csv
CSV=$DATADIR/euro_assets.$DATE.csv
IEFILE=$DATADIR/hpsa_servers_ie.csv
SEFILE=$DATADIR/hpsa_servers_se.csv
FRFILE=$DATADIR/hpsa_servers_fr.csv
SARRDGRAPH=$IMGDIR/hpsa_europe.png
ZNRRDGRAPH=$IMGDIR/zn_europe.png
SNIERRDGRAPH=$IMGDIR/sn_ireland.png
SARRDGRAPHM=$IMGDIR/hpsa_europe_m.png
ZNRRDGRAPHM=$IMGDIR/zn_europe_m.png
EUTIXGRAPH=$IMGDIR/eutixall.png
UKTIXGRAPH=$IMGDIR/uktix.png
IETIXGRAPH=$IMGDIR/ietix.png
SETIXGRAPH=$IMGDIR/setix.png
FRTIXGRAPH=$IMGDIR/frtix.png
cat $SAFILE |sort|uniq|awk -F, '($5~"IE:") { print $0 }' > $IEFILE
cat $SAFILE |sort|uniq|awk -F, '($5~"SE:") { print $0 }' > $SEFILE
cat $SAFILE |sort|uniq|awk -F, '($5~"FR:") { print $0 }' > $FRFILE
UKSA=$(cat $SAFILE |awk -F, '($5~"GB:")'|sort|uniq|wc -l)
IESA=$(cat $SAFILE |awk -F, '($5~"IE:")'|sort|uniq|wc -l)
SESA=$(cat $SAFILE |awk -F, '($5~"SE:")'|sort|uniq|wc -l)
FRSA=$(cat $SAFILE |awk -F, '($5~"FR:")'|sort|uniq|wc -l)
UKZN=$(cat $ZNFILE |awk -F, '($6~"/GB/")'|sort|uniq|wc -l)
IEZN=$(cat $ZNFILE |awk -F, '($6~"/IE/")'|sort|uniq|wc -l)
SEZN=$(cat $ZNFILE |awk -F, '($6~"/SE/")'|sort|uniq|wc -l)
FRZN=$(cat $ZNFILE |awk -F, '($6~"/FR/")'|sort|uniq|wc -l)
UKSC=$(cat $SCFILE |awk -F'\t' '($12~"GB")' |wc -l)
IESC=$(cat $SCFILE |awk -F'\t' '($12~"IE")' |wc -l)
SESC=$(cat $SCFILE |awk -F'\t' '($12~"SE")' |wc -l)
FRSC=$(cat $SCFILE |awk -F'\t' '($12~"FR")' |wc -l)
UKTIX=$(cat $SNFILE| awk -F, '($10~"UK") { print $1 }' |wc -l)
IETIX=$(cat $SNFILE| awk -F, '($10~"Ireland") { print $1 }' |wc -l)
SETIX=$(cat $SNFILE| awk -F, '($10~"Sweden") { print $1 }' |wc -l)
FRTIX=$(cat $SNFILE| awk -F, '($10~"France") { print $1 }' |wc -l)
UKTIXUK=$(cat $SNFILE| awk -F, '(($10~"UK")||($26~"United Kingdom")||($26~"UK")) && (($24~"United Kingdom")||($24~"UK")) { print $1 }' |wc -l)
IETIXUK=$(cat $SNFILE| awk -F, '(($10~"Ireland")||($26~"Ireland")||($26~"IE")) && (($24~"United Kingdom")||($24~"UK")) { print $1 }' |wc -l)
SETIXUK=$(cat $SNFILE| awk -F, '(($10~"Sweden")||($26~"Sweden")||($26~"SE")) && (($24~"United Kingdom")||($24~"UK")) { print $1 }' |wc -l)
FRTIXUK=$(cat $SNFILE| awk -F, '(($10~"France")||($26~"France")||($26~"FR")) && (($24~"United Kingdom")||($24~"UK")) { print $1 }' |wc -l)
UKTIXIE=$(cat $SNFILE| awk -F, '(($10~"UK")||($26~"United Kingdom")||($26~"UK")) && (($24~"Ireland")||($24~"IE")) { print $1 }' |wc -l)
IETIXIE=$(cat $SNFILE| awk -F, '(($10~"Ireland")||($26~"Ireland")||($26~"IE")) && (($24~"Ireland")||($24~"IE")) { print $1 }' |wc -l)
SETIXIE=$(cat $SNFILE| awk -F, '(($10~"Sweden")||($26~"Ireland")||($26~"IE")) && (($24~"Ireland")||($24~"IE")) { print $1 }' |wc -l)
FRTIXIE=$(cat $SNFILE| awk -F, '(($10~"France")||($26~"France")||($26~"FR")) && (($24~"Ireland")||($24~"IE")) { print $1 }' |wc -l)
UKTIXIN=$(cat $SNFILE| awk -F, '(($10~"UK")||($26~"United Kingdom")||($26~"UK")) && (($24~"India")||($24~"IN")) { print $1 }' |wc -l)
IETIXIN=$(cat $SNFILE| awk -F, '(($10~"Ireland")||($26~"Ireland")||($26~"IE")) && (($24~"India")||($24~"IN")) { print $1 }' |wc -l)
FRTIXIN=$(cat $SNFILE| awk -F, '(($10~"France")||($26~"France")||($26~"FR")) && (($24~"India")||($24~"IN")) { print $1 }' |wc -l)
SETIXIN=$(cat $SNFILE| awk -F, '(($10~"Sweden")||($26~"Sweden")||($26~"SE")) && (($24~"India")||($24~"IN")) { print $1 }' |wc -l)
UKTIXFR=$(cat $SNFILE| awk -F, '(($10~"UK")||($26~"United Kingdom")||($26~"UK")) && (($24~"France")||($24~"FR")) { print $1 }' |wc -l)
IETIXFR=$(cat $SNFILE| awk -F, '(($10~"Ireland")||($26~"Ireland")||($26~"IE")) && (($24~"France")||($24~"FR")) { print $1 }' |wc -l)
FRTIXFR=$(cat $SNFILE| awk -F, '(($10~"France")||($26~"France")||($26~"FR")) && (($24~"France")||($24~"FR")) { print $1 }' |wc -l)
SETIXFR=$(cat $SNFILE| awk -F, '(($10~"Sweden")||($26~"Sweden")||($26~"SE")) && (($24~"France")||($24~"FR")) { print $1 }' |wc -l)
UKTIXSE=$(cat $SNFILE| awk -F, '(($10~"UK")||($26~"United Kingdom")||($26~"UK")) && (($24~"Sweden")||($24~"SE")) { print $1 }' |wc -l)
IETIXSE=$(cat $SNFILE| awk -F, '(($10~"Ireland")||($26~"Ireland")||($26~"IE")) && (($24~"Sweden")||($24~"SE")) { print $1 }' |wc -l)
FRTIXSE=$(cat $SNFILE| awk -F, '(($10~"France")||($26~"France")||($26~"FR")) && (($24~"Sweden")||($24~"SE")) { print $1 }' |wc -l)
SETIXSE=$(cat $SNFILE| awk -F, '(($10~"Sweden")||($26~"Sweden")||($26~"SE")) && (($24~"Sweden")||($24~"SE")) { print $1 }' |wc -l)
EUTIXEU=$(($UKTIXUK+$IETIXUK+$SETIXUK+$FRTIXUK+$UKTIXIE+$IETIXIE+$SETIXIE+$FRTIXIE+$UKTIXFR+$IETIXFR+$FRTIXFR+$SETIXFR+$UKTIXSE+$IETIXSE+$FRTIXSE+$SETIXSE))
EUTIXIN=$(($UKTIXIN+$IETIXIN+$FRTIXIN+$SETIXIN))
# Open Tickets
OPEN=$DATADIR/sn/PHXOpenXTicketsXoverX30Xdays.csv
CLOSED=$DATADIR/sn/PHXClosedXYesterday.csv
RRDFILE=$DATADIR/rrd/sn_ph_open.rrd
DATE=$(date +%Y-%m-%d" "%H:%M:%S)
DDATE=$(date +%d/%m/%Y)
IFS='"'
datediff() {
     d1=$(date -d "$1" +%s)
     d2=$(date -d "$2" +%s)
     echo $(( (d1 - d2) / 86400 )) days
}
OVERTEN=$(for i in $(cat $OPEN |awk -F, '{ print $7 }'); do echo $i;datediff "$DATE" "$i"; done |grep days |sed 's/days//g'|grep [1-9][1-9] |wc -l)
NEWINSCOPE=$(for i in $(cat $OPEN |awk -F, '{ print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][1-9] |egrep -w "3
0|31" |wc -l)
NEWINSCOPER=$(for i in $(cat $OPEN |awk -F, '($5~"Resolved") { print $6 }'); do echo $i;datediff "$DATE" "$i"; done   |grep days |sed 's/days//g'|grep [1-9][
1-9] |egrep -w "30|31" |wc -l)
ALL=$(cat $OPEN|wc -l)
CLOSEDY=$(cat $CLOSED|wc -l)
RES=$(cat $OPEN|awk -F, '($5~"Resolved") { print $0 }'|wc -l)
RRDDATE=$(date +%m/%d/%Y" "%H:%M)
RRDFILE=$RRDDIR/sn_ph_open.rrd
RRDGRAPHALL=$MAILDIR/ph_pm_inc_all_nostack.png
RRDGRAPHPH=$MAILDIR/ph_all_stack.png
RRDGRAPHOPEN=$MAILDIR/ph_all_open.png
RRDGRAPHPM=$MAILDIR/pm_all_stack.png
PHTIX=$MAILDIR/Paul_Higgins_Open_Tickets
###################################################################################
#
# Do stuff
#
###################################################################################
echo "Irish systems in HPSA:" > $SACUSTFILE
cat $IEFILE |sort|uniq|awk -F, '{ print $4 }' |python /usr/local/bin/namescount.py|sort -nr >> $SACUSTFILE
echo "" >> $SACUSTFILE
echo "Swedish systems in HPSA:" >> $SACUSTFILE
cat $SEFILE |sort|uniq|awk -F, '{ print $4 }' |python /usr/local/bin/namescount.py|sort -nr >> $SACUSTFILE
echo "" >> $SACUSTFILE
echo "French systems in HPSA:" >> $SACUSTFILE
cat $FRFILE |sort|uniq|awk -F, '{ print $4 }' |python /usr/local/bin/namescount.py|sort -nr >> $SACUSTFILE
SACUST=$(cat $SACUSTFILE)
printf "<span style='font-family:arial;font-weight:bold'><table><tr><td><H2><font face="Arial">European MS Report</font></H2></td><td><img src="http://www.sigmasolinc.com/wp-content/uploads/2014/04/sungardAS-logo.png" height="80"></td></tr></table>" > $HTMAILFILE
printf "</span><table border='1'><span style='font-family:arial'><tr><span style='font-family:arial;font-weight:normal'><td width=100><b>Date</b></font></td><td width=150><b>Open incident tickets raised over 30 days ago</b></td><td width=100><b>In resolved state</b></td><td width=100><b>Not updated in past 10 days</b><td width=100><b>New in scope</b></td><td width=100><b>New in scope resolved</b></td><td width=60><b>Closed yesterday</b></td></span></tr><tr><td width=100><center>$DDATE</font></td><td width=60><center>$ALL</td><td width=100><center>$RES</td><td width=60><center>$OVERTEN</td><td width=60><center>$NEWINSCOPE<td width=60><center>$NEWINSCOPER</td><td><center>$CLOSEDY</td></span></tr></table>" >> $HTMAILFILE
printf "<table border='1'><span style='font-family:arial;font-weight:bold'>
<tr><td width=100><b>Country</b></td><td width=60><b>UK</b></td><td width=60><b>IE</b></td><td width=60><b>SE</b></td><b><td width=60>FR</td></b><td width=60><b>IN</b></td></tr></span>
<tr><span style='font-family:arial;font-weight:normal'>
<td width=100><b><font color="black">UK<b></font></td><td width=60>$UKTIXUK</td><td width=60>$UKTIXIE</td><td width=60>$UKTIXSE<td width=60>$UKTIXFR<td width=60>$UKTIXIN</td></span></tr>
<tr><span style='font-family:arial;font-weight:normal'>
<td width=100><b><font color="green">Ireland<b></font></td><td width=60>$IETIXUK</td><td width=60>$IETIXIE</td><td width=60>$IETIXSE<td width=60>$IETIXFR<td width=60>$IETIXIN</td></span></tr>
<tr><span style='font-family:arial;font-weight:normal'>
<td width=100><b><font color="blue">Sweden<b></font></td><td width=60>$SETIXUK</td><td width=60>$SETIXIE</td><td width=60>$SETIXSE<td width=60>$SETIXFR<td width=60>$SETIXIN</td></span></tr>
<tr><span style='font-family:arial;font-weight:normal'>
<td width=100><b><font color="red">France<b></font></td><td width=60>$FRTIXUK</td><td width=60>$FRTIXIE</td><td width=60>$FRTIXSE<td width=60>$FRTIXFR<td width=60>$FRTIXIN</td></span></tr></table></span>" >> $HTMAILFILE
printf "<table border='1'><span style='font-family:arial;font-weight:bold'>
<tr><td width=100><b>Country</b></td><td width=100><b>SC</b></td><td width=100><b>HPSA</b></td><td width=100><b>Zenoss</b></td></tr></span>
<tr><span style='font-family:arial;font-weight:normal'>
<td width=100><b><font color="black">UK<b></font></td><td width=100>$UKSC</td><td width=100>$UKSA</td><td width=100>$UKZN</span></td> </tr>
<tr><span style='font-family:arial;font-weight:normal'>
<td width=100><b><font color="green">Ireland<b></font></td><td width=100>$IESC</td><td width=100>$IESA</td><td width=100>$IEZN</span></td> </tr>
<tr><span style='font-family:arial;font-weight:normal'>
<td width=100><b><font color="blue">Sweden</b></font></td><td width=100>$SESC</td><td width=100>$SESA</td><td width=100>$SEZN</span></td> </tr>
<tr><span style='font-family:arial;font-weight:normal'>
<td width=100><b><font color="red">France</b></font></td><td width=100>$FRSC</td><td width=100>$FRSA</td><td width=100>$FRZN</span></td> </tr>
</table></span>" >> $HTMAILFILE
echo "" >> $HTMAILFILE
# Update RRD graph
rrdtool update $RRDDIR/sn_ph_open.rrd "$RRDDATE@$ALL:$RES:$OVERTEN:$NEWINSCOPE:$NEWINSCOPER:$CLOSEDY"
rrdtool update $RRDDIR/hpsa_1d.rrd "$RRDDATE@$IESA:$SESA:$FRSA" >> $SACUSTFILE 2>&1
rrdtool update $RRDDIR/zen_1d.rrd "$RRDDATE@$IEZN:$SEZN:$FRZN" >> $SACUSTFILE 2>&1
rrdtool update $RRDDIR/sn_ie_1d.rrd "$RRDDATE@$IETIXIE:$IETIXUK:$IETIXIN" >> $SACUSTFILE 2>&1
rrdtool update $RRDDIR/sn_all.rrd "$RRDDATE@$UKTIXUK:$IETIXUK:$SETIXUK:$FRTIXUK:$UKTIXIE:$IETIXIE:$SETIXIE:$FRTIXIE:$UKTIXIN:$IETIXIN:$SETIXIN:$FRTIXIN:$UKTIXSE:$IETIXSE:$IETIXSE:$FRTIXSE:$UKTIXFR:$IETIXFR:$IETIXFR:$FRTIXFR"
rrdtool update $RRDDIR/sn_all_eu.rrd "$RRDDATE@$UKTIXUK:$IETIXUK:$SETIXUK:$FRTIXUK:$UKTIXIE:$IETIXIE:$SETIXIE:$FRTIXIE:$UKTIXIN:$IETIXIN:$SETIXIN:$FRTIXIN:$UKTIXSE:$IETIXSE:$SETIXSE:$FRTIXSE:$UKTIXFR:$IETIXFR:$SETIXFR:$FRTIXFR:$EUTIXEU:$EUTIXIN"
rrdtool graph $SARRDGRAPH -a PNG --title="European servers in HPSA, by country (week)" --vertical-label "Devices in HPSA" 'DEF:probe1=/data/rrd/hpsa_1d.rrd:ie-hpsa:AVERAGE' 'DEF:probe2=/data/rrd/hpsa_1d.rrd:se-hpsa:AVERAGE' 'DEF:probe3=/data/rrd/hpsa_1d.rrd:fr-hpsa:AVERAGE' 'LINE2:probe1#35b73d:Irish Servers' 'LINE2:probe2#0400ff:Swedish Servers' 'LINE2:probe3#ff0000:French Servers' -W "Sungard Availability Services" -s now-14d -e now
rrdtool graph $ZNRRDGRAPH -a PNG --title="European servers in Zenoss, by country (week)" --vertical-label "Devices in Zenoss" 'DEF:probe1=/data/rrd/zen_1d.rrd:ie-zen:AVERAGE' 'DEF:probe2=/data/rrd/zen_1d.rrd:se-zen:AVERAGE' 'DEF:probe3=/data/rrd/zen_1d.rrd:fr-zen:AVERAGE' 'LINE2:probe1#35b73d:Irish Servers' 'LINE2:probe2#0400ff:Swedish Servers' 'LINE2:probe3#ff0000:French Servers' -W "Sungard Availability Services" -s now-14d -e now
rrdtool graph $SARRDGRAPHM -a PNG --title="European servers in HPSA, by country (last 2 mths)" --vertical-label "Devices in HPSA" 'DEF:probe1=/data/rrd/hpsa_1d.rrd:ie-hpsa:AVERAGE' 'DEF:probe2=/data/rrd/hpsa_1d.rrd:se-hpsa:AVERAGE' 'DEF:probe3=/data/rrd/hpsa_1d.rrd:fr-hpsa:AVERAGE' 'LINE2:probe1#35b73d:Irish Servers' 'LINE2:probe2#0400ff:Swedish Servers' 'LINE2:probe3#ff0000:French Servers' -W "Sungard Availability Services" -s now-2m -e now
rrdtool graph $ZNRRDGRAPHM -a PNG --title="European servers in Zenoss, by country (last 2 mths)" --vertical-label "Devices in Zenoss" 'DEF:probe1=/data/rrd/zen_1d.rrd:ie-zen:AVERAGE' 'DEF:probe2=/data/rrd/zen_1d.rrd:se-zen:AVERAGE' 'DEF:probe3=/data/rrd/zen_1d.rrd:fr-zen:AVERAGE' 'LINE2:probe1#35b73d:Irish Servers' 'LINE2:probe2#0400ff:Swedish Servers' 'LINE2:probe3#ff0000:French Servers' -W "Sungard Availability Services" -s now-2m -e now
rrdtool graph $SNIERRDGRAPH -a PNG --title="Irish Tickets Assigned per week (last 2 mths)" --vertical-label "Tickets assigned" 'DEF:probe1=/data/rrd/sn_ie_1d.rrd:ie-ie:AVERAGE' 'DEF:probe2=/data/rrd/sn_ie_1d.rrd:ie-uk:AVERAGE' 'DEF:probe3=/data/rrd/sn_ie_1d.rrd:ie-in:AVERAGE' 'LINE2:probe1#35b73d:Irish Tickets Assigned in Ireland' 'LINE2:probe2#ff0000:Irish Tickets Assigned in UK' 'LINE2:probe3#ffa500:Irish Tickets Assigned in India' -W "Sungard Availability Services" -s now-2m -e now
rrdtool graph $EUTIXGRAPH -a PNG --title="European Ticket Assignments" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/sn_all_eu.rrd:eutixeu:AVERAGE' 'DEF:probe2=/data/rrd/sn_all_eu.rrd:eutixin:AVERAGE' 'AREA:probe1#48C4EC:European Tickets Assigned to European resources:STACK' 'AREA:probe2#54EC48:European Tickets Assigned to Indian resources:STACK' -w 600 -h 100 -n TITLE:13: --alt-y-grid -l 0 -s now-2w -e now
rrdtool graph $UKTIXGRAPH -a PNG --title="UK Ticket Assignments" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/sn_all_eu.rrd:uktixuk:AVERAGE' 'DEF:probe2=/data/rrd/sn_all_eu.rrd:uktixie:AVERAGE' 'DEF:probe3=/data/rrd/sn_all_eu.rrd:uktixse:AVERAGE' 'DEF:probe4=/data/rrd/sn_all_eu.rrd:uktixfr:AVERAGE'  'DEF:probe5=/data/rrd/sn_all_eu.rrd:uktixin:AVERAGE' 'LINE2:probe1#48C4EC:UK Tickets in UK queues' 'LINE2:probe2#54EC48:UK Tickets in Irish queues'  'LINE2:probe3#ECD748:UK Tickets in Swedish queuss' 'LINE2:probe4#CC3118:UK Tickets in French queues' 'LINE2:probe5#4D18E4:UK Tickets in Indian queues' -s now-2w -e now
rrdtool graph $IETIXGRAPH -a PNG --title="Irish Ticket Assignments" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/sn_all_eu.rrd:ietixie:AVERAGE' 'DEF:probe2=/data/rrd/sn_all_eu.rrd:ietixuk:AVERAGE' 'DEF:probe3=/data/rrd/sn_all_eu.rrd:ietixse:AVERAGE' 'DEF:probe4=/data/rrd/sn_all_eu.rrd:ietixfr:AVERAGE' 'DEF:probe5=/data/rrd/sn_all_eu.rrd:ietixin:AVERAGE' 'LINE2:probe1#54EC48:Irish Tickets in Irish queues' 'LINE2:probe2#48C4EC:Irish Tickets in UK queues' 'LINE2:probe3#ECD748:Irish Tickets in Swedish queues' 'LINE2:probe4#CC3118:Irish Tickets in French queues' 'LINE2:probe5#4D18E4:Irish Tickets in Indian queues' -s now-2w -e now
rrdtool graph $SETIXGRAPH -a PNG --title="Swedish Ticket Assignments" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/sn_all_eu.rrd:setixse:AVERAGE' 'DEF:probe2=/data/rrd/sn_all_eu.rrd:setixuk:AVERAGE' 'DEF:probe3=/data/rrd/sn_all_eu.rrd:setixie:AVERAGE' 'DEF:probe4=/data/rrd/sn_all_eu.rrd:setixfr:AVERAGE'  'DEF:probe5=/data/rrd/sn_all_eu.rrd:setixin:AVERAGE' 'LINE2:probe1#ECD748:Swedish Tickets in Swedish queues' 'LINE2:probe2#48C4EC:Swedish Tickets in UK queues'  'LINE2:probe3#54EC48:Swedish Tickets in Irish queuss' 'LINE2:probe4#CC3118:Swedish Tickets in French queues' 'LINE2:probe5#4D18E4:Swedish Tickets in Indian queues' -s now-2w -e now
rrdtool graph $FRTIXGRAPH -a PNG --title="French Ticket Assignments" --vertical-label "Number of Tickets" 'DEF:probe1=/data/rrd/sn_all_eu.rrd:frtixfr:AVERAGE' 'DEF:probe2=/data/rrd/sn_all_eu.rrd:frtixuk:AVERAGE' 'DEF:probe3=/data/rrd/sn_all_eu.rrd:frtixie:AVERAGE' 'DEF:probe4=/data/rrd/sn_all_eu.rrd:frtixse:AVERAGE'  'DEF:probe5=/data/rrd/sn_all_eu.rrd:frtixin:AVERAGE' 'LINE2:probe1#CC3118:French Tickets in French queues' 'LINE2:probe2#48C4EC:French Tickets in UK queues'  'LINE2:probe3#54EC48:French Tickets in Irish queuss' 'LINE2:probe4#ECD748:French Tickets in Swedish queues' 'LINE2:probe5#4D18E4:French Tickets in Indian queues' -s now-2w -e now
echo "
<html>
<table><tr><td width="70%"><H2>Weekly European Device Report</H2><H4>$PDFDATE</H4></td><td width="30%"><img src="/data/images/sungardAS-logo.png" height="120"></td></tr></table>
<H4>Ticketing</H4>
<table border='1' font face="Helvetica">
<tr font face="arial"><td width=100 rowspan="2"><font face="Arial"><b>Originating country<td colspan="5"><font face="Arial"><center><b>Country working ticket</center></b></td></font></tr>
<tr><td width=120 align=center><b>UK</b></td><td width=100 align=center><b>Ireland</b></td><td width=100 align=center><b>Sweden</b></td><td width=100 align=center><b>France</b><td width=100 align=center><b>India</b></tr>
<tr font face="arial">
<td width=100><b><font color="black">UK</font></td><td width=120 align="center">$UKTIXUK</td><td width=100 align="center">$UKTIXIE</td><td width=100 align="center">$UKTIXSE</td><td width=120 align="center">$UKTIXFR</td><td width=120 align="center">$UKTIXIN</td></tr>
<td width=100><b>Ireland</td><td width=120 align="center">$IETIXUK</td><td width=100 align="center">$IETIXIE</td><td width=100 align="center">$IETIXSE</td><td width=100 align="center">$IETIXFR</td><td width=120 align="center">$IETIXIN</td></tr>
<tr font face="arial">
<td width=100><b>Sweden</b></td><td width=120 align="center">$SETIXUK</td><td width=100 align="center">$SETIXIE</td><td width=100 align="center">$SETIXSE</td><td width=100 align="center" font color=red>$SETIXFR</td><td width=120 align="center">$SETIXIN</td></tr>
<tr font face="arial">
<td width=100><b>France</b></td><td width=120 align="center">$FRTIXUK</td><td width=100 align="center">$FRTIXIE</td><td width=100 align="center">$FRTIXSE</td><td width=100 align="center">$FRTIXFR</td><td width=120 align="center">$FRTIXIN</td> </tr>
</table>
<br>
<img src="$EUTIXGRAPH">
<table><tr>
<td><img src="$UKTIXGRAPH" width=350></td><td><img src="$IETIXGRAPH" width=350></tr>
<td><img src="$SETIXGRAPH" width=350></td><td><img src="$FRTIXGRAPH" width=350></tr>
</table>
<br><br><br><br><br><br><br>
<H4>Device Status</H4>
<table border='1' font face="Helvetica">
<tr><td width=100><b>Country</b></td><td width=120 align="center"><b>Service Center</b></td><td width=100 align="center"><b>Zenoss</b></td><td width=100 align="center"><b>HPSA</b></td><td width=100 align="center"><b>Tickets (all)</td></tr>
<tr font face="Arial">
<td width=100><b><font color="black">UK</font></td><td width=120 align="center">$UKSC</td><td width=100 align="center">$UKZN</td><td width=100 align="center">$UKSA</td><td width=120 align="center">$UKTIX</td></tr>
<td width=100><b><font color="green">Ireland</font></td><td width=120 align="center">$IESC</td><td width=100 align="center">$IEZN</td><td width=100 align="center">$IESA</td><td width=100 align="center">$IETIX</td></tr>
<tr font face="Arial">
<td width=100><b><font color="blue">Sweden</b></font></td><td width=120 align="center">$SESC</td><td width=100 align="center">$SEZN</td><td width=100 align="center">$SESA</td><td width=100 align="center">$SETIX</td></tr>
<tr font face="Arial">
<td width=100><b><font color="red">France</b></font></td><td width=120 align="center">$FRSC</td><td width=100 align="center">$FRZN</td><td width=100 align="center">$FRSA</td><td width=100 align="center">$FRTIX</td></tr>
</table>
<br>
<H4>Servers in HPSA/Zenoss</H4>
<table><tr>
<img src="$IMGDIR/hpsa_europe_m.png" width=600></td>
<tr><img src="$IMGDIR/zn_europe_m.png" width=600>
</tr>
</table>
</html>" > $HTMAILFILE2
#htmldoc $HTMAILFILE2 -f $PDF --webpage -t pdf14
/usr/local/bin/wkhtmltopdf-amd64 $HTMAILFILE2  $PDF
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s " New European Asset Report on $DAY" -a $SARRDGRAPHM -a $SNIERRDGRAPH -a $EUTIXGRAPH -a $PDF -a $RRDGRAPHOPEN < $HTMAILFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,marc.mooney@sungardas.com,andrew.philp@sungardas.com" -s "European Asset Report on $DAY" -a $SARRDGRAPH -a $ZNRRDGRAPH -a $SARRDGRAPHM -a $ZNRRDGRAPHM -a $SACUSTFILE < $HTMAILFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "European Asset Report on $DAY" -a $SARRDGRAPH -a $ZNRRDGRAPH -a $SARRDGRAPHM -a $ZNRRDGRAPHM -a $SACUSTFILE < $HTMAILFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "European Asset Report on $DAY" -a $SARRDGRAPH -a $ZNRRDGRAPH -a $SACUSTFILE < $HTMAILFILE
#[[ $(date +%A) == Monday ]] && mutt -e 'set content_type="text/html"' "ann.wingard@sungardas.com,martin.johansson@sungardas.com,gary.watson@sungardas.com,paul.higgins@sungardas.com,paul.ferguson@sungardas.com" -s "European Asset Report on $DAY" -a $SARRDGRAPH -a $ZNRRDGRAPH -a $SARRDGRAPHM -a $ZNRRDGRAPHM -a $SACUSTFILE < $HTMAILFILE
