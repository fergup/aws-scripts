#/bin/bash
###################################################################################
#
# serco_asset_export.sh
# ---------------------
# Identifies Serco assets in Service Center and puts them in an orderly fashion in 
# an export CSV file, enriched with vCenter info 
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 09/02/14 |  PRF   | First edition. Curl bits by Andrew Philp
# ---------------------------------------------------------------------------------
#
# Needed in v2.0:
# 1. More error-checking - what if SCFILE is old? What about VC exports?
# 2. Trap a SIGTERM, etc to mop up half-formed file
# 3. Improve way variables are generated, e.g. create an array
###################################################################################
#
# Set variables, setup files, etc
#
###################################################################################
DATE=$(date +%Y%m%d)
SCFILE=/data/sc-sasu-all.txt
MAILFILEF=/data/serco_mail_fail
MAILFILES=/data/serco_mail_succeed
OUTFILE=/data/uk-serco-export.csv
ARCHFILE=/data/uk-serco-export-$DATE.csv
LTCVCIN=/data/smh-vcenter-export-ltc.csv
TC5VCIN=/data/smh-vcenter-export-tc5.csv
VCALL=/data/smh-vcenter-export.csv
MYENCPASS="UjBkQHRyNG41ZjNyCg=="
MYUSER="rodtransfer"
MYCURL=$(which curl)
MYPASS=$(echo "$MYENCPASS" | base64 --decode)
F1=$(basename "$OUTFILE")
R1=$RANDOM
TMPFILE=/tmp/$R1.$F1
RANDNAME=/tmp/smh.$R1.txt
# Fix the vCenter output files by converting them to UTF-8 format and stripping out special character
iconv -f UTF-16 -t UTF-8 < $LTCVCIN  | tr -d '\b\r' |sed 's/"//g' |sed '/^$/d' > $VCALL
iconv -f UTF-16 -t UTF-8 < $TC5VCIN  | tr -d '\b\r' |sed 's/"//g' |sed '/^$/d' >> $VCALL
# Create header line for export file
echo "Tag Number,Customer,CI Name & CI ID+,Serial Number,Manufacturer,Model,Prod Cat Tier 1/2/3,Owner Name,Site,Status,Unit Price,Installation Date,Available Date,Return Date,Disposal Date,Is Virtual,Ownership type,Accounting Code,DNS Hostname,IP Address,Hosting Network,Environment Specification,Farm,VM Data Centre,Asset GUID" > $OUTFILE
# Generate asset data on a per-device basis. There must be a more efficient way of doing this (array variable?) to be addressed in v2.0.
for DEV in $(cat $SCFILE |awk -F'\t' '($9~"SERCO "&&$21!="rd"&&$21!="port"&&$21!=""&&$21!="pdu"&&$21!="patchpath") { print $2 }'|sed '/^$/d'|sort|uniq)
	do
	TAG=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $1 }'|head -1)		
	CUSTOMER=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $9 }'|head -1)		
	case $CUSTOMER in			# Customer (Anthony Russell) has requested translations from our names to theirs
		"SERCO INFORMATION") CUSTOMER="Serco"
		;;
		"SERCO LIMITED MS AWE"|"SERCO SOLUTIONS LIMITED ATOMIC WEAPONS EST") CUSTOMER="Atomic Weapons Establishment"
		;;
		"SERCO LIMITED MS LCC") CUSTOMER="Lincs CC"
		;;
		"SERCO LIMITED MS THE LISTENING CO ECS"|"SERCO LIMITED MS LISTENING CO CANCER RESEARCH") CUSTOMER="SGS Private Sector"
		;;
		"SERCO MANAGED HOSTING SMH") CUSTOMER="Serco"
		;;
		*) CUSTOMER=$CUSTOMER
		;;
	esac
	CINAME=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $1 }'|head -1)		
	SERIAL=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $5 }'|head -1)		
	MFCR=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $6 }'|head -1)		
	MODEL=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $7 }'|head -1)		
	PRODCAT=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $21 }'|head -1)
	OWNER=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $10 }'|head -1)		
	SITE=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $12 }'|head -1)		
	case $SITE in				# Customer (Anthony Russell) has requested translations from our names to theirs
		"GB:HOUNSLOW.101"|"GB:HOUNSLOW.001") SITE="Sungard TC1 - Hounslow (LTC)"
		;;
		"GB:LONDON.001") SITE="Sungard TC2 - Docklands"
		;;
		"GB:WOKING.001") SITE="Sungard TC3 - Woking"
		;;
		"GB:BIRMINGHAM.001") SITE="Laburnum House"
		;;
		*) SITE=$SITE
	esac
	STATUS=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $19 }'|head -1)		
	PRICE=""
	INSTDATE=""
	ADATE=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $25 }'|head -1)
	case $ADATE in
		"") AVAILDATE=$ADATE
		;;
		*) AVAILDATE=$(date -d "$ADATE" +%d/%m/%y)
		;;
	esac
	RETDATE=""
	DDATE=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $26 }'|head -1)		
	case $DDATE in
		"") DISPDATE=""
		;;
		*) DISPDATE=$(date -d "$DDATE" +%d/%m/%y)
		;;
	esac
	case $(grep -w $DEV $SCFILE |awk -F'\t' '{ print $7 }'|grep -q VIRTUAL;echo $?) in
		0) ISVIRT=Yes 
		;;
		*) ISVIRT=No 
		;;
	esac
	OWNTYPE="Lease"
	ACCCODE=""
	DNSHOST=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $1 }'|head -1)
	IP=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $2 }'|head -1)	
	HOSTNET=""
	ENVSPEC=""
	case $OWNER in
		"SUNGARD CLOUD PLATFORM") FARM=ECS
		;;
		"SERCO MANAGED HOSTING SMH") FARM=SMH
		;;
		*) FARM=Other
		;;
	esac
	VDC=$(grep -w $DEV $VCALL|awk -F, '{ print $9 }'|head -1)	
	GUID=$(grep -w $DEV $SCFILE |awk -F'\t' '{ print $27 }'|head -1)		
