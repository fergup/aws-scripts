#!/bin/bash
# Run report for US TOC showing which devices have been changed from 'Pending' to 'Active' overnight
# Variables
DATE=$(date +%d/%m/%Y)
SCYEAR=/data/sc-updated-year.tsv
SCYEST=/data/sc-updated-yest.tsv
SCYESTSAV=/data/sc-updated-yest.$DATE.tsv
MAILFILE=/data/mail/toc_update
SERVERS=$(awk -F'\t' '($21~"server") { print $0 }' $SCYEAR|wc -l)
SERVERSIA=$(awk -F'\t' '($21~"server")&&($19~"Installed-Active") { print $0 }' $SCYEAR|wc -l)
SERVERSAD=$(awk -F'\t' '($21~"server") { print $0 }' $SCYEST|wc -l)
# Do stuff
newserv() {
for HOST in $(awk -F'\t' '($21~"server")&&($19~"Pending") { print $1  }' $SCYEAR |sed '/^$/d')
	do
	grep -w $HOST $SCYEST |awk  -F'\t' '($19~"Installed-Active")&&($21~"server") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$12"</td><td>"$21"</td><td>"$23"</td></tr><br>" }'
done 
}
remserv() {
for HOST in $(awk -F'\t' '($21~"server")&&($19!~"Removed") { print $1 }' $SCYEAR |sed '/^$/d'|sort|uniq)
        do
        grep -w $HOST $SCYEST |awk  -F'\t' '($19~"Removed")&&($21~"server") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$12"</td><td>"$21"</td><td>"$23"</td></tr><br>" }'
done
}
SERVERSNEW=`newserv |wc -l 2>/dev/null`
SERVERSREM=$(remserv |sort|uniq|wc -l 2>/dev/null)
NETWORK=$(awk -F'\t' '($21~"router|switch|firewall|loadbalancer") { print $0 }' $SCYEAR|wc -l)
NETWORKIA=$(awk -F'\t' '($21~"router|switch|firewall|loadbalancer")&&($19~"Installed-Active") { print $0 }' $SCYEAR|wc -l)
NETWORKAD=$(awk -F'\t' '($21~"router|switch|firewall|loadbalancer") { print $0 }' $SCYEST|wc -l)
# Do stuff
newnet() {
for HOST in $(awk -F'\t' '($21~"router|switch|firewall|loadbalancer")&&($19~"Pending") { print $1  }' $SCYEAR |sed '/^$/d')
	do
	grep -w $HOST $SCYEST |awk  -F'\t' '($19~"Installed-Active")&&($21~"router|switch|firewall|loadbalancer") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$12"</td><td>"$21"</td><td>"$23"</td></tr><br>" }'
done 
}
remnet() {
for HOST in $(awk -F'\t' '($21~"router|switch|firewall|loadbalancer")&&($19!~"Removed") { print $1 }' $SCYEAR |sed '/^$/d'|sort|uniq)
        do
        grep -w $HOST $SCYEST |awk  -F'\t' '($19~"Removed")&&($21~"router|switch|firewall|loadbalancer") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$12"</td><td>"$21"</td><td>"$23"</td></tr><br>" }'
done
}
NETWORKNEW=`newnet |wc -l 2>/dev/null`
NETWORKREM=$(remnet |sort|uniq|wc -l 2>/dev/null)
STORAGE=$(awk -F'\t' '($21~"san") { print $0 }' $SCYEAR|wc -l)
STORAGEIA=$(awk -F'\t' '($21~"san")&&($19~"Installed-Active") { print $0 }' $SCYEAR|wc -l)
STORAGEAD=$(awk -F'\t' '($21~"san") { print $0 }' $SCYEST|wc -l)
# Do stuff
newstor() {
for HOST in $(awk -F'\t' '($21~"san")&&($19~"Pending") { print $1  }' $SCYEAR |sed '/^$/d')
        do
        grep -w $HOST $SCYEST |awk  -F'\t' '($19~"Installed-Active")&&($21~"san") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$12"</td><td>"$21"</td><td>"$23"</td></tr><br>" }'
done
}
remstor() {
for HOST in $(awk -F'\t' '($21~"san")&&($19!~"Removed") { print $1 }' $SCYEAR |sed '/^$/d'|sort|uniq)
        do
        grep -w $HOST $SCYEST |awk  -F'\t' '($19~"Removed")&&($21~"san") { print "<tr><td>"$1"</td><td>"$9"</td><td>"$12"</td><td>"$21"</td><td>"$23"</td></tr><br>" }'
done
}
STORAGENEW=`newstor |wc -l 2>/dev/null`
STORAGEREM=$(remstor |sort|uniq|wc -l 2>/dev/null)
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
# Send me mail
mutt  -e 'set content_type="text/html"' "as.toc.mgmt@sungardas.com,paul.ferguson@sungardas.com,pushkar.shirolkar@sungardas.com,jan.clayton-adamson@sungardas.com,kevin.erickson@sungardas.com" -s "TOC daily report" < $MAILFILE
# Archive
cp $SCYEST $SCYESTSAV
