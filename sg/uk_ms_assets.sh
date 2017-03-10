#!/bin/bash
###################################################################################
#
# uk_ms_asets.sh
# ---------------
# Reporting script for UK/European MS devices
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date    | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 05May2013 |  PRF   | First edition
# ---------------------------------------------------------------------------------
#
###################################################################################
#
# Declare script variables
#
###################################################################################
DATE=$(date +%Y%m%d)
DATADIR=/data # CHANGE to /home/zenoss
ARCHDIR=/data/archive # CHANGE to /home/zenoss/data/archive
SCFILE=$DATADIR/sc-sasu-all.txt
SCARCHFILE=$ARCHDIR/sc-sasu-all.txt.$DATE
SCMIN=$DATADIR/scmin
SCMINARCH=$ARCHIDR/scmin.$DATE
SCOLDFILE=$(ls -tr $ARCHDIR/sc-sasu-all* |tail -1)
ZNFILE=$(ls -tr $DATADIR/uk-zenoss-dump* |tail -1)
ZNIN=$(cat $ZNFILE |awk -F, '($19=="Y") { print $2","$1","$10","$14","$15","$16","$17 }')
ZNMIN=$DATADIR/znmin
ZNMINARCH=$(ls -tr $ARCHDIR/znmin* |tail -1)
ZNOLDFILE=$(ls -tr $ARCHDIR/uk-zenoss-dump-* |tail -1)
SAFILE=$DATADIR/hpsa_servers.csv
SAIN=$(cat $SAFILE|awk -F, '($7=="Y")'|grep -v ",,,,,")
SAOLDFILE=$(ls -tr $ARCHDIR/hpsa_servers*|tail -1)
SAARCHFILE=$ARCHDIR/hpsa_servers.$DATE.csv
DAY=$(date +%A" "%B" "%d" "%Y)
MAILFILE=$DATADIR/mail.$DATE
MAILOLDFILE=$(ls -tr $ARCHDIR/mail.*|tail -1)
CSV=$DATADIR/ms_assets.csv
CSVARCH=$ARCHDIR/ms_assets.$DATE.csv
COUNTRIES="GB FR IE SE"
README=$DATADIR/README.txt
NOTINZN=/tmp/notinzn
# Check if we're the live host and if not, pull the SC file from the live box
#[[ $(ifconfig bond0:0 |grep 213.212.69.95) ]]||scp hounu119:$SCFILE $SCFILE
# Create some files
mv $DATADIR/mail.20* $ARCHDIR
cp $SCMIN $ARCHDIR/scmin.$DATE
cp $ZNMIN $ARCHDIR/znmin.$DATE
cat $SCFILE| awk -F'\t' '($21=="server"||$21=="pdu"||$21=="switch"||$21=="router"||$21=="loadbalancer"||$21=="firewall"||$21=="sanarray"||$21=="sanswitch")&&($19=="Installed-Active")&&($20=="Monitor Only"||$20=="Managed")&&($2!="")  { print $2","$8","$21 }' |sort -k 2|uniq >$SCMIN
cat $ZNFILE| awk -F, '($10=="Installed-Active") { print $1","$17 }'|sort |uniq >$ZNMIN
#
# Data variables. I think these need to be generated using a fot loop. 
#
WINSC=$(cat $SCFILE  | awk -F'\t' '($8=="WINDOWS"||$8=="Windows"||$8=="Windows 2003"||$8=="WINDOWS 2003 X64"||$8=="WINDOWS X64"||$8=="t-win-2008r2-std-rtm-full-01f")&&($12 ~ "GB:")&&($21=="server")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active") { print $2 }'|sed 's/ //g' |sed '/^$/d'|wc -l |awk '{ print $1}')
WINSCPEND=$(cat $SCFILE  | awk -F'\t' '($8=="WINDOWS"||$8=="Windows"||$8=="Windows 2003"||$8=="WINDOWS 2003 X64"||$8=="WINDOWS X64"||$8=="t-win-2008r2-std-rtm-full-01f")&&($12 ~ "GB:")&&($21=="server")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Pending-Implementation"||$19=="Pending Implementation") { print $2 }'|sed 's/ //g' |sed '/^$/d'|wc -l |awk '{ print $1 }')
WINSCREPNUM=$(cat $SCFILE  | awk -F'\t' '($8=="WINDOWS"||$8=="Windows"||$8=="Windows 2003"||$8=="WINDOWS 2003 X64"||$8=="WINDOWS X64"||$8=="t-win-2008r2-std-rtm-full-01f")&&($12 ~ "GB:")&&($21=="server")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Repair") { print $2 }'|sed 's/ //g' |sed '/^$/d'|wc -l |awk '{ print $1 }')
WINSCREP=$(cat $SCFILE  | awk -F'\t' '($8=="WINDOWS"||$8=="Windows"||$8=="Windows 2003"||$8=="WINDOWS 2003 X64"||$8=="WINDOWS X64"||$8=="t-win-2008r2-std-rtm-full-01f")&&($12 ~ "GB:")&&($21=="server")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Repair") { print $1","$2","$8","$9","$12","$23 }'|sed 's/ //g' |sed '/^$/d')
WINZN=0
WINSA=0
WINSAOK=0
rm $NOTINZN
win() {
for WIN in $(cat $SCFILE|awk -F'\t' '($8=="WINDOWS"||$8=="Windows"||$8=="Windows 2003"||$8=="WINDOWS 2003 X64"||$8=="WINDOWS X64"||$8=="t-win-2008r2-std-rtm-full-01f")&&($12 ~ "GB:")&&($21=="server")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active") { print $2 }'|sed 's/ //g' |sed '/^$/d')
	do
	grep -w $WIN $ZNFILE >/dev/null 2>&1 && WINZN=$(($WINZN+1))||grep -w $WIN $SCFILE|awk -F'\t' '{ print $1","$2","$8","$9","$12,","$23 }' >> $NOTINZN
	grep -w $WIN $SAFILE >/dev/null 2>&1 && WINSA=$(($WINSA+1))
	grep -w $WIN $SAFILE |grep ",OK" >/dev/null 2>&1 && WINSAOK=$(($WINSAOK+1))
done
}
win
WINSCIN=$(diff $SCFILE $SCOLDFILE |awk -F'\t' '($8=="WINDOWS"||$8=="Windows"||$8=="Windows 2003"||$8=="WINDOWS 2003 X64"||$8=="WINDOWS X64"||$8=="t-win-2008r2-std-rtm-full-01f")&&($12 ~ "GB:")&&($21=="server")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active")'|grep -c "<")
WINSCOUT=$(diff $SCFILE $SCOLDFILE |awk -F'\t' '($8=="WINDOWS"||$8=="Windows"||$8=="Windows 2003"||$8=="WINDOWS 2003 X64"||$8=="WINDOWS X64"||$8=="t-win-2008r2-std-rtm-full-01f")&&($12 ~ "GB:")&&($21=="server")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active")'|grep -c ">")
WINZNIN=$(cat $ZNFILE |egrep "/Server/SysEdge/Windows|/Server/Windows|/Server/Nimsoft/Windows"|awk -F, '($19=="Y")'| wc -l|awk '{ print $1 }')
WINSAIN=$(cat $SAFILE|awk -F, '($5 ~ "Win")&&($7=="Y")' |wc -l|awk '{ print $1 }')
WINZNPC=$(echo "$WINZN/$WINSC*100" |bc -l|cut -b -5)
WINSAPC=$(echo "$WINSA/$WINSC*100" |bc -l|cut -b -5)
WINZNDIFF=$(($WINSC - $WINZN))
WINSADIFF=$(($WINSC - $WINSA))
WINSAOKDIFF=$(($WINSA - $WINSAOK))
#
# VMware
#
VMSC=$(cat $SCFILE | awk -F'\t' '($8 ~ "VM")&&($12 ~ "GB:")&&($21=="server")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active") { print $1 }'|sed 's/ //g' |sed '/^$/d'|wc -l |awk '{ print $1}')
for VM in $(cat $SCFILE|awk -F'\t' '($8 ~ "VM")&&($12 ~ "GB:")&&($21=="server")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active") { print $1 }'|sed 's/ //g' |sed '/^$/d')
        do
        grep -w $VM $ZNFILE >/dev/null 2>&1 && VMZN=$(($VMZN+1))
