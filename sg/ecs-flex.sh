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
# |   1.1   | 23/10/15 |  PRF   | Added archiving and 'days in flex' figure
# |   1.2   | 21/01/16 |  PRF   | Removed 'MRR' bit, added columns and all 
# |   1.3   | 04/02/16 |  PRF   | Fixed issue with allocated versus used in multiple VDCs
# ---------------------------------------------------------------------------------
#
###################################################################################
# Set variables
#ECSFILE=/data/edison.csv
DATE=$(date +%Y%m%d)
ECSFILE=$(ls -atr /data/flex/flex* |tail -1)
ECSFILEYEST=$(ls -atr /data/flex/flex* |tail -2|head -1)
ECSFILEBASE=$(basename $ECSFILE)
COMPS=/data/sn/EuropeXAllXCompanies.csv # Service Now companies list
ECSZIP=$(ls -atr /data/flex/*.zip|tail -1)
ZIPDATE=$(basename `ls -atr /data/flex/*.zip|tail -1` |cut -d . -f 1)
ECSSTAT=/data/flex/$ZIPDATE/ent_cloud_vms_${ZIPDATE}.csv
ARCHDIR=/data/flex/archive
ECSOUT=/data/mail/ecs-out.csv
ECSMAIL=/data/mail/ecs-mail
ECSMAILYEST=/data/mail/ecs-mail-yest
RRDDATE=$(date +%m/%d/%Y" "%H:%M)
RRDFILE=/data/rrd/uk_flex.rrd
RRDFILEMONEY=/data/rrd/uk_flex_money.rrd
RRDGRAPHCPU=/data/images/flex_cpu.png
RRDGRAPHMEM=/data/images/flex_mem.png
RRDGRAPHSTRG=/data/images/flex_strg.png
RRDGRAPHVMS=/data/images/flex_vms.png
RRDGRAPHMONEY=/data/images/flex_money.png
COSTCPU=101
COSTSAN=50
COSTVM=100
# Set totals to Zero
FLEXCPUTOT=0
FLEXMEMTOT=0
FLEXSTRGTOT=0
FLEXVMSTOT=0
FLEXPRETOT=0
MONEYTOT=0
SANMONEYTOT=0;VMMONEYTOT=0;POOLMONEYTOT=0
# Copy away yesterday's file
cp $ECSMAIL $ECSMAILYEST
# Process info and generate output
echo "snt,name,CPU in flex,Memory in flex,Storage in flex,Contracted Prod VMs in flex,Pre-prod VMs in flex,Service Manager" > $ECSOUT
echo "" > $ECSMAIL
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
" >> $ECSMAIL
echo "<html><span style='font-family:arial;text-align: center'><table border='1'><tr bgcolor="59FD61"><b><td>Customer SNT</td><td>Customer Name</td><td>CPU in Flex</td><td>Memory in flex (GB)</td><td>Storage in flex (GB)</td><td>Contracted Prod VMs in flex</td><td>Pre-prod VMs in flex</td><td>Allocated CPU</td><td>Allocated Memory</td><td>Allocated Storage</td><td>Allocated VMs</td><td>Allocated Pre-prod VMs</td><td>Contracted CPUs</td><td>Contracted Memory</td><td>Contracted Storage</td><td>Contracted VMs</td><td>Contracted Pre-prod VMs</td><td>Service Manager</td></b></tr>"  >> $ECSMAIL
for CUSTOMER in $(awk -F'|' '{ print $2 }' $ECSFILE|sort|uniq|egrep -v "aslg|astl|bai0|cill|ecas|ecpm|ecuc|gaul|gsbl|iisa|in1r|jegi|peuc|qlil|sas7|sgns|st1w|su48|su4a|su5o|su5p|su5q|tr0h|ukp0|un1x|wahl|ydep")
	do
	CONCPU=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $4 }'|head -1)
	CONMEM=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $5 }'|head -1)
	CONSTRG=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $6 }'|head -1)
	CONVMS=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $7 }'|head -1)
	CONPRE=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $8 }'|head -1)
	USECPU=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $14 }'|paste -sd+ - | bc)
	USEMEM=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $15 }'|paste -sd+ - | bc)
	USESTRG=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $16 }'|paste -sd+ - | bc)
	USEVMS=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $17 }'|paste -sd+ - | bc)
	USEPRE=$(grep $CUSTOMER $ECSFILE |awk -F'|' '{ print $18 }'|paste -sd+ - | bc)
	FLEXCPU=$(($USECPU - $CONCPU)); [[ $FLEXCPU -gt 0 ]] && FLEXCPUTOT=$(($FLEXCPUTOT + $FLEXCPU))
	FLEXMEM=$(($USEMEM - $CONMEM)); [[ $FLEXMEM -gt 0 ]] && FLEXMEMTOT=$(($FLEXMEMTOT + $FLEXMEM))
	FLEXSTRG=$(($USESTRG - $CONSTRG)); [[ $FLEXSTRG -gt 0 ]] && FLEXSTRGTOT=$(($FLEXSTRGTOT + $FLEXSTRG))
	FLEXVMS=$(($USEVMS - $CONVMS)); [[ $FLEXVMS -gt 0 ]] && FLEXVMSTOT=$(($FLEXVMSTOT + $FLEXVMS))
	FLEXPRE=$(($USEPRE - $CONPRE)); [[ $FLEXPRE -gt 0 ]] && FLEXPRETOT=$(($FLEXPRETOT + $FLEXPRE))
	NAME=$(grep -w $CUSTOMER $COMPS |awk -F, '{ print $1 }'|sed 's/"//g')
	ACCTMGR=$(grep -w $CUSTOMER $COMPS |awk -F'",' '{ print $18 }'|sed 's/"//g')
	CPUMONEY=0;SANMONEY=0;VMMONEY=0;MEMONEY=0;POOLMONEY=0
	[[ $FLEXCPU -gt 0 ]] && FLEXCPUCOL="red" && CPUMONEY=$(($FLEXCPU * $COSTCPU))||FLEXCPUCOL="white"
	[[ $FLEXMEM -gt 0 ]] && FLEXMEMCOL="red" && MEMONEY=$((($FLEXMEM/2) * ($COSTCPU)))||FLEXMEMCOL="white"
	[[ $FLEXSTRG -gt 0 ]] && FLEXSTRGCOL="red" && SANMONEY=$((($FLEXSTRG/100) * ($COSTSAN)))||FLEXSTRGCOL="white"
	[[ $FLEXVMS -gt 0 ]] && FLEXVMSCOL="red" && VMMONEY=$(($FLEXVMS * $COSTVM))||FLEXVMSCOL="white"
	[[ $FLEXPRE -gt 0 ]] && FLEXPRECOL="red"||FLEXPRECOL="white"
	[[ $CPUMONEY -gt $MEMONEY ]] && POOLMONEY=$CPUMONEY || POOLMONEY=$MEMONEY
	MONEY=$(($POOLMONEY + $SANMONEY + $VMMONEY)); [[ $MONEY -gt 0 ]] && MONEYTOT=$(($MONEY + $MONEYTOT));[[ $POOLMONEY -gt 0 ]] && POOLMONEYTOT=$(($POOLMONEY + $POOLMONEYTOT));[[ $SANMONEY -gt 0 ]] && SANMONEYTOT=$(($SANMONEY + $SANMONEYTOT));[[ $VMMONEY -gt 0 ]] && VMMONEYTOT=$(($VMMONEY + $VMMONEYTOT))
#	YESTMONEY=$(grep $CUSTOMER $ECSMAILYEST |awk -F'<td>' '{ print $4 }'|sed 's/<\/td>//g'|sed 's/�//g')
	YESTMONEY=$(grep $CUSTOMER $ECSMAILYEST |awk -F'>' '{ print $27 }'|sed 's/<\/td//g'|sed 's/�//g')
	YESTFLEX=$(grep $CUSTOMER $ECSMAILYEST |awk -F'>' '{ print $31 }'|sed 's/<\/td//g'|sed 's/�//g')
	[[ $MONEY -ne $YESTMONEY ]] && DIFFCOL="yellow" || DIFFCOL="white"
	[[ $YESTMONEY -ne 0 ]] && DAYSFLEX=$((($YESTFLEX + 1))) || DAYSFLEX=0
#echo "$CUSTOMER,$NAME,$CONCPU,$USECPU,$FLEXCPU,$CONMEM,$USEMEM,$FLEXMEM,$CONSTRG,$USESTRG,$FLEXSTRG,$CONVMS,$USEVMS,$FLEXVMS,$CONPRE,$USEPRE,$FLEXPRE,$ACCTMGR"
echo "$CUSTOMER,$NAME,$FLEXCPU,$FLEXMEM,$FLEXSTRG,$FLEXVMS,$FLEXPRE,$USECPU,$USEMEM,$USESTRG,$USEVMS,$USEPRE,$MONEY,$ACCTMGR"  >> $ECSOUT
#echo "$CUSTOMER,$NAME,$FLEXCPU,$FLEXMEM,$FLEXSTRG,$FLEXVMS,$FLEXPRE,$USECPU,$USEMEM,$USESTRG,$USEVMS,$USEPRE,$MONEY,$ACCTMGR,$DAYSFLEX"  >> $ECSOUT
echo "<tr><td>$CUSTOMER</td><td>$NAME</td><td bgcolor="$FLEXCPUCOL">$FLEXCPU</td><td bgcolor="$FLEXMEMCOL">$FLEXMEM</td><td bgcolor="$FLEXSTRGCOL">$FLEXSTRG</td><td bgcolor="$FLEXVMSCOL">$FLEXVMS</td><td bgcolor="$FLEXPRECOL">$FLEXPRE</td><td>$USECPU</td><td>$USEMEM</td><td>$USESTRG</td><td>$USEVMS</td><td>$USEPRE</td><td>$CONCPU</td><td>$CONMEM</td><td>$CONSTRG</td><td>$CONVMS</td><td>$CONPRE</td><td>$ACCTMGR</td></tr>" |grep -v snt_code  >> $ECSMAIL
done
# work out how many customers are in flex
CUSTOMERTOT=$(grep "<td>" $ECSMAIL|grep -vc "Customer SNT")
# Final line of table
echo "<tr bgcolor="FFFFCC"><b><td>Total</td><td>Customers in flex:$CUSTOMERTOT</td><td>$FLEXCPUTOT</td><td>${FLEXMEMTOT}GB</td><td>${FLEXSTRGTOT}GB</td><td>$FLEXVMSTOT</td><td>$FLEXPRETOT</td></tr>" >> $ECSMAIL
echo "</table>" >> $ECSMAIL
printf "
Data based on $ECSFILEBASE" >> $ECSMAIL
# Update RRD tables and create graphs
rrdtool update $RRDFILE "$RRDDATE@$FLEXCPUTOT:$FLEXMEMTOT:$FLEXSTRGTOT:$FLEXVMSTOT:$FLEXPRETOT"
rrdtool update $RRDFILEMONEY "$RRDDATE@$MONEYTOT:$VMMONEYTOT:$POOLMONEYTOT:$SANMONEYTOT"
rrdtool graph $RRDGRAPHCPU -a PNG --title="ECS CPU Flex (UK)" --vertical-label "CPUs" 'DEF:probe1=/data/rrd/uk_flex.rrd:cpu:AVERAGE'  'AREA:probe1#FF0000:CPU'  -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-1m -e now
rrdtool graph $RRDGRAPHMEM -a PNG --title="ECS Memory Flex (UK)" --vertical-label "GB" 'DEF:probe1=/data/rrd/uk_flex.rrd:mem:AVERAGE'  'AREA:probe1#00FF00:Memory'  -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-1m -e now
rrdtool graph $RRDGRAPHSTRG -a PNG --title="ECS Storage Flex (UK)" --vertical-label "GB" 'DEF:probe1=/data/rrd/uk_flex.rrd:strg:AVERAGE'  'AREA:probe1#00FFFF:Storage' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-1m -e now
rrdtool graph $RRDGRAPHVMS -a PNG --title="ECS VMs Flex (UK)" --vertical-label "VMs" 'DEF:probe1=/data/rrd/uk_flex.rrd:vms:AVERAGE' 'AREA:probe1#000000:VMs' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-1m -e now
rrdtool graph $RRDGRAPHMONEY -a PNG --title="ECS Flex Potential MRR (UK)" --vertical-label "Potential MRR (�)" 'DEF:probe1=/data/rrd/uk_flex_money.rrd:total:AVERAGE' 'DEF:probe2=/data/rrd/uk_flex_money.rrd:pool:AVERAGE' 'DEF:probe3=/data/rrd/uk_flex_money.rrd:san:AVERAGE' 'DEF:probe4=/data/rrd/uk_flex_money.rrd:vms:AVERAGE' 'AREA:probe1#FF0000:Total' 'AREA:probe2#00FF00:Resource Pool' 'AREA:probe3#0000FF:SAN' 'AREA:probe4#000000:VMs' -w 600 -h 250 -n TITLE:13: --alt-y-grid -l 0 -s now-2m -e now
# Check VMware export and unzip
[[ -e $ECSZIP ]] && unzip -o $ECSZIP || echo "<br><font color="red">No export file found</font>" >> $ECSMAIL
# Email report
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "ECS flex report" -a $RRDGRAPHMONEY < $ECSMAIL
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,paul.labbett@sungardas.com,as.uk.servicemanagementreporting@sungardas.com" -s "ECS flex report"  < $ECSMAIL -a $RRDGRAPHMONEY 
# Tidy up and archive
cp $ECSMAIL  $ARCHDIR/$(basename $ECSMAIL).$DATE
mv /data/flex/flex* /data/flex/archive 