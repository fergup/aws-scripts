#!/bin/bash
###################################################################################
#
# mnz_p1p2_phone.sh
# -----------------
# Calls Strategic Accoutns managers whenever a P1 or P2 ticket appears for Menzies
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 13/05/16 |  PRF   | First edition
# ---------------------------------------------------------------------------------
# 
# Improvement - fix it so it can deal with multiple tickets at once 21/06/2016
###################################################################################
# Set variables
#
TIXDIR=/data/sn
P1FILE=$TIXDIR/MenziesXP1XP2.csv
P1RESFILE=$TIXDIR/MenziesXP1XP2XResolved.csv
TIX=$(awk -F'","' '($7!~"Resolved")&&($7!~"Closed")&&($7!~"state") { print $3 }' $P1FILE)
PRI=$(tail -1 $P1FILE |awk -F'","' '{ print $6 }' |cut -c -1)
SUM=$(awk -F'","' '($7!~"Resolved")&&($7!~"Closed")&&($7!~"state") { print $5 }' $P1FILE)
OWN=$(awk -F'","' '($7!~"Resolved")&&($7!~"Closed")&&($7!~"state") { print $4 }' $P1FILE)
RESTIX=$(awk -F'","' '($8~"Resolved")&&($8!~"state") {print $2 }' $P1RESFILE)
RESSUM=$(tail -1 $P1RESFILE |awk -F'","' '($8~"Resolved")&&($8!~"state") {print $4 }')
RESOWN=$(tail -1 $P1RESFILE |awk -F'","' '($8~"Resolved")&&($8!~"state") {print $3 }')
[[ -z $TIX ]] && TIX=null # To populate the variable if there are no tickets
[[ -z $RESTIX ]] && RESTIX=null # To populate the variable if there are no tickets
[[ -z $OWN ]] && OWN=null # To populate the variable if there's no one assigned
[[ -z $RESOWN ]] && RESOWN=null # To populate the variable if there's no one assigned
CALLOUT=/data/strat/mnz_callout
CALLRES=/data/strat/mnz_resolved
#
# Set up a function to call out
#
call() {
curl -X POST -F 'FirstName=Paul' -F 'destination=07810853162' -F "message=Menzies have a new P1 or P2 ticket - $TIX" http://myfone.io/apiCall/02f95a87-1752-11e6-87b0-00163ebbe4b1
curl -X POST -F 'FirstName=Stuart' -F 'destination=07715634332' -F 'message=Menzies have a new P1 or P2 ticket' http://myfone.io/apiCall/02f95a87-1752-11e6-87b0-00163ebbe4b1
# Send emails
mutt "paul.ferguson@sungardas.com,stuart.brook@sungardas.com,ian.mitchell@sungardas.com,andrew.philp@sungardas.com" -s "!!! URGENT Menzies P${PRI} Ticket $TIX URGENT !!!" <$P1FILE
# Send SMS
curl -X POST -F 'FirstName=Paul' -F 'destination=+447810853162' -F "message=Menzies P${PRI} Incident $TIX logged with $OWN ($SUM)" http://myfone.io/apiSMS/02f95a87-1752-11e6-87b0-00163ebbe4b1
curl -X POST -F 'FirstName=Stuart' -F 'destination=+447715634332' -F "message=Menzies P${PRI} Incident $TIX logged with $OWN ($SUM)" http://myfone.io/apiSMS/02f95a87-1752-11e6-87b0-00163ebbe4b1
curl -X POST -F 'FirstName=Mayuri' -F 'destination=+447590049436' -F "message=Menzies P${PRI} Incident $TIX logged with $OWN ($SUM)" http://myfone.io/apiSMS/02f95a87-1752-11e6-87b0-00163ebbe4b1
curl -X POST -F 'FirstName=Julian' -F 'destination=+447595445088' -F "message=Menzies P${PRI} Incident $TIX logged with $OWN ($SUM)" http://myfone.io/apiSMS/02f95a87-1752-11e6-87b0-00163ebbe4b1
# P1 only
[[ $PRI == 1 ]] && curl -X POST -F 'FirstName=PaulS' -F 'destination=+447718511320' -F "message=Menzies P${PRI} Incident $TIX logged with $OWN ($SUM)" http://myfone.io/apiSMS/02f95a87-1752-11e6-87b0-00163ebbe4b1 && mutt "paul.stow@johnmenziesplc.com" -s "!!! URGENT Menzies P${PRI} Ticket $TIX URGENT !!!" <$P1FILE
[[ $PRI == 1 ]] && curl -X POST -F 'FirstName=JustinA' -F 'destination=+447770856190' -F "message=Menzies P${PRI} Incident $TIX logged with $OWN ($SUM)" http://myfone.io/apiSMS/02f95a87-1752-11e6-87b0-00163ebbe4b1 && mutt "justin.apps@menziesaviation.com" -s "!!! URGENT Menzies P${PRI} Ticket $TIX URGENT !!!" <$P1FILE
[[ $PRI == 1 ]] && curl -X POST -F 'FirstName=StevenK' -F 'destination=+447739043962' -F "message=Menzies P${PRI} Incident $TIX logged with $OWN ($SUM)" http://myfone.io/apiSMS/02f95a87-1752-11e6-87b0-00163ebbe4b1 && mutt "steven.kay@menziesdistribution.com" -s "!!! URGENT Menzies P${PRI} Ticket $TIX URGENT !!!" <$P1FILE
[[ $PRI == 1 ]] && curl -X POST -F 'FirstName=MattY' -F 'destination=+447775010167' -F "message=Menzies P${PRI} Incident $TIX logged with $OWN ($SUM)" http://myfone.io/apiSMS/02f95a87-1752-11e6-87b0-00163ebbe4b1 && mutt "matthew.young@menziesaviation.com" -s "!!! URGENT Menzies P${PRI} Ticket $TIX URGENT !!!" <$P1FILE
echo $TIX >> $CALLOUT
}
# Function for Resolved tickets - P1s only
resolved() {
curl -X POST -F 'FirstName=Paul' -F 'destination=+447810853162' -F "message=RESOLVED - Menzies P1 Incident $RESTIX ($RESSUM)" http://myfone.io/apiSMS/02f95a87-1752-11e6-87b0-00163ebbe4b1
curl -X POST -F 'FirstName=Julian' -F 'destination=+447595445088' -F "message=RESOLVED - Menzies P1 Incident $RESTIX ($RESSUM)" http://myfone.io/apiSMS/02f95a87-1752-11e6-87b0-00163ebbe4b1
curl -X POST -F 'FirstName=PaulS' -F 'destination=+447718511320' -F "message=RESOLVED - Menzies P1 Incident $RESTIX ($RESSUM)" http://myfone.io/apiSMS/02f95a87-1752-11e6-87b0-00163ebbe4b1
curl -X POST -F 'FirstName=Justin' -F 'destination=+447770856190' -F "message=RESOLVED - Menzies P1 Incident $RESTIX ($RESSUM)" http://myfone.io/apiSMS/02f95a87-1752-11e6-87b0-00163ebbe4b1
echo $RESTIX >> $CALLRES
}
#
# Check tickets and call
#
#[[ `grep PhoneCallMade $P1FILE` ]] || [[ `cat $P1FILE|awk -F'","' '($7!~"Resolved")&&($7!~"Closed")&&($7!~"state") { print}'` ]] || call
#case $(grep PhoneCallMade $P1FILE;echo $?) in
case $(grep $TIX $CALLOUT;echo $?) in
	0) exit
	;;
	1) [[ `cat $P1FILE|awk -F'","' '($7!~"Resolved")&&($7!~"state")&&($7!~"Closed") { print}'` ]] && call
	;;
esac
# Resolved tickets
case $(grep $RESTIX $CALLRES;echo $?) in
	0) exit
	;;
	1) [[ `cat $P1RESFILE|awk -F'","' '($8~"Resolved")&&($8!~"state")&&($7~"1 - Critical") { print}'` ]] && resolved
	;;
esac
