#!/bin/bash
# A script to audit the whole of MS
# Variables
DATA=/data
HPSA=$DATA/hpsa_servers.csv
SC=$DATA/sc-sasu-all.csv
ZN=$(ls -atr $DATA/uk-zenoss* |tail -1)
SN=$DATA/sn/EuropeXAllXCompanies.csv
ECS=$(ls -atr $DATA/flex |tail -1)
MSMAIL=/data/mail/msmail
MSCSV=$DATA/ms.csv
# For loop to produce a table of each company's stuff
echo "" > $MSMAIL
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
" >> $MSMAIL
echo "<html><span style='font-family:arial;text-align: center'><table border='1'><tr bgcolor="59FD61"><b><td>Customer SNT</td><td>Customer Name</td><td>Service Now status</td><td>Installed-Active devices in Service Center</td><td>Devices in Zenoss</td><td>Devices in HPSA</td><td>Devices in ECS</td></tr>"  >> $MSMAIL
echo "Customer SNT,Customer Name,Service Now status,Installed-Active devices in Service Center,Devices in Zenoss,Devices in HPSA,Devices in ECS"  > $MSCSV
export IFS=$'\n'
for COMPANY in $(awk -F'","' '{ print $1 }' $SN |egrep -v "xx|XX" |sed 's/"//g' )
	do
	STATE=$(grep -w $COMPANY $SN |awk -F'","' '{ print $16 }')
	SNT=$(grep -w $COMPANY $SN |awk -F'","' '{ print $8 }')
	STATCOL=white;[[ $STATE != Production ]] && STATCOL=red
	COMPSC=$(grep -iw "$COMPANY" $SC|awk -F, '($19~"Installed-Active") { print }' |wc -l)
	COMPZN=$(grep -iwc "$COMPANY" $ZN)
	COMPHPSA=$(grep -iwc "$COMPANY" $HPSA)
	COMPECS=$(grep -iwc $SNT $ECS)
echo "<tr><td>$SNT</td><td>$COMPANY</td><td>$STATE</td><td>$COMPSC</td><td>$COMPZN</td><td>$COMPHPSA</td><td>$COMPECS</td></tr>"  >> $MSMAIL
echo "$SNT,$COMPANY,$STATE,$COMPSC,$COMPZN,$COMPHPSA,$COMPECS"  >> $MSCSV
done
echo "</table>" >> $MSMAIL
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com" -s "MS audit report" -a $MSCSV < $MSMAIL
