#!/bin/bash
###################################################################################
#
# euro_assets.sh
# --------------
# Filters out European assets to be sent to European Tools Lead
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 16/09/12 |  PRF   | First edition
# |   1.1   | 09/03/14 |  PRF   | Updated for new reporting requirements
# ---------------------------------------------------------------------------------
#
###################################################################################
#
# Check we have some input and are pxfergus
#
###################################################################################
#[ $(whoami) != pxfergus ] && echo "ERROR! Not pxfergus" & exit 1
###################################################################################
#
# Declare variables
#
###################################################################################
DATE=$(date +%Y%m%d)
RRDDATE=$(date +%m/%d/%Y" "%H:%M)
DATADIR=/data
RRDDIR=$DATADIR/rrd
ZNFILE=$DATADIR/uk-zenoss-dump-$DATE.csv
SCFILE=$DATADIR/sc-sasu-all.txt
SAFILE=$DATADIR/hpsa_servers.csv
DAY=$(date +%d" "%b" "%Y)
SACUSTFILE=$DATADIR/mail/$DATE.euromail.txt
HTMAILFILE=$DATADIR/mail/$DATE.euromail.html
CSV=$DATADIR/euro_assets.$DATE.csv
IEFILE=/data/hpsa_servers_ie.csv
SEFILE=/data/hpsa_servers_se.csv
FRFILE=/data/hpsa_servers_fr.csv
SARRDGRAPH=$DATADIR/hpsa_europe.png
ZNRRDGRAPH=$DATADIR/zn_europe.png
SARRDGRAPHM=$DATADIR/hpsa_europe_m.png
ZNRRDGRAPHM=$DATADIR/zn_europe_m.png
cat $SAFILE |sort|uniq|awk -F, '($5~"IE:") { print $0 }' > $IEFILE
cat $SAFILE |sort|uniq|awk -F, '($5~"SE:") { print $0 }' > $SEFILE
cat $SAFILE |sort|uniq|awk -F, '($5~"FR:") { print $0 }' > $FRFILE
IESA=$(cat $SAFILE |awk -F, '($5~"IE:")'|sort|uniq|wc -l)
SESA=$(cat $SAFILE |awk -F, '($5~"SE:")'|sort|uniq|wc -l)
FRSA=$(cat $SAFILE |awk -F, '($5~"FR:")'|sort|uniq|wc -l)
IEZN=$(cat $ZNFILE |awk -F, '($6~"/IE/")'|sort|uniq|wc -l)
SEZN=$(cat $ZNFILE |awk -F, '($6~"/SE/")'|sort|uniq|wc -l)
FRZN=$(cat $ZNFILE |awk -F, '($6~"/FR/")'|sort|uniq|wc -l)
IESC=$(cat $SCFILE |awk -F'\t' '($12~"IE")' |wc -l)
SESC=$(cat $SCFILE |awk -F'\t' '($12~"SE")' |wc -l)
FRSC=$(cat $SCFILE |awk -F'\t' '($12~"FR")' |wc -l)
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
printf "<span style='font-family:arial;font-weight:bold'><table><tr><td><H2>European Assets</H2></td><td><img src="http://www.sigmasolinc.com/wp-content/uploads/2014/04/sungardAS-logo.png" height="80"></td></tr></table></span>
<table border='1'><span style='font-family:arial;font-weight:bold'>
<tr><td width=100><b>Country</b></td><td width=100><b>SC</b></td><td width=100><b>ZN</b></td><td width=100><b>HPSA</b></td></tr></span>
<tr><span style='font-family:arial;font-weight:normal'>
<td width=100><b><font color="green">Ireland<b></font></td><td width=100>$IESC</td><td width=100>$IEZN</td><td width=100>$IESA</span></td> </tr>
<tr><span style='font-family:arial;font-weight:normal'>
<td width=100><b><font color="blue">Sweden</b></font></td><td width=100>$SESC</td><td width=100>$SEZN</td><td width=100>$SESA</span></td> </tr>
<tr><span style='font-family:arial;font-weight:normal'>
<td width=100><b><font color="red">France</b></font></td><td width=100>$FRSC</td><td width=100>$FRZN</td><td width=100>$FRSA</span></td> </tr>
</table></span>" > $HTMAILFILE
# Update RRD graph
rrdtool update $RRDDIR/hpsa_1d.rrd "$RRDDATE@$IESA:$SESA:$FRSA" >> $SACUSTFILE 2>&1
rrdtool update $RRDDIR/zen_1d.rrd "$RRDDATE@$IEZN:$SEZN:$FRZN" >> $SACUSTFILE 2>&1
rrdtool graph $SARRDGRAPH -a PNG --title="European servers in HPSA, by country (week)" --vertical-label "Devices in HPSA" 'DEF:probe1=/data/rrd/hpsa_1d.rrd:ie-hpsa:AVERAGE' 'DEF:probe2=/data/rrd/hpsa_1d.rrd:se-hpsa:AVERAGE' 'DEF:probe3=/data/rrd/hpsa_1d.rrd:fr-hpsa:AVERAGE' 'LINE1:probe1#35b73d:Irish Servers' 'LINE1:probe2#0400ff:Swedish Servers' 'LINE1:probe3#ff0000:French Servers' -W "Sungard Availability Services" -s now-7d -e now
rrdtool graph $ZNRRDGRAPH -a PNG --title="European servers in Zenoss, by country (week)" --vertical-label "Devices in Zenoss" 'DEF:probe1=/data/rrd/zen_1d.rrd:ie-zen:AVERAGE' 'DEF:probe2=/data/rrd/zen_1d.rrd:se-zen:AVERAGE' 'DEF:probe3=/data/rrd/zen_1d.rrd:fr-zen:AVERAGE' 'LINE1:probe1#35b73d:Irish Servers' 'LINE1:probe2#0400ff:Swedish Servers' 'LINE1:probe3#ff0000:French Servers' -W "Sungard Availability Services" -s now-7d -e now
rrdtool graph $SARRDGRAPHM -a PNG --title="European servers in HPSA, by country (last 2 mths)" --vertical-label "Devices in HPSA" 'DEF:probe1=/data/rrd/hpsa_1d.rrd:ie-hpsa:AVERAGE' 'DEF:probe2=/data/rrd/hpsa_1d.rrd:se-hpsa:AVERAGE' 'DEF:probe3=/data/rrd/hpsa_1d.rrd:fr-hpsa:AVERAGE' 'LINE1:probe1#35b73d:Irish Servers' 'LINE1:probe2#0400ff:Swedish Servers' 'LINE1:probe3#ff0000:French Servers' -W "Sungard Availability Services" -s now-2m -e now
rrdtool graph $ZNRRDGRAPHM -a PNG --title="European servers in Zenoss, by country (last 2 mths)" --vertical-label "Devices in Zenoss" 'DEF:probe1=/data/rrd/zen_1d.rrd:ie-zen:AVERAGE' 'DEF:probe2=/data/rrd/zen_1d.rrd:se-zen:AVERAGE' 'DEF:probe3=/data/rrd/zen_1d.rrd:fr-zen:AVERAGE' 'LINE1:probe1#35b73d:Irish Servers' 'LINE1:probe2#0400ff:Swedish Servers' 'LINE1:probe3#ff0000:French Servers' -W "Sungard Availability Services" -s now-2m -e now
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,marc.mooney@sungardas.com,andrew.philp@sungardas.com" -s "European Asset Report on $DAY" -a $SARRDGRAPH -a $ZNRRDGRAPH -a $SARRDGRAPHM -a $ZNRRDGRAPHM -a $SACUSTFILE < $HTMAILFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "European Asset Report on $DAY" -a $SARRDGRAPH -a $ZNRRDGRAPH -a $SACUSTFILE < $HTMAILFILE
[[ $(date +%A) == Monday ]] && mutt -e 'set content_type="text/html"' "ann.wingard@sungardas.com,martin.johansson@sungardas.com,gary.watson@sungardas.com,paul.higgins@sungardas.com,paul.ferguson@sungardas.com" -s "European Asset Report on $DAY" -a $SARRDGRAPH -a $ZNRRDGRAPH -a $SARRDGRAPHM -a $ZNRRDGRAPHM -a $SACUSTFILE < $HTMAILFILE