echo "$TAG,$CUSTOMER,$CINAME,$SERIAL,$MFCR,$MODEL,$PRODCAT,$OWNER,$SITE,$STATUS,$PRICE,$INSTDATE,$AVAILDATE,$RETDATE,$DISPDATE,$ISVIRT,$OWNTYPE,$ACCCODE,$DNSHOST,$IP,$HOSTNET,$ENVSPEC,$FARM,$VDC,$GUID" >> $OUTFILE
done
# Save a copy of the ew file so we can archive it before it's over-written tomorrow
cp $OUTFILE $ARCHFILE;wait
# Do the web transfer to http://filetransfer.serco.com
$MYCURL -s -L -X POST -F eftupload=@$OUTFILE -u $MYUSER:$MYPASS https://filetransfer.serco.com >/dev/null
$MYCURL -s -L -X POST -F eftupload=@$ARCHFILE -u $MYUSER:$MYPASS https://filetransfer.serco.com/Archive >/dev/null
$MYCURL -s -u $MYUSER:$MYPASS https://filetransfer.serco.com > $RANDNAME
# Do stuff
if [ -f $RANDNAME ]; then
	NUM=$(cat $RANDNAME | grep $F1 | wc -l)
	if [ $NUM == 1 ]; then
		if [ -f $TMPFILE ]; then
			rm -rf $TMPFILE
		fi
		$MYCURL -o $TMPFILE -s -u $MYUSER:$MYPASS https://filetransfer.serco.com/$F1

		####Check the MD5 of source and destination file and compare
		SMD5=$(md5sum $OUTFILE | awk '{print $1}')
		RMD5=$(md5sum $TMPFILE | awk '{print $1}')
		if [ "$SMD5" = "$RMD5" ]; then
			rm $TMPFILE $RANDNAME
			mutt "john.broughton@sungardas.com" -a $OUTFILE -s "Serco asset export succeeded" < $MAILFILES
			exit 0
		else
			echo "File upload failed! - Unable to compare MD5"
			rm $TMPFILE $RANDNAME
			mutt "john.broughton@sungardas.com" -a $OUTFILE -s "Serco asset file upload issue - MD5 check failed. Please check." < $MAILFILEF
			exit 10
		fi
	else
		echo "Uploading failed"
		rm $TMPFILE $RANDNAME
		mutt "john.broughton@sungardas.com" -a $OUTFILE -s "Serco asset file upload failed. Please check." < $MAILFILEF
		exit 10
	fi
else
	echo "Unable to query the target to see if file has been uploaded."
	rm $TMPFILE $RANDNAME
	mutt "john.broughton@sungardas.com" -a $OUTFILE -s "Serco asset file - unable to query target via web UI. Please check." < $MAILFILEF
	exit 10
fi