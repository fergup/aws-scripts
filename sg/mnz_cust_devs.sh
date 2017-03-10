#!/bin/bash
###################################################################################
#
# tc2_tc3_devs.sh
# ---------------
# Exports Service Center data for TC2 and TC3 and sends it to Keith Murphy in TC2
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 09/12/15 |  PRF   | First edition
# ---------------------------------------------------------------------------------
#
###################################################################################
# Set variables
SCFILE=/data/sc-sasu-mnz.txt
DATE=$(date +%d%m%Y)
USCFILE=/data/mnz_sg_cmdb_$DATE.csv
MAILFILE=/data/mnz_mail
DATEM=$(date +%d" "%B" "%Y)
# Do stuff
head -1 $SCFILE > $USCFILE
sort -uk1,1 $SCFILE >> $USCFILE 2>/dev/null
sed -i 's/\t/,/g' $USCFILE 
echo "Weekly SungardAS Menzies CMDB export enclosed" >$MAILFILE
# Send emails
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "### Weekly Menzies CMDB export $DATEM ###" -a $USCFILE < $MAILFILE
# Tidy up
mv $USCFILE /data/archive