done
VMZNPC=$(echo "$VMZN/$VMSC*100" |bc -l|cut -d. -f 1)
#
# Unix
#
UXSC=$(cat $SCFILE  | awk -F'\t' '($8=="RHEL"||$8=="LINUX"||$8=="RH Linux"||$8=="RH LINUX"||$8=="SOLARIS"||$8=="Red Hat Enterprise Linux"||$8=="AIX"||$8=="t-rhel-server-5.5-64-03e")&&($12 ~ "GB:")&&($21=="server")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active") { print $2 }'|sed 's/ //g' |sed '/^$/d'|wc -l|awk '{ print $1}')
UXSCPEND=$(cat $SCFILE  | awk -F'\t' '($8=="RHEL"||$8=="LINUX"||$8=="RH Linux"||$8=="RH LINUX"||$8=="SOLARIS"||$8=="Red Hat Enterprise Linux"||$8=="AIX"||$8=="t-rhel-server-5.5-64-03e")&&($12 ~ "GB:")&&($21=="server")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Pending-Implementation"||$19=="Pending Implementation") { print $2 }'|sed 's/ //g' |sed '/^$/d'|wc -l|awk '{ print $1}')
UXZN=0
ux() {
UXSA=0
for UX in $(cat $SCFILE|awk -F'\t' '($8=="RHEL"||$8=="LINUX"||$8=="RH Linux"||$8=="RH LINUX"||$8=="SOLARIS"||$8=="Red Hat Enterprise Linux"||$8=="AIX"||$8=="t-rhel-server-5.5-64-03e")&&($12 ~ "GB:")&&($21=="server")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active") { print $2 }'|sed 's/ //g' |sed '/^$/d')
	do
	grep -w $UX $ZNFILE >/dev/null 2>&1 && UXZN=$(($UXZN+1))
	grep -w $UX $SAFILE >/dev/null 2>&1 && UXSA=$(($UXSA+1))
done
}
ux
UXSCIN=$(diff $SCFILE $SCOLDFILE |awk -F'\t' '($8=="RHEL"||$8=="LINUX"||$8=="RH Linux"||$8=="RH LINUX"||$8=="SOLARIS"||$8=="Red Hat Enterprise Linux"||$8=="AIX"||$8=="t-rhel-server-5.5-64-03e")&&($21=="server")&&($12 ~ "GB:")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active")'|grep -c "<")
UXSCOUT=$(diff $SCFILE $SCOLDFILE |awk -F'\t' '($8=="RHEL"||$8=="LINUX"||$8=="RH Linux"||$8=="RH LINUX"||$8=="SOLARIS"||$8=="Red Hat Enterprise Linux"||$8=="AIX"||$8=="t-rhel-server-5.5-64-03e")&&($21=="server")&&($12 ~ "GB:")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active")'|grep -c ">")
UXZNIN=$(cat $ZNFILE |egrep "/Server/SysEdge/AIX|/Server/Linux|/Server/SysEdge/Linux|/Server/SysEdge/Solaris|/Server/Solaris|/Server/Nimsoft/Linux"|awk -F, '($19=="Y")'| wc -l|awk '{ print $1 }')
UXZNOUT=$(diff $ZNMIN $ZNMINARCH| egrep "/Server/SysEdge/AIX|/Server/Linux|/Server/SysEdge/Linux|/Server/SysEdge/Solaris|/Server/Solaris|/Server/Nimsoft/Linux"|grep -c ">")
UXSAIN=$(cat $SAFILE|awk -F, '($5 ~ "Linux"||$5 ~ "AIX"||$5 ~ "SunOS")&&($7=="Y")' |wc -l|awk '{ print $1 }')
UXSAOUT=$(diff $SAFILE $SAOLDFILE|egrep "Linux|AIX|SunOS"|grep -c ">")
UXZNPC=$(echo "$UXZN/$UXSC*100" |bc -l|cut -d. -f 1)
UXSAPC=$(echo "$UXSA/$UXSC*100" |bc -l|cut -d. -f 1)
#
# IPDUs
#
PDUSC=$(cat $SCFILE  | awk -F'\t' '($21=="pdu")&&($12 ~ "GB:")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active") { print $2 }'|sed 's/ //g' |sed '/^$/d'|wc -l |awk '{ print $1}')
PDUSCPEND=$(cat $SCFILE  | awk -F'\t' '($21=="pdu")&&($12 ~ "GB:")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Pending-Implementation"||$19=="Pending Implementation") { print $2 }'|sed 's/ //g' |sed '/^$/d'|wc -l |awk '{ print $1 }')
PDUSCIN=$(diff $SCFILE $SCOLDFILE |awk -F'\t' '($21=="pdu")&&($12 ~ "GB:")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active")'|grep -c "<")
PDUSCOUT=$(diff $SCFILE $SCOLDFILE |awk -F'\t' '($21=="pdu")&&($12 ~ "GB:")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active")'|grep -c ">")
PDUZN=0
pdu() { 
for PDU in $(cat $SCFILE  | awk -F'\t' '($21=="pdu")&&($12 ~ "GB:")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active") { print $2 }'|sed 's/ //g' |sed '/^$/d')
    do
    grep -w $PDU $ZNFILE >/dev/null 2>&1 && PDUZN=$(($PDUZN+1))
done
}
pdu
PDUZNIN=$(cat $ZNFILE |egrep "/Power"|awk -F, '($19=="Y")'| wc -l|awk '{ print $1 }')
PDUZNOUT=$(diff $ZNFILE $ZNOLDFILE|grep Power|grep -c ">")
PDUSA="-"
PDUZNPC=$(echo "$PDUZN/$PDUSC*100" |bc -l|cut -d. -f 1)
PDUSAPC="-"
#
# Storage
#
SANSC=$(cat $SCFILE  | awk -F'\t' '($21=="sanarray"||$21=="sanswitch")&&($12 ~ "GB:")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active") { print $2 }'|sed 's/ //g' |sed '/^$/d'|wc -l|awk '{ print $1}')
SANSCPEND=$(cat $SCFILE  | awk -F'\t' '($21=="sanarray"||$21=="sanswitch")&&($12 ~ "GB:")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Pending-Implementation"||$19=="Pending Implementation") { print $2 }'|sed 's/ //g' |sed '/^$/d'|wc -l|awk '{ print $1}')
SANSCIN=$(diff $SCFILE $SCOLDFILE |awk -F'\t' '($21=="sanarray"||$21=="sanswitch")&&($12 ~ "GB:")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active")'|grep -c "<")
SANSCOUT=$(diff $SCFILE $SCOLDFILE |awk -F'\t' '($21=="sanarray"||$21=="sanswitch")&&($12 ~ "GB:")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active")'|grep -c ">")
SANZN=0
for SAN in $(cat $SCFILE  | awk -F'\t' '($21=="sanarray"||$21=="sanswitch")&&($12 ~ "GB:")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active") { print $2 }'|sed 's/ //g' |sed '/^$/d')
    do
    grep -w $SAN $ZNFILE >/dev/null 2>&1 && SANZN=$(($SANZN+1))
