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
SCFILE=/data/sc-sasu-all.txt
EXPORT=/data/tc2_dev.tsv
MAILFILE=/data/mail/tc2.mail
DATE=$(date +%d%m%Y)
DATEM=$(date +%d" "%B" "%Y)
# Do stuff
head -1 $SCFILE > $EXPORT
awk -F'\t' '($12~"LONDON.001")||($12~"WOKING.001") { print }' $SCFILE >> $EXPORT
# Send emails
mutt -e 'set content_type="text/html"' "keith.murphy@sungardas.com,paul.ferguson@sungardas.com" -s "### TC2 / TC3 device export $DATEM ###" -a $EXPORT < $MAILFILE
# Tidy up
#rm $EXPORT
