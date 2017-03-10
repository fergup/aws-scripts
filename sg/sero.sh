#/bin/bash
###################################################################################
#
# Serco CI export
#
###################################################################################
DATE=$(date +%Y%m%d)
SCFILE=/data/sc-sasu-all.txt
SERCOMAILFILE=/data/serco_mail
SERCO=/data/uk-serco-export-$DATE.csv
VM=/data/smh-vms-$DATE.csv
#echo "CI Name,IP Address,logical_name,description,Manufacturer,Model,server_os,company_use,Owner Name,contracting_company,Site,floor,room,location_cabinet,location_shelf,asset_tag,Serial Number,Status,Prod Cat Tier 1/2/3,last_update" > $SERCO
# New line
echo "CI Name,Customer,Serial Number,Manufacturer,Model,Prod Cat Tier 1/2/3,Owner Name,Site,Status,Unit Price,Received Date,Installation Date,Available Date,Return Date,Disposal Date,Is Virtual,Ownership type,Accounting Code,DNS Hostname,IP Addres,Hosting Network,Environment Specification,Farm,VM Data Centre" > $SERCO
for DEV in $(cat $SCFILE |grep -iw "SERCO" |sed 's/\t/,/g'|awk -F, '($21!="rd"&&$21!="port"&&$21!=""&&$21!="pdu"&&$21!="patchpath") { print $2 }')
	do
	VDC="<Pending>"
	VDC=$(grep -w $DEV $VM|awk -F, '{ print $1 }')	
	grep -w $DEV $SCFILE |awk -F'\t' '{ print $1","$9","$18","$6","$8","$21","$10","$12","$19",Unit Price,Received Date,Installation Date,Available Date,Return Date,Disposal Date,Yes,Leased,Accounting Code,DNS hostname,"$2",Hosting Network,Environmental Specification,Farm" }';printf ",$VDC" >> $SERCO
done