done
SANZN=$(grep "/Storage" $ZNFILE|awk -F, '($10=="Installed-Active") { print $1 }'|sed 's/ //g' |sed '/^$/d'|wc -l |awk '{ print $1}')
SANZNIN=$(cat $ZNFILE |egrep "/Storage"|awk -F, '($19=="Y")'| wc -l|awk '{ print $1 }')
SANZNOUT=$(diff $ZNMIN $ZNMINARCH|grep Storage|grep -c "<")
SANZNPC=$(echo "$SANZN/$SANSC*100" |bc -l|cut -d. -f 1)
#
# Networks
#
NETSC=$(cat $SCFILE  | awk -F'\t' '($21=="switch"||$21=="router"||$21=="loadbalancer"||$21=="firewall")&&($20=="Monitor Only"||$20=="Managed")&&($12 ~ "GB:")&&($19=="Installed-Active") { print $2 }'|sed 's/ //g' |sed '/^$/d'|wc -l |awk '{ print $1}')
NETSCPEND=$(cat $SCFILE  | awk -F'\t' '($21=="switch"||$21=="router"||$21=="loadbalancer"||$21=="firewall")&&($20=="Monitor Only"||$20=="Managed")&&($12 ~ "GB:")&&($19=="Pending-Implementation"||$19=="Pending Implementation") { print $2 }'|sed 's/ //g' |sed '/^$/d'|wc -l |awk '{ print $1}')
NETSCIN=$(diff $SCFILE $SCOLDFILE |awk -F'\t' '($21=="switch"||$21=="router"||$21=="loadbalancer"||$21=="firewall")&&($20=="Monitor Only"||$20=="Managed")&&($12 ~ "GB:")&&($19=="Installed-Active")'|grep -c "<")
NETSCOUT=$(diff $SCFILE $SCOLDFILE |awk -F'\t' '($21=="switch"||$21=="router"||$21=="loadbalancer"||$21=="firewall")&&($20=="Monitor Only"||$20=="Managed")&&($12 ~ "GB:")&&($19=="Installed-Active")'|grep -c ">")
NETZN=0
net() {
for NET in $(cat $SCFILE  | awk -F'\t' '($21=="switch"||$21=="router"||$21=="loadbalancer"||$21=="firewall")&&($20=="Monitor Only"||$20=="Managed")&&($12 ~ "GB:")&&($19=="Installed-Active") { print $2 }'|sed 's/ //g' |sed '/^$/d')
    do
    grep -w $NET $ZNFILE >/dev/null 2>&1 && NETZN=$(($NETZN+1))
done
}
net
NETZNIN=$(cat $ZNFILE |egrep "/Network"|awk -F, '($19=="Y")'| wc -l|awk '{ print $1 }')
NETZNOUT=$(diff $ZNMIN $ZNMINARCH|grep Network|grep -c ">")
NETZNPC=$(echo "$NETZN/$NETSC*100" |bc -l|cut -d. -f 1)
#
# Europe
#
IESC=$(cat $SCFILE|awk -F'\t' '($12 ~ "IE:*")&&($10=="Installed-Active")($21=="switch"||$21=="router"||$21=="loadbalancer"||$21=="firewall"||$21=="pdu"||$21=="server"||$21=="sanarray"||$21=="sanswitch")&&($20=="Monitor Only"||$20=="Managed") { print $1 }'|sed 's/ //g' |sed '/^$/d'|wc -l|awk '{ print $1}')
FRSC=$(cat $SCFILE|awk -F'\t' '($12 ~ "FR:*")&&($10=="Installed-Active")($21=="switch"||$21=="router"||$21=="loadbalancer"||$21=="firewall"||$21=="pdu"||$21=="server"||$21=="sanarray"||$21=="sanswitch")&&($20=="Monitor Only"||$20=="Managed") { print $1 }'|sed 's/ //g' |sed '/^$/d'|wc -l|awk '{ print $1}')
SESC=$(cat $SCFILE|awk -F'\t' '($12 ~ "SE:*")&&($10=="Installed-Active")($21=="switch"||$21=="router"||$21=="loadbalancer"||$21=="firewall"||$21=="pdu"||$21=="server"||$21=="sanarray"||$21=="sanswitch")&&($20=="Monitor Only"||$20=="Managed") { print $1 }'|sed 's/ //g' |sed '/^$/d'|wc -l|awk '{ print $1}')
IEZN=$(grep "IE:DUBLIN" $ZNFILE|awk -F, '($10=="Installed-Active") { print $1 }'|sed 's/ //g' |sed '/^$/d'|wc -l|awk '{ print $1}')
FRZN=$(grep "FR:" $ZNFILE|awk -F, '($10=="Installed-Active") { print $1 }'|sed 's/ //g' |sed '/^$/d'|wc -l|awk '{ print $1}')
SEZN=$(grep "SE:" $ZNFILE|awk -F, '($10=="Installed-Active") { print $1 }'|sed 's/ //g' |sed '/^$/d'|wc -l|awk '{ print $1}')
IESA=$(egrep -c "DUB1" $SAFILE)
FRSA=$(egrep -c "LOG1" $SAFILE)
SESA=$(egrep -c "STH1" $SAFILE)
# Everything
SCIN=$(diff $SCFILE $SCOLDFILE |awk -F'\t' '($21=="server"||$21=="pdu"||$21=="sanarray"||$21=="sanswitch"||$21=="switch"||$21=="router"||$21=="loadbalancer"||$21=="firewall")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active")'|grep "<" |sed 's/< //g'|awk  -F'\t' '{ print $1" "$2" "$8" "$9" "$16" "$20" "$21 }')
SCOUT=$(diff $SCFILE $SCOLDFILE |awk -F'\t' '($21=="server"||$21=="pdu"||$21=="sanarray"||$21=="sanswitch"||$21=="switch"||$21=="router"||$21=="loadbalancer"||$21=="firewall")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active")'|grep ">" |sed 's/> //g'|awk  -F'\t' '{ print $1" "$2" "$8" "$9" "$16" "$20" "$21 }')
ALLSC=$(echo "$WINSC+$UXSC+$NETSC+$SANSC+$PDUSC"|bc -l|cut -b -5)
ALLSCIN=$(echo "$WINSCIN+$UXSCIN+$NETSCIN+$SANSCIN+$PDUSCIN"|bc -l|cut -b -5)
ALLSCOUT=$(echo "$WINSCOUT+$UXSCOUT+$NETSCOUT+$SANSCOUT+$PDUSCOUT"|bc -l|cut -b -5)
ALLSCPEND=$(echo "$WINSCPEND+$UXSCPEND+$NETSCPEND+$SANSCPEND+$PDUSCPEND"|bc -l|cut -b -5)
ALLSVR=$(echo "$WINSC+$UXSC"|bc -l|cut -b -5)
ALLZN=$(echo "$WINZN+$UXZN+$NETZN+$SANZN+$PDUZN"|bc -l|cut -b -5)
ALLZNPC=$(echo "$ALLZN/$ALLSC*100" |bc -l|cut -d. -f 1)
ALLZNIN=$(echo "$WINZNIN+$UXZNIN+$NETZNIN+$SANZNIN+$PDUZNIN"|bc -l|cut -b -5)
ALLZNOUT=$(echo "$WINZNOUT+$UXZNOUT+$NETZNOUT+$SANZNOUT+$PDUZNOUT"|bc -l|cut -b -5)
ALLSA=$(echo "$WINSA+$UXSA"|bc -l|cut -b -5)
ALLSAPC=$(echo "$ALLSA/$ALLSVR*100" |bc -l|cut -d. -f 1)
ALLSAIN=$(echo "$WINSAIN+$UXSAIN"|bc -l|cut -b -5)
ALLSAOUT=$(echo "$WINSAOUT+$UXSAOUT"|bc -l|cut -b -5)
###################################################################################
#
# Do stuff
#
###################################################################################
# Create a nice CSV to attach to the mail
echo "ip_host,ip_address,logical_name,description,serial_number,vendor_id,vendor_model,server_os,company_use,company_own,contracting_company,location,floor,room,location_cabinet,location_shelf,asset_tag,serial_number,istatus,status,type,last_updated,updated_by,in_zenoss,in_hpsa" > $CSV
csv() {
for SERVER in $(cat $SCFILE | awk -F'\t' '($21=="server"||$21=="sanarray"||$21=="sanswitch")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active"||$19=="Pending Implementation") { print $2 }'|sed 's/ //g' |sed '/^$/d')
        do
	ZN=$(grep -w $SERVER $ZNFILE >/dev/null 2>&1;echo $?)
	[[ $ZN = 0 ]] && ZNYN=Y;[[ $ZN = 1 ]] && ZNYN=N
	SA=$(grep -w $SERVER $SAFILE >/dev/null 2>&1;echo $?)
	[[ $SA = 0 ]] && SAYN=Y;[[ $SA = 1 ]] && SAYN=N
	LINE=$(grep -w $SERVER $SCFILE |head -1|awk -F'\t' '($21=="server"||$21=="sanarray"||$21=="sanswitch")&&($20=="Monitor Only"||$20=="Managed")&&($19=="Installed-Active"||"Pending Implementation") { print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$11","$12","$13","$14","$15","$16","$18","$19","$20","$21","$22","$23}')
	echo "$LINE,$ZNYN,$SAYN" >> $CSV
done
}
csv
# Create mail file
rm $MAILFILE 
printf "===============================
Device\t\t| SC\t| ZN\t| HPSA\t|
============ Windows ===========
Windows All\t| $WINSC\t| $WINZN\t| $WINSA ($WINSAOK)\t
Windows %%\t| -\t| $WINZNPC%%| $WINSAPC%%
Windows Diff\t| -\t| $WINZNDIFF\t| $WINSADIFF ($WINSAOKDIFF)\t
Windows New\t| $WINSCIN\t| $WINZNIN\t| $WINSAIN\t|
Windows Pend\t| $WINSCPEND\t| -\t| -\t|
Windows Rep\t| $WINSCREPNUM\t| -\t| -\t|
============ VMware ============
VMware All\t| $VMSC\t| $VMZN\t| -\t|
VMware %%\t| -\t| $VMZNPC\t| -\t|
============== Unix =============
Unix All\t\t| $UXSC\t| $UXZN\t| $UXSA\t|
Unix In\t\t| $UXSCIN\t| $UXZNIN\t| $UXSAIN\t|
Unix %%\t\t| -\t| $UXZNPC%%\t| $UXSAPC%%\t|
Unix Pend\t| $UXSCPEND\t| -\t| -\t|
============ Network ============
Network All\t| $NETSC\t| $NETZN\t| -\t|
Network In\t| $NETSCIN\t| $NETZNIN\t| -\t|
Network %%\t| -\t| $NETZNPC%%\t| \t|
Network Pend\t| $NETSCPEND\t| -\t| -\t|
===============================
Device\t\t| SC\t| ZN\t| HPSA\t|
============ Storage ============
Storage All\t| $SANSC\t| $SANZN\t| -\t|
Storage In\t| $SANSCIN\t| $SANZNIN\t| -\t|
Storage %%\t| -\t| $SANZNPC%%\t| \t|
Storage Pend\t| $SANSCPEND\t| -\t| -\t|
=========== IPDUs ===============
IPDU All\t| $PDUSC\t| $PDUZN\t| -\t|
IPDU In\t\t| $PDUSCIN\t| $PDUZNIN\t| -\t|
IPDU %%\t\t| -\t| $PDUZNPC%%\t| -\t|
IPDU Pend\t| $PDUSCPEND\t| -\t| -\t|
========== Europe ==============
Country\t| SC\t| ZN\t| HPSA\t|
===============================
Ireland\t\t| $IESC\t| $IEZN\t| $IESA\t|
France\t\t| $FRSC\t| $FRZN\t| $FRSA\t|
Sweden\t| $SESC\t| $SEZN\t| $SESA\t|
===============================


