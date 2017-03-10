#!/bin/bash
# Script to tell you how many Irish devices are in HPSA
FILE=/data/hpsa_servers.csv
IEFILE=/data/hpsa_servers_ie.csv
IEMAIL=/data/irish_mail
IECUSTF=/data/irish_customers
cat $FILE |sort|uniq|awk -F, '($4=="IE:Dublin.005") { print $0 }' > $IEFILE
IE=$(cat $IEFILE|sort|uniq|wc -l)
cat $IEFILE |sort|uniq|awk -F, '{ print $3 }' |python /usr/local/bin/namescount.py|sort -nr > $IEMAIL
mutt "paul.ferguson@sungardas.com,andrew.philp@sungardas.com" -s "There are $IE Irish servers in HPSA" -a $IEFILE < $IEMAIL
#mutt "paul.ferguson@sungardas.com" -s "There are $IE Irish servers in HPSA" -a $IEFILE < $IEMAIL
