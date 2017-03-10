#!/bin/bash
###################################################################################
#
# archive.sh
# ----------
# Archives old input files and reports on MS tools and assets
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   0.1   | 23/01/15 |  PRF   | First edition
# ---------------------------------------------------------------------------------
#
###################################################################################
#
# Declare variables
#
###################################################################################
DATE=$(date +%Y%m%d)
DATADIR=/data
SNDIR=$DATADIR/sn
ARCHDIR=/data/archive
SNDIR=/data/sn
MAILDIR=/data/mail
SCIN=$DATADIR/sc-sasu-all.txt
SCOUT=$DATADIR/sc-sasu-all.csv
###################################################################################
#
# Do stuff
#
###################################################################################
find $DATADIR -ctime +2 -name "uk-zenoss-dump*" -exec mv {} $ARCHDIR \;  # move older Zenoss dumps to archive
find $DATADIR -ctime +2 -name "*.csv" -exec mv {} $ARCHDIR \;  # move older CSVs to archive
find $DATADIR -ctime +2 -name "*.tsv" -exec mv {} $ARCHDIR \;  # move older TSVs to archive
find $MAILDIR/* -ctime +2  -exec mv {} $ARCHDIR \;  # move older CSVs to archive
cp $SCIN $ARCHDIR/sc-sasu-all.$DATE.csv # copy the Service Center export
for FILE in $(ls $SNDIR/*.csv;ls $DATADIR/trin*.txt)
	do
	BASE=$(basename $FILE)
	cp $FILE $ARCHDIR/$BASE.$DATE
done
gzip -f $ARCHDIR/*.$DATE
gzip -f $ARCHDIR/*.csv
# NB - the HPSA export (hpsa_servers.csv) is automatically archived by the HPSA job itself
# Convert Service Center export for Steve D
cat $SCIN |sed 's/\t/,/g' > $SCOUT
# Clear reporting mail
>/var/mail/reporting