Added to Zenoss
===============
$ZNIN

Added to HPSA
=============
$SAIN

Windows servers not in Zenoss
==============================
$(cat $NOTINZN)
 
Windows servers in 'Repair' status
==================================
$WINSCREP

" >> $MAILFILE
# Send mail
#mutt -a $CSV -a $README "paul.ferguson@sungard.com,jason.jordan@sungard.com,stephen.davies@sungard.com,laura.fitzpatrick@sungard.com,david.wilcock@sungard.com" -s "Managed Services Report for $DATE" < $MAILFILE
mutt -a $CSV -a $README "paul.ferguson@sungardas.com" -s "Managed Services Report for $DATE" < $MAILFILE
#mutt -a $CSV -a $README "paul.ferguson@sungard.com" -s "Managed Services Report for $DATE" < $MAILFILE
#[[ $(date +%d) = 01 ]] && mutt -a $CSV -a $README "tim.sutton@sungard.com" -s "Tim's Monthly Managed Services Report for $DATE" < $MAILFILE
#[[ $(date +%a) = Mon ]] && mutt -a $CSV -a $README "tim.sutton@sungard.com,malcolm.rhodes@sungard.com,paul.labbett@sungard.com" -s "Weekly Managed Services Report for $DATE" < $MAILFILE
#mutt -a $CSV -a $README "paul.ferguson@sungard.com" -s "Managed Services Report for $DATE" < $MAILFILE
# Tidy up $ARCHDIR
cp $SCFILE $SCARCHFILE
for FILES in hpsa mail uk-zenoss sc-sasu znmin scmin
    do
    find ${ARCHDIR}/${FILES}* -ctime +10 -exec rm {} \;
done
