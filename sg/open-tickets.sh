#!/bin/bash
# Script to generate daily 'open tickets' report for Paul Higgins's reports
# Set variables

RRDDATE=$(date +%m/%d/%Y" "%H:%M)
#RRDDATE="04/14/2015 10:00"
GRAPHALL=/data/images/open-all.png
GRAPHUK=/data/images/open-uk.png
GRAPHSE=/data/images/open-se.png
GRAPHIE=/data/images/open-ie.png
GRAPHMS=/data/images/open-ms.png
RRDFILE=/data/rrd/sn_open.rrd
TIX=/data/sn/EuropeanXOpenXIncidentsXPFXExport.csv
GROUPS=/tmp/groups
OPENMAILFILE=/data/mail/openmail
printf "IE Backups (Marc Mooney)
IE Cloud Hosting Platform (Chris Nicholson)
IE DUB SCC (Marc Mooney)
IE Managed Servers and Storage (Keith Moran)
IE Network Support (Mike McCormack)
IE Projects (Marc Mooney)
OSS Tools (Patrick Bays)
PL Workplace WRO (Alina Binkowska)
SE Infrastructure (Mathias Sundman)
SE Managed Services (Mathias Sundman)
SE Network Engineering (Mathias Sundman)
SE Recovery Services (Mathias Sundman)
SE Service Desk (Mathias Sundman)
SE Sweden Support (Mathias Sundman)
TOC - Network Tier 1 (Jan Clayton-Adamson)
UK Change Approval - Serv&Stor (Paul Ferguson)
UK Core Functions (Omar White)
UK DC Ops Team Leaders (Ryan Bell)
UK Enterprise Cloud Services (Simon Wagstaff)
UK Managed Servers STORAGE (Laura Fitzpatrick)
UK Managed Servers UNIX (Jonathan Montgomery)
UK Managed Servers WINDOWS (Malcolm Rhodes)
UK Network Engineering (Garith Wilson)
UK Network Support CHG and REQ (Stephen Hughes)
UK Network Support Incident (Stephen Hughes)
UK Network Support (Nigel Harris)
UK NOC LTC (Nigel Harris)
UK Security LIV (Jacqueline Rhodes)
UK TC2 SCC (Keith Murphy)
UK TC4 SCC (Stu Welsby)
UK TeleVault Pune (Sanjay Deshpande)
UK Tools Monitoring and Management (Paul Ferguson)
UK Tools Support (Paul Ferguson)
UK Unix Engineering (Paul Ferguson)
UK Vaulting 1 (Geetha Purushothaman)
UK Vaulting 2 (Sanjay Deshpande)
UK Vaulting (Darren Adcock)
UK Windows Engineering (Paul Labbett)
UK Workplace BRI (Andy Hurley)
UK Workplace CRC (Mark Kelly)
UK Workplace DRC (Mark Kelly)
UK Workplace ELL (Stu Welsby)
UK Workplace LIV (Ian Crighton)" > $GROUPS
# Set the $IFS value so the echoing out of the file with the groups in it doesn't delimit on the spaces in the lines
IFS='
'
RRDVAR=0
RRDVARS=$(for GROUP in $(<$GROUPS)
        do
	VAR=$(egrep 'Pushkar|"Paul Higgins"' /data/sn/EuropeanXOpenXIncidentsXPFXExport.csv|grep -v Resolved|awk -F',"' '{ print $10" ("$19")" }'|sed 's/"//g' |sort|uniq -c|grep -w "$GROUP"|awk '{ print $1}')
	[[ -z $VAR ]] && VAR=0 
	printf $VAR:
done)
echo "Tickets | Assignment Group (Owner)" > $OPENMAILFILE
egrep 'Pushkar|"Paul Higgins"' /data/sn/EuropeanXOpenXIncidentsXPFXExport.csv|grep -v Resolved|awk -F',"' '{ print $10" ("$19")" }'|sed 's/"//g' |sort|uniq -c |sort -rn >> $OPENMAILFILE
RRDVARS1=$(echo $RRDVARS|rev |cut -c 2- |rev)
rrdtool update $RRDFILE $RRDDATE@$RRDVARS1
rrdtool graph $GRAPHALL -a PNG --title="Open Tickets (week)"  --vertical-label "Tickets" 'DEF:probe1=/data/rrd/sn_open.rrd:ie-backups:AVERAGE' 'DEF:probe2=/data/rrd/sn_open.rrd:ie-cloud:AVERAGE' 'DEF:probe3=/data/rrd/sn_open.rrd:ie-dub:AVERAGE' 'DEF:probe4=/data/rrd/sn_open.rrd:ie-mss:AVERAGE' 'DEF:probe5=/data/rrd/sn_open.rrd:ie-net:AVERAGE' 'DEF:probe6=/data/rrd/sn_open.rrd:ie-proj:AVERAGE' 'DEF:probe7=/data/rrd/sn_open.rrd:oss-tools:AVERAGE' 'DEF:probe8=/data/rrd/sn_open.rrd:pl-wor:AVERAGE' 'DEF:probe9=/data/rrd/sn_open.rrd:se-inf:AVERAGE' 'DEF:probe10=/data/rrd/sn_open.rrd:se-net:AVERAGE' 'DEF:probe11=/data/rrd/sn_open.rrd:se-rec:AVERAGE' 'DEF:probe12=/data/rrd/sn_open.rrd:se-sd:AVERAGE' 'DEF:probe13=/data/rrd/sn_open.rrd:se-swesu:AVERAGE' 'DEF:probe14=/data/rrd/sn_open.rrd:toc:AVERAGE' 'DEF:probe15=/data/rrd/sn_open.rrd:uk-chg:AVERAGE' 'DEF:probe16=/data/rrd/sn_open.rrd:uk-core:AVERAGE' 'DEF:probe17=/data/rrd/sn_open.rrd:uk-dcops:AVERAGE' 'DEF:probe18=/data/rrd/sn_open.rrd:uk-entcloud:AVERAGE' 'DEF:probe19=/data/rrd/sn_open.rrd:uk-mss-stor:AVERAGE' 'DEF:probe20=/data/rrd/sn_open.rrd:uk-mss-unix:AVERAGE' 'DEF:probe21=/data/rrd/sn_open.rrd:uk-mss-win:AVERAGE' 'DEF:probe22=/data/rrd/sn_open.rrd:uk-net-eng:AVERAGE' 'DEF:probe23=/data/rrd/sn_open.rrd:uk-net-chg:AVERAGE' 'DEF:probe24=/data/rrd/sn_open.rrd:uk-net-inc:AVERAGE' 'DEF:probe25=/data/rrd/sn_open.rrd:uk-net-sup:AVERAGE' 'DEF:probe26=/data/rrd/sn_open.rrd:uk-noc-ltc:AVERAGE' 'DEF:probe27=/data/rrd/sn_open.rrd:uk-sec-liv:AVERAGE' 'DEF:probe28=/data/rrd/sn_open.rrd:uk-tc2:AVERAGE' 'DEF:probe29=/data/rrd/sn_open.rrd:uk-tc4:AVERAGE' 'DEF:probe30=/data/rrd/sn_open.rrd:uk-tv-pune:AVERAGE' 'DEF:probe31=/data/rrd/sn_open.rrd:uk-tools-mon:AVERAGE' 'DEF:probe32=/data/rrd/sn_open.rrd:uk-tools-sup:AVERAGE' 'DEF:probe33=/data/rrd/sn_open.rrd:uk-unix-eng:AVERAGE' 'DEF:probe34=/data/rrd/sn_open.rrd:uk-vault1:AVERAGE' 'DEF:probe35=/data/rrd/sn_open.rrd:uk-vault2:AVERAGE' 'DEF:probe36=/data/rrd/sn_open.rrd:uk-vault3:AVERAGE' 'DEF:probe37=/data/rrd/sn_open.rrd:uk-win-eng:AVERAGE' 'DEF:probe38=/data/rrd/sn_open.rrd:uk-wor-bri:AVERAGE' 'DEF:probe39=/data/rrd/sn_open.rrd:uk-wor-crc:AVERAGE' 'DEF:probe40=/data/rrd/sn_open.rrd:uk-wor-drc:AVERAGE' 'DEF:probe41=/data/rrd/sn_open.rrd:uk-wor-ell:AVERAGE' 'DEF:probe42=/data/rrd/sn_open.rrd:uk-wor-liv:AVERAGE' 'LINE1:probe1#ffcc99:IE Backups' 'LINE1:probe2#000000:IE Cloud Hosting Platform' 'LINE1:probe3#0000ff:IE DUB SCC' 'LINE1:probe4#0033cc:IE Managed Servers and Storage' 'LINE1:probe5#006699:IE Network Support' 'LINE1:probe6#009966:IE Projects' 'LINE1:probe7#00cc33:OSS Tools' 'LINE1:probe8#00ff00:PL Workplace WRO' 'LINE1:probe9#00ffff:SE Infrastructure' 'LINE1:probe10#3300cc:SE Network Engineering' 'LINE1:probe11#333399:SE Recovery Services' 'LINE1:probe12#336666:SE Service Desk' 'LINE1:probe13#339933:SE Sweden Support' 'LINE1:probe14#33ccff:TOC - Network Tier 1' 'LINE1:probe15#33ffcc:UK Change Approval - Serv&Stor' 'LINE1:probe16#660099:UK Core Functions' 'LINE1:probe17#663366:UK DC Ops Team Leaders' 'LINE1:probe18#666633:UK Enterprise Cloud Services' 'LlNE1:probe19#669900:UK Managed Servers STORAGE' 'LINE1:probe20#6699ff:UK Managed Servers UNIX' 'LINE1:probe21#66cccc:UK Managed Servers WINDOWS' 'LINE1:probe22#66ff99:UK Network Engineering' 'LINE1:probe23#990066:UK Network Support CHG and REQ' 'LINE1:probe24#993333:UK Network Support Incident' 'LINE1:probe25#996600:UK Network Support' 'LINE1:probe26#9966ff:UK NOC LTC' 'LINE1:probe27#9999cc:UK Security LIV' 'LINE1:probe28#99cc99:UK TC2 SCC' 'LINE1:probe29#99ff66:UK TC4 SCC' 'LINE1:probe30#cc0033:UK TeleVault Pune' 'LINE1:probe31#cc3300:UK Tools Monitoring and Management' 'LINE1:probe32#cc33ff:UK Tools Support' 'LINE1:probe33#cc66cc:UK Unix Engineering' 'LINE1:probe34#cc9999:UK Vaulting 1' 'LINE1:probe35#cccc66:UK Vaulting 2' 'LINE1:probe36#ccff33:UK Vaulting' 'LINE1:probe37#ff0000:UK Windows Engineering' 'LINE1:probe38#ff00ff:UK Workplace BRI' 'LINE1:probe39#ff33cc:UK Workplace CRC' 'LINE1:probe40#ff6699:UK Workplace DRC' 'LINE1:probe41#ff9966:UK Workplace ELL' 'LINE1:probe42#ffcc33:UK Workplace LIV' -s now-1w -e now
rrdtool graph $GRAPHUK -a PNG --title="UK Open Tickets (week)"  --vertical-label "Tickets" 'DEF:probe15=/data/rrd/sn_open.rrd:uk-chg:AVERAGE' 'DEF:probe16=/data/rrd/sn_open.rrd:uk-core:AVERAGE' 'DEF:probe17=/data/rrd/sn_open.rrd:uk-dcops:AVERAGE' 'DEF:probe18=/data/rrd/sn_open.rrd:uk-entcloud:AVERAGE' 'DEF:probe19=/data/rrd/sn_open.rrd:uk-mss-stor:AVERAGE' 'DEF:probe20=/data/rrd/sn_open.rrd:uk-mss-unix:AVERAGE' 'DEF:probe21=/data/rrd/sn_open.rrd:uk-mss-win:AVERAGE' 'DEF:probe22=/data/rrd/sn_open.rrd:uk-net-eng:AVERAGE' 'DEF:probe23=/data/rrd/sn_open.rrd:uk-net-chg:AVERAGE' 'DEF:probe24=/data/rrd/sn_open.rrd:uk-net-inc:AVERAGE' 'DEF:probe25=/data/rrd/sn_open.rrd:uk-net-sup:AVERAGE' 'DEF:probe26=/data/rrd/sn_open.rrd:uk-noc-ltc:AVERAGE' 'DEF:probe27=/data/rrd/sn_open.rrd:uk-sec-liv:AVERAGE' 'DEF:probe28=/data/rrd/sn_open.rrd:uk-tc2:AVERAGE' 'DEF:probe29=/data/rrd/sn_open.rrd:uk-tc4:AVERAGE' 'DEF:probe30=/data/rrd/sn_open.rrd:uk-tv-pune:AVERAGE' 'DEF:probe31=/data/rrd/sn_open.rrd:uk-tools-mon:AVERAGE' 'DEF:probe32=/data/rrd/sn_open.rrd:uk-tools-sup:AVERAGE' 'DEF:probe33=/data/rrd/sn_open.rrd:uk-unix-eng:AVERAGE' 'DEF:probe34=/data/rrd/sn_open.rrd:uk-vault1:AVERAGE' 'DEF:probe35=/data/rrd/sn_open.rrd:uk-vault2:AVERAGE' 'DEF:probe36=/data/rrd/sn_open.rrd:uk-vault3:AVERAGE' 'DEF:probe37=/data/rrd/sn_open.rrd:uk-win-eng:AVERAGE' 'DEF:probe38=/data/rrd/sn_open.rrd:uk-wor-bri:AVERAGE' 'DEF:probe39=/data/rrd/sn_open.rrd:uk-wor-crc:AVERAGE' 'DEF:probe40=/data/rrd/sn_open.rrd:uk-wor-drc:AVERAGE' 'DEF:probe41=/data/rrd/sn_open.rrd:uk-wor-ell:AVERAGE' 'DEF:probe42=/data/rrd/sn_open.rrd:uk-wor-liv:AVERAGE' 'LINE1:probe15#33ffcc:UK Change Approval - Serv&Stor' 'LINE1:probe16#660099:UK Core Functions' 'LINE1:probe17#663366:UK DC Ops Team Leaders' 'LINE1:probe18#666633:UK Enterprise Cloud Services' 'LINE1:probe19#669900:UK Managed Servers STORAGE' 'LINE1:probe20#6699ff:UK Managed Servers UNIX' 'LINE1:probe21#66cccc:UK Managed Servers WINDOWS' 'LINE1:probe22#66ff99:UK Network Engineering' 'LINE1:probe23#990066:UK Network Support CHG and REQ' 'LINE1:probe24#993333:UK Network Support Incident' 'LINE1:probe25#996600:UK Network Support' 'LINE1:probe26#9966ff:UK NOC LTC' 'LINE1:probe27#9999cc:UK Security LIV' 'LINE1:probe28#99cc99:UK TC2 SCC' 'LINE1:probe29#99ff66:UK TC4 SCC' 'LINE1:probe30#cc0033:UK TeleVault Pune' 'LINE1:probe31#cc3300:UK Tools Monitoring and Management' 'LINE1:probe32#cc33ff:UK Tools Support' 'LINE1:probe33#cc66cc:UK Unix Engineering' 'LINE1:probe34#cc9999:UK Vaulting 1' 'LINE1:probe35#cccc66:UK Vaulting 2' 'LINE1:probe36#ccff33:UK Vaulting' 'LINE1:probe37#ff0000:UK Windows Engineering' 'LINE1:probe38#ff00ff:UK Workplace BRI' 'LINE1:probe39#ff33cc:UK Workplace CRC' 'LINE1:probe40#ff6699:UK Workplace DRC' 'LINE1:probe41#ff9966:UK Workplace ELL' 'LINE1:probe42#ffcc33:UK Workplace LIV' -s now-1w -e now
rrdtool graph $GRAPHMS -a PNG --title="Managed Services Open Ticket (week)"  --vertical-label "Tickets" 'DEF:probe18=/data/rrd/sn_open.rrd:uk-entcloud:AVERAGE' 'DEF:probe19=/data/rrd/sn_open.rrd:uk-mss-stor:AVERAGE' 'DEF:probe20=/data/rrd/sn_open.rrd:uk-mss-unix:AVERAGE' 'DEF:probe21=/data/rrd/sn_open.rrd:uk-mss-win:AVERAGE' 'DEF:probe22=/data/rrd/sn_open.rrd:uk-net-eng:AVERAGE' 'DEF:probe23=/data/rrd/sn_open.rrd:uk-net-chg:AVERAGE' 'DEF:probe24=/data/rrd/sn_open.rrd:uk-net-inc:AVERAGE' 'DEF:probe25=/data/rrd/sn_open.rrd:uk-net-sup:AVERAGE'  'DEF:probe31=/data/rrd/sn_open.rrd:uk-tools-mon:AVERAGE' 'DEF:probe32=/data/rrd/sn_open.rrd:uk-tools-sup:AVERAGE' 'DEF:probe33=/data/rrd/sn_open.rrd:uk-unix-eng:AVERAGE' 'DEF:probe37=/data/rrd/sn_open.rrd:uk-win-eng:AVERAGE'  'LINE1:probe18#666633:UK Enterprise Cloud Services' 'LINE1:probe19#669900:UK Managed Servers STORAGE' 'LINE1:probe20#6699ff:UK Managed Servers UNIX' 'LINE1:probe21#66cccc:UK Managed Servers WINDOWS' 'LINE1:probe22#66ff99:UK Network Engineering' 'LINE1:probe23#990066:UK Network Support CHG and REQ' 'LINE1:probe24#993333:UK Network Support Incident' 'LINE1:probe25#996600:UK Network Support'  'LINE1:probe31#cc3300:UK Tools Monitoring and Management' 'LINE1:probe32#cc33ff:UK Tools Support' 'LINE1:probe33#cc66cc:UK Unix Engineering' 'LINE1:probe37#ff0000:UK Windows Engineering'  -s now-1w -e now
rrdtool graph $GRAPHIE -a PNG --title="Ireland Open Tickets (week)"  --vertical-label "Tickets" 'DEF:probe1=/data/rrd/sn_open.rrd:ie-backups:AVERAGE' 'DEF:probe2=/data/rrd/sn_open.rrd:ie-cloud:AVERAGE' 'DEF:probe3=/data/rrd/sn_open.rrd:ie-dub:AVERAGE' 'DEF:probe4=/data/rrd/sn_open.rrd:ie-mss:AVERAGE' 'DEF:probe5=/data/rrd/sn_open.rrd:ie-net:AVERAGE' 'DEF:probe6=/data/rrd/sn_open.rrd:ie-proj:AVERAGE' 'LINE1:probe1#000000:IE Cloud Hosting Platform' 'LINE1:probe2#0000ff:IE DUB SCC' 'LINE1:probe3#0033cc:IE Managed Servers and Storage' 'LINE1:probe4#006699:IE Network Support' 'LINE1:probe5#009966:IE Projects' -s now-1w -e now
rrdtool graph $GRAPHSE -a PNG --title="Sweden Open Tickets (week)"  --vertical-label "Tickets"  'DEF:probe8=/data/rrd/sn_open.rrd:pl-wor:AVERAGE' 'DEF:probe9=/data/rrd/sn_open.rrd:se-inf:AVERAGE' 'DEF:probe10=/data/rrd/sn_open.rrd:se-net:AVERAGE' 'DEF:probe11=/data/rrd/sn_open.rrd:se-rec:AVERAGE' 'DEF:probe12=/data/rrd/sn_open.rrd:se-sd:AVERAGE' 'DEF:probe13=/data/rrd/sn_open.rrd:se-swesu:AVERAGE' 'LINE1:probe8#00ffff:SE Infrastructure' 'LINE1:probe9#3300cc:SE Managed Services' 'LINE1:probe10#333399:SE Network Engineering' 'LINE1:probe11#336666:SE Recovery Services' 'LINE1:probe12#339933:SE Service Desk' 'LINE1:probe13#33cc00:SE Sweden Support' -s now-1w -e now
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "Open Tickets $RRDDATE" -a $GRAPHALL -a $GRAPHUK -a $GRAPHMS -a $GRAPHIE -a $GRAPHSE < $OPENMAILFILE
#mutt "paul.ferguson@sungardas.com,ryan.bell@sungardas.com" -s "Open Tickets $RRDDATE"  < $OPENMAILFILE
