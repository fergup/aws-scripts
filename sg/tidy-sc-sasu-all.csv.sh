#!/bin/bash
#Tidying Up Service Center Export
SCFILENAME=/data/sc-sasu-all.csv

# Firstly we only care about Installed-Active devices and a few of the columns
grep Installed-Active ${SCFILENAME} | awk -F, '{ print $1","$2","$9 }' > /tmp/sc-sasu-all.tmp

awk -F, '{
if ($1 =="") print "NULL"; else print $1;
if ($2 =="") print "NULL"; else print $2;
}' /tmp/sc-sasu-all.tmp

