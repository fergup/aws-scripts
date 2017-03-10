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
DATE=$(date +%d%m%Y)
MNZDIR=/data/menzies
SNUSERS=/data/sn/MenziesXUsers.csv
MNZINC=/data/sn/MenziesXDailyXReport.csv
MAILFILE=$MNZDIR/mnz-ticket-$DATE
#
# Set up functions
#
incidents() {
printf "<table><tr><td colspan=8 bgcolor=#C11B17><font color=white><b>Incidents</b></td></tr>" >> $MAILFILE
head -1 $MNZINC |awk -F, '{ print "<tr bgcolor=#C24641><font color=white><td>"$1"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$10"</td></tr>"}' >> $MAILFILE;  cat $MNZINC |awk -F, '($11~"Incident")&&($4!~"Closed|Resolved") { print "<tr><td>"$1"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$10"</td></tr>"}' >> $MAILFILE
printf "</table><br><br>" >> $MAILFILE
}
requests() {
printf "<table><tr><td bgcolor=#00EE22 colspan=8><b>Requests</b></td></tr>" >> $MAILFILE
head -1 $MNZINC |awk -F, '{ print "<tr bgcolor=#59FD61><td>"$1"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$10"</td></tr>"}' >> $MAILFILE;  cat $MNZINC |awk -F, '($11~"Requested Item")&&($4!~"Closed|Resolved") { print "<tr><td>"$1"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$10"</td></tr>"}' >> $MAILFILE
printf "</table><br><br>" >> $MAILFILE
}
changes() {
printf "<table><tr><td bgcolor=yellow colspan=11><b>Changes</b></td></tr>" >> $MAILFILE
head -1 $MNZINC |awk -F, '{ print "<tr bgcolor=#FFFF66><td>"$1"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$10"</td><td>"$15"</td><td>"$16"</td><td>"$17"</td></tr>"}' >> $MAILFILE;  cat $MNZINC |awk -F, '($11~"Change Request")&&($4!~"Closed|Resolved") { print "<tr><td>"$1"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$10"</td><td>"$15"</td><td>"$16"</td><td>"$17"</td></tr>"}' >> $MAILFILE
printf "</table><br><br>" >> $MAILFILE
}
#
# Do useful stuff
#
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
incidents
requests
changes
sed -i 's/"//g' $MAILFILE
# Send me mail
mutt  -e 'set content_type="text/html"' "paul.ferguson@sungardas.com"  -s "Menzies Daily Ticket Report" < $MAILFILE
#mutt  -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,ryan.bell@sungardas.com,andy.dickson@sungardas.com,ian.mitchell@sungardas.com,david.hart@sungardas.com,mayuri.patel@sungardas.com,phil.duncan@sungardas.com,stuart.brook@sungardas.com"  -s "Menzies Status Change Report" < $MAILFILE
# Archive
#cp $SCYEST $SCYESTSAV
