#!/bin/bash
###################################################################################
#
# menzies_report.sh
# -----------------
# Reports on daily changes to the Menzies managed estate
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 27/10/15 |  PRF   | First edition
# |   1.1   | 11/01/16 |  PRF   | Added Aviation 'heat' import
# ---------------------------------------------------------------------------------
#
###################################################################################
# Set variables
DATE=$(date +%d/%m/%Y)
SAVDATE=$(date +%d%m%Y)
RRDDATE=$(date +%m/%d/%Y" "%H:%M)
SCYEAR=/data/sc-updated-year.tsv
SCYEST=/data/sc-updated-yest.tsv
SCYESTSAV=/data/sc-updated-yest.$SAVDATE.tsv 
SCFILE=/data/sc-sasu-all.txt
HPSA=/data/hpsa_servers.csv
ZENOSS=$(ls -atr /data/uk-zenoss* |tail -1)
SNUSERS=/data/sn/MenziesXUsers.csv
MNZINC=/data/sn/MenziesXDailyXReport.csv
MAILFILE=/data/mail/menzies_report
MAILFILEYEST=/data/mail/menzies_report_yest
RRDFILE=/data/rrd/menzies_tracker.rrd
#HEATXLS=/data/menzies/Sungard-1.xls
HEATXLS=/data/sn/Sungard_Menzies_Incident.xls
HEATCSV=/data/menzies/menzies-heat-$SAVDATE.csv
ARCHIVE=/data/archive
SERVERS=$(awk -F'\t' '($21~"server")&&($9~"MENZIES") { print $0 }' $SCYEAR|wc -l)
SERVERSIA=$(awk -F'\t' '($21~"server")&&($19~"Installed-Active")&&($9~"MENZIES") { print $0 }' $SCYEAR|wc -l)
SERVERSAD=$(awk -F'\t' '($21~"server")&&($9~"MENZIES") { print $0 }' $SCYEST|wc -l)
# Do stuff
cp $MAILFILE $MAILFILEYEST  # Copy away the previous mail file for comparison purposes
newserv() {
for HOST in $(awk -F'\t' '($21~"server")&&($19~"Pending")&&($9~"MENZIES") { print $1  }' $SCYEAR |sed '/^$/d')
	do
	grep -w $HOST $SCYEST |awk  -F'\t' '($19~"Installed-Active")&&($21~"server")&&($9~"MENZIES") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$12"</td><td>"$21"</td><td>"$23"</td></tr><br>" }'
done 
}
remserv() {
for HOST in $(awk -F'\t' '($21~"server")&&($19!~"Removed")&&($9~"MENZIES") { print $1 }' $SCYEAR |sed '/^$/d'|sort|uniq)
        do
        grep -w $HOST $SCYEST |awk  -F'\t' '($19~"Removed")&&($21~"server")&&($9~"MENZIES") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$12"</td><td>"$21"</td><td>"$23"</td></tr><br>" }'
done
}
SERVERSNEW=`newserv |wc -l 2>/dev/null`
SERVERSREM=$(remserv |sort|uniq|wc -l 2>/dev/null)
NETWORK=$(awk -F'\t' '($21~"router|switch|firewall|loadbalancer")&&($9~"MENZIES") { print $0 }' $SCYEAR|wc -l)
NETWORKIA=$(awk -F'\t' '($21~"router|switch|firewall|loadbalancer")&&($19~"Installed-Active")&&($9~"MENZIES") { print $0 }' $SCYEAR|wc -l)
NETWORKAD=$(awk -F'\t' '($21~"router|switch|firewall|loadbalancer")&&($9~"MENZIES") { print $0 }' $SCYEST|wc -l)
# Do stuff
newnet() {
for HOST in $(awk -F'\t' '($21~"router|switch|firewall|loadbalancer")&&($19~"Pending")&&($9~"MENZIES") { print $1  }' $SCYEAR |sed '/^$/d')
	do
	grep -w $HOST $SCYEST |awk  -F'\t' '($19~"Installed-Active")&&($21~"router|switch|firewall|loadbalancer")&&($9~"MENZIES") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$12"</td><td>"$21"</td><td>"$23"</td></tr><br>" }'
done 
}
remnet() {
for HOST in $(awk -F'\t' '($21~"router|switch|firewall|loadbalancer")&&($19!~"Removed")&&($9~"MENZIES") { print $1 }' $SCYEAR |sed '/^$/d'|sort|uniq)
        do
        grep -w $HOST $SCYEST |awk  -F'\t' '($19~"Removed")&&($21~"router|switch|firewall|loadbalancer")&&($9~"MENZIES") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$12"</td><td>"$21"</td><td>"$23"</td></tr><br>" }'
done
}
NETWORKNEW=`newnet |wc -l 2>/dev/null`
NETWORKREM=$(remnet |sort|uniq|wc -l 2>/dev/null)
STORAGE=$(awk -F'\t' '($21~"san")&&($9~"MENZIES") { print $0 }' $SCYEAR|wc -l)
STORAGEIA=$(awk -F'\t' '($21~"san")&&($19~"Installed-Active")&&($9~"MENZIES") { print $0 }' $SCYEAR|wc -l)
STORAGEAD=$(awk -F'\t' '($21~"san")&&($9~"MENZIES") { print $0 }' $SCYEST|wc -l)
# Do stuff
newstor() {
for HOST in $(awk -F'\t' '($21~"san")&&($19~"Pending")&&($9~"MENZIES") { print $1  }' $SCYEAR |sed '/^$/d')
        do
        grep -w $HOST $SCYEST |awk  -F'\t' '($19~"Installed-Active")&&($21~"san")&&($9~"MENZIES") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$12"</td><td>"$21"</td><td>"$23"</td></tr><br>" }'
done
}
remstor() {
for HOST in $(awk -F'\t' '($21~"san")&&($19!~"Removed")&&($9~"MENZIES") { print $1 }' $SCYEAR |sed '/^$/d'|sort|uniq)
        do
        grep -w $HOST $SCYEST |awk  -F'\t' '($19~"Removed")&&($21~"san")&&($9~"MENZIES") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$12"</td><td>"$21"</td><td>"$23"</td></tr><br>" }'
done
}
STORAGENEW=`newstor |wc -l 2>/dev/null`
STORAGEREM=$(remstor |sort|uniq|wc -l 2>/dev/null)
# Convert Heat file
xls2csv $HEATXLS > $HEATCSV
mv /data/sn/menzies-heat* $ARCHIVE
xls2csv $HEATXLS > $HEATCSV
# Update RRD files for graphs
#rrdtool update $RRDFILE "$RRDDATE@$INCMORE30:$INCMORE20:$INCMORE10:$INCIPDUMORE30:$INCIPDUMORE20:$INCIPDUMORE10"
heat() {
 echo "<table><tr><td>Owner</td><td>Service</td><td>Type</td><td>Summary</td><td>Priority</td><td>Country</td></tr>";sed '/^$/d' $HEATCSV |awk -F, '{ print "<tr><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$8"</td><td>"$9"</td><td>"$15"</td></tr>" }'   |grep -v "<tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>" |sed 's/"//g' |sort -n;echo "</table>" 
}
# Make tables
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
printf "<b>Service Now Incidents</b><br><span style='font-family:arial;text-align: center'><table border='1'>" >> $MAILFILE
awk -F'","' '{ print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$8"</td><td>"$9"</td><td>"$10"</td></tr>" }' $MNZINC  >> $MAILFILE
printf "</table><br>" >> $MAILFILE
echo "<br><b>Heat Tickets</b><br>" >> $MAILFILE
heat >> $MAILFILE
printf "<span style='font-family:arial;text-align: center'><table border='1'><tr><td width="600" colspan="6" bgcolor="FF9999"><b>Devices in Service Center</b></td></tr><tr><td width=100 bgcolor="FFBBBB"><b>Device type</b></td><td width=100 bgcolor="00EEFF"><b>Total</b></td><td width=100 bgcolor="00EEFF"><b>Installed-Active</b></td><td width=100 bgcolor="00EEFF"><b>Added today</b></td><td width=100 bgcolor="00EE22"><b>Installed-Active Today</b></td><td width=100 bgcolor="00EE22"><b>Removed Today</b></td></tr>" >> $MAILFILE
echo "<tr><td width=100><b>Servers</b></td><td width=100>$SERVERS</td><td width=100>$SERVERSIA</td><td width=100>$SERVERSAD</td><td width=100>$SERVERSNEW</td><td width=100>$SERVERSREM</td></tr>" >> $MAILFILE
echo "<tr><td width=100><b>Networking</b></td><td width=100>$NETWORK</td><td width=100>$NETWORKIA</td><td width=100>$NETWORKAD</td><td width=100>$NETWORKNEW</td><td width=100>$NETWORKREM</td></tr>" >> $MAILFILE
echo "<tr><td width=100><b>Storage</b></td><td width=100>$STORAGE</td><td width=100>$STORAGEIA</td><td width=100>$STORAGEAD</td><td width=100>$STORAGENEW</td><td width=100>$STORAGEREM</td></tr></table>" >> $MAILFILE
echo "<br><b>Newly 'Installed Active' devices</b><br>" >>  $MAILFILE
echo "<table><tr bgcolor="FFFF66"><b><td>Hostname</td><td>Customer</td><td>Location</td><td>Device Type</td><td>Owner</td></tr>" >> $MAILFILE
newserv >> $MAILFILE
newnet >> $MAILFILE
newstor >> $MAILFILE
echo "</table>" >> $MAILFILE
echo "<br><b>Newly 'Removed' devices</b><br>" >>  $MAILFILE
echo "<table><tr bgcolor="FFFF66"><b><td>Hostname</td><td>Customer</td><td>Location</td><td>Device Type</td><td>Owner</td></tr>" >> $MAILFILE
remserv |sort|uniq >> $MAILFILE
remnet |sort|uniq >> $MAILFILE
remstor |sort|uniq >> $MAILFILE
echo "</table>" >> $MAILFILE
# HPSA things
echo "<br><b>HPSA</b>" >> $MAILFILE
echo "<table><tr bgcolor="green"><b><td>Hostname</td><td>Customer</td><td>Location</td><td>OS</td><td>Added</td></tr>" >> $MAILFILE
awk -F'","' '($4~"Menzies") { print "<tr><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td></tr>" }' $HPSA  >> $MAILFILE
echo "</table>" >> $MAILFILE
# Zenoss things
echo "<br><b>Zenoss</b>" >> $MAILFILE
echo "<table><tr bgcolor="blue"><b><td>Hostname</td><td>Customer</td><td>Location</td><td>Device class</td></tr>" >> $MAILFILE
awk -F, '($14~"MENZIES") { print "<tr><td>"$2"</td><td>"$14"</td><td>"$15"</td><td>"$17"</td></tr>" }' $ZENOSS >> $MAILFILE
echo "</table>" >> $MAILFILE
# Service Now Users
echo "<br><b>Service Now Users</b>" >> $MAILFILE
echo "<table><tr bgcolor="pink"><b><td>Name</td><td>Customer</td><td>Date created</td><td>Created by</td></tr>" >> $MAILFILE
awk -F, '{ print "<tr><td>"$1"</td><td>"$2"</td><td>"$7"</td><td>"$10"</td></tr>" }' $SNUSERS >> $MAILFILE
echo "</table>" >> $MAILFILE
# Service Center devices
echo "<br><b>Service Center Devices</b>" >> $MAILFILE
echo "<table><tr bgcolor="orange"><b><td>Hostname</td><td>Customer</td><td>Type</td><td>Location</td><td>Date created</td><td>Created by</td></tr>" >> $MAILFILE
awk -F'\t' '($9~"MENZIES") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$21"</td><td>"$12"</td><td>"$22"</td><td>"$23"</td></tr>" }' $SCFILE >> $MAILFILE
echo "</table>" >> $MAILFILE
# Send me mail
#mutt  -e 'set content_type="text/html"' "paul.ferguson@sungardas.com"  -s "Menzies Status Change Report" < $MAILFILE
mutt  -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,ryan.bell@sungardas.com,andy.dickson@sungardas.com,ian.mitchell@sungardas.com,david.hart@sungardas.com,mayuri.patel@sungardas.com,phil.duncan@sungardas.com,stuart.brook@sungardas.com"  -s "Menzies Status Change Report" < $MAILFILE
# Archive
#cp $SCYEST $SCYESTSAV
