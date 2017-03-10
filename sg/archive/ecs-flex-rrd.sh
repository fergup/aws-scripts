#!/bin/bash
###################################################################################
#
# ecs-flex.sh
# ----------
# Calculates flex overages on ECS
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 09/09/15 |  PRF   | First edition
# ---------------------------------------------------------------------------------
#
###################################################################################
# Set variables
ECSFILE=/data/edison.csv
COMPS=/data/sn/EuropeXAllXCompanies.csv
ECSOUT=/data/mail/ecs-out.csv
ECSMAIL=/data/mail/ecs-mail
# Process info and generate output
#echo "snt,name,Contracted CPU,Used CPU,CPU in flex,Contracted Memory,Memory in Use,Memory in flex,Contracted Storage,Storage in Use,Storage in flex,Contracted Prod VMs,Prod VMs in use,Contracted Prod VMs in flex,Contracted Pre-prod VMs,Pre-prod VMs in use,Pre-prod VMs in flex, Account Manager"
echo "snt,name,CPU in flex,Memory in flex,Storage in flex,Contracted Prod VMs in flex,Pre-prod VMs in flex, Account Manager" > $ECSOUT
for CUSTOMER in $(awk -F'|' '{ print $2 }' $ECSFILE|sort|uniq|egrep -v "aslg|astl|ecas|ecpm|ecuc|gaul|gsbl|iisa|in1r|peuc|qlil|sas7|sgns|su4a|su5o|su5p|su5q|tr0h|ukp0|ydep")
	do
	CONCPU=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $4 }'|paste -sd+ - | bc)
	CONMEM=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $5 }'|paste -sd+ - | bc)
	CONSTRG=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $6 }'|paste -sd+ - | bc)
	CONVMS=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $7 }'|paste -sd+ - | bc)
	CONPRE=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $8 }'|paste -sd+ - | bc)
	USECPU=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $14 }'|paste -sd+ - | bc)
	USEMEM=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $15 }'|paste -sd+ - | bc)
	USESTRG=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $16 }'|paste -sd+ - | bc)
	USEVMS=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $17 }'|paste -sd+ - | bc)
	USEPRE=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $18 }'|paste -sd+ - | bc)
	FLEXCPU=$(($USECPU - $CONCPU))
	FLEXMEM=$(($USEMEM - $CONMEM))
	FLEXSTRG=$(($USESTRG - $CONSTRG))
	FLEXVMS=$(($USEVMS - $CONVMS))
	FLEXPRE=$(($USEPRE - $CONPRE))
	NAME=$(grep -w $CUSTOMER $COMPS |awk -F, '{ print $1 }'|sed 's/"//g')
	ACCTMGR=$(grep -w $CUSTOMER $COMPS |awk -F, '{ print $19 }'|sed 's/"//g')
#echo "$CUSTOMER,$NAME,$CONCPU,$USECPU,$FLEXCPU,$CONMEM,$USEMEM,$FLEXMEM,$CONSTRG,$USESTRG,$FLEXSTRG,$CONVMS,$USEVMS,$FLEXVMS,$CONPRE,$USEPRE,$FLEXPRE,$ACCTMGR"
echo "$CUSTOMER,$NAME,$FLEXCPU,$FLEXMEM,$FLEXSTRG,$FLEXVMS,$FLEXPRE,$ACCTMGR" |awk -F, '($3>0)||($4>0)||($5>0)||($6>0)||($7>0) { print }' >> $ECSOUT
done
# Email report
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,paul.labbett@sungardas.com" -s "ECS flex report" -a $ECSOUT < $ECSMAIL
