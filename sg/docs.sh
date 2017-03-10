#!/bin/bash
# Document tracker script
# Variables
DOCFILE=/data/sn/EuropeanXDocuments.csv
MAILFILE=/data/mail/docs.mail
RRDFILE=/data/rrd/docs.rrd
RRDGRAPH=/data/images/docs.png
RRDDATE=$(date +%m/%d/%Y" "%H:%M)
NUMDOCS=$(wc -l $DOCFILE|awk '{ print $1 }')
NUMCUSTS=$(awk -F, '{ print $9 }' $DOCFILE |sed 's/"SunGard\///g'|sed 's/"//g' |sort |uniq|wc -l)
NETDIAGS=$(awk -F, '($1~"Network Diagram") { print }' $DOCFILE |wc -l)
CUSTOVERS=$(awk -F, '($1~"Customer Overview") { print }' $DOCFILE |wc -l)
# Do stuff
rrdtool update $RRDFILE "$RRDDATE@$NUMDOCS:$NUMCUSTS:$NETDIAGS:$CUSTOVERS"
rrdtool graph $RRDGRAPH -a PNG --title="Documents in Service Now (Europe)" --vertical-label "Number of Documents" 'DEF:probe1=/data/rrd/docs.rrd:numdocs:AVERAGE' 'DEF:probe2=/data/rrd/docs.rrd:numcust:AVERAGE' 'DEF:probe3=/data/rrd/docs.rrd:netdiags:AVERAGE' 'DEF:probe4=/data/rrd/docs.rrd:custovers:AVERAGE' 'AREA:probe1#FF0000:Total Documents:STACK' 'AREA:probe2#00FF00:Number of Customers:STACK' 'AREA:probe3#0000FF:Network Diagrams:STACK' 'AREA:probe4#000000:Customer Overviews:STACK' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-1w -e now
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
echo "Total docs = $NUMDOCS
" >> $MAILFILE
awk -F, '{ print $9"<br>" }' $DOCFILE |sed 's/"SunGard\///g'|sed 's/"//g' |sort |uniq -c|sort -r >> $MAILFILE
echo "</body></html>" >> $MAILFILE
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "Daily document report - $NUMDOCS total"  -a $RRDGRAPH < $MAILFILE