#!/bin/bash
###################################################################################
#
# buddy-list.sh
# -------------
# Takes input from Service Now reports and processes them for daily report to TOC
# management to track open Incidents based on 'buddy' lists withint the TOC
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 16/01/16 |  PRF   | First edition
# ---------------------------------------------------------------------------------
#
###################################################################################
# Set variables
TIXDIR=/data/sn
OPEN=$TIXDIR/GlobalXOpenXIncidentsXPFXExport.csv
CLOSED=$TIXDIR/IncidentsXClosedXYesterday.csv
RRDDATE=$(date +%m/%d/%Y" "%H:%M)
DATE=$(date +%Y-%m-%d" "%H:%M:%S)
DDATE=$(date +%d/%m/%Y)
TODAY=$(date +%Y-%m-%d)   # Set up variables for today and yesterday to check for newly-created tickets
YESTERDAY=$(date -d yesterday +%Y-%m-%d)
IFS=
# Useful files
HEADFILE=/data/buddy/buddy_head
MAILFILE=/data/mail/buddy_all_mail
HTMLFILE=/data/mail/buddy_all.html
TEAMMAIL=/data/mail/buddy_team.html
BUDDIES=("sawan.anarse@sungardas.com" "nikhil.brij@sungardas.com" "nobody@sungardas.com" "mary.delisle@sungardas.com" "tanveer.jinabade@sungardas.com" "sravani.potharaju@sungardas.com" "john.slomski@sungardas.com" "ketan.belekar@sungardas.com" "sumeet.kondvilkar@sungardas.com" "gautham.gavini@sungardas.com" "vivek.mayuranathan@sungardas.com" "tanmayee.deshpande@sungardas.com" "akshay.behere@sungardas.com" "adam.bergquist@sungardas.com" "brad.barnhart@sungardas.com" "rutuja.albur@sungardas.com" "rimi.deka@sungardas.com" "tejashree.nagawade@sungardas.com" "abhinav.wakhloo@sungardas.com" "ken.crandall@sungardas.com" "xande.craveiro-lopes@sungardas.com" "david.reese@sungardas.com" "nathan.pyle@sungardas.com" "haris.majeed@sungardas.com" "jay.jani@sungardas.com" "rich.blea@sungardas.com" "joshua.johnson@sungardas.com" "tbh@sungardas.com" "rahul.kumar@sungardas.com" "jarrod.porter@sungardas.com" "tribhawan.singh@sungardas.com" "geetha.arumugham@sungardas.com" "sean.kerrane@sungardas.com" "matt.lemmo@sungardas.com" "anand.mittal@sungardas.com" "haider.syed@sungardas.com" "rob.fye@sungardas.com" "rob.vrba@sungardas.com" "anshul.jain@sungardas.com" "kevin.leydon@sungardas.com" "steve.nold@sungardas.com" "tbh@sungardas.com" "rohit.malvade@sungardas.com" "terry.sims@sungardas.com" "cory.cass@sungardas.com" "debajyoti.debnath@sungardas.com" "rahil.bhatkar@sungardas.com" "adam.mathis@sungardas.com" "kavish.agnani@sungardas.com" "kishori.gaikwad@sungardas.com" "nobody@sungardas.com" "sanchali.paul@sungardas.com" "naresh.pathipati@sungardas.com" "sawan.anarse@sungardas.com" "symrin.syqueira@sungardas.com" "tripta.sidheshwar@sungardas.com" "shardul.ingle@sungardas.com" "pradeep.gaikwad@sungardas.com" "joseph.bouaphaseuth@sungardas.com" "kenneth.crandall@sungardas.com" "graham.lowell@sungardas.com" "robert.fye@sungardas.com" "matt.schmoeckel@sungardas.com" "william.graydon@sungardas.com" "greg.kulp@sungardas.com" "utkarsh.singh@sungardas.com" "debarun.roygupta@sungardas.com" "shafik.ahmed@sungardas.com" "ashish.pattar@sungardas.com" "yogita.pathak@sungardas.com" "niharika.samuel@sungardas.com" "jyoti.mane@sungardas.com" "saily.dabhade@sungardas.com" "manisha.yadav@sungardas.com" "vijay.devshi@sungardas.com" "sudhir.tiwari@sungardas.com" "swapnil.khanvilkar@sungardas.com" "tanmay.yajnik@sungardas.com" "saifan.mandrupkar@sungardas.com" "jigyasa.upadhyay@sungardas.com" "sharad.mahagaonkar@sungardas.com" "shrikant.bajare@sungardas.com" "dhananjay.dahiwal@sungardas.com" "sakshi.bhat@sungardas.com" "sunny.edward@sungardas.com" "jashanpreet.sharma@sungardas.com" "ashwini.kulkarni@sungardas.com" "abid.jafri@sungardas.com" "sonam.ninawe@sungardas.com" "ria.rajput@sungardas.com" "shivangi.dubey@sungardas.com" "pranav.bhalerao@sungardas.com" "abhijit.ghatge@sungardas.com" "sumit.kumar@sungardas.com" "ajay.nade@sungardas.com" "aman.kumar@sungardas.com" "yashpal.chaudhari@sungardas.com" "sridhar.kommineni@sungardas.com" "shahnawaz.dhanse@sungardas.com" "danish.inamdar@sungardas.com" "giri.devale@sungardas.com" "stacy.mcclure@sungardas.com" "tammy.burns@sungardas.com" "eric.vashti@sungardas.com" "david.job@sungardas.com" "nicholas.delduca@sungardas.com" "jake.manders@sungardas.com" "joe.martinez@sungardas.com" "ryan.terry@sungardas.com" "don.trinh@sungardas.com" "josh.goldberg@sungardas.com" "sean.kelly@sungardas.com" "john.harbin@sungardas.com" "roger.mansard@sungardas.com" "scott.daly@sungardas.com" "brandon.betancourt@sungardas.com" "arthur.aringdale@sungardas.com" "aaron.kacere@sungardas.com" "alex.linder@sungardas.com" "jon.patton@sungardas.com" "andrew.stafford@sungardas.com" "neil.doyle@sungardas.com" "andrew.stafford@sungardas.com" "frank.cartwright@sungardas.com" "jason.blount@sungardas.com" "Kishori Gaikwad (On Maternity Leave till 11th May)")
# Create mail file
cat $HEADFILE > $MAILFILE
# Set up functions
buddy() {
NUM=$1
NAME=$(echo ${BUDDIES[$NUM]}|awk -F@ '{print $1 }'|awk -F. '{ print $1" "$2 }'|sed -r 's/([a-z]+) ([a-z]+)/\u\1 \u\2/')
	printf "<td font face="arial">"$NAME"</td>"	>> $MAILFILE
	awk -vcount=0 -vbuddy=${BUDDIES[$NUM]} -F'","' '($26~buddy) {count++} END {printf "<td font face="arial">"count"</td>"}' $OPEN >> $MAILFILE # Number of tickets assigned to this person
	awk -vcount=0 -vbuddy=${BUDDIES[$NUM]} -vtoday="$TODAY" -vyesterday="$YESTERDAY" -F'","' '($25~buddy)&&(($6~today)||($6~yesterday)) {count++} END {printf "<td class=xl693002>"count"</td>"}' $OPEN >> $MAILFILE # Number of tickets updated by that person
	awk -vcount=0 -vbuddy=${BUDDIES[$NUM]} -F'","' '($13~buddy) {count++} END {printf "<td class=xl693002>"count"</td>"}' $CLOSED >> $MAILFILE # Number of tickets closed by that person
}
buddydub() {
NUM=$1
NAME=$(echo ${BUDDIES[$NUM]}|awk -F@ '{print $1 }'|awk -F. '{ print $1" "$2 }'|sed -r 's/([a-z]+) ([a-z]+)/\u\1 \u\2/')
	printf "<td colspan="5" font face="arial">"$NAME"</td>"	>> $MAILFILE
	awk -vcount=0 -vbuddy=${BUDDIES[$NUM]} -F'","' '($26~buddy) {count++} END {printf "<td font face="arial">"count"</td>"}' $OPEN >> $MAILFILE # Number of tickets assigned to this person
	awk -vcount=0 -vbuddy=${BUDDIES[$NUM]} -vtoday="$TODAY" -vyesterday="$YESTERDAY" -F'","' '($25~buddy)&&(($6~today)||($6~yesterday)) {count++} END {printf "<td class=xl693002>"count"</td>"}' $OPEN >> $MAILFILE # Number of tickets updated by that person
	awk -vcount=0 -vbuddy=${BUDDIES[$NUM]} -F'","' '($13~buddy) {count++} END {printf "<td class=xl693002>"count"</td>"}' $CLOSED >> $MAILFILE # Number of tickets closed by that person
}
buddy2rows() {
NUM=$1
NAME=$(echo ${BUDDIES[$NUM]}|awk -F@ '{print $1 }'|awk -F. '{ print $1" "$2 }'|sed -r 's/([a-z]+) ([a-z]+)/\u\1 \u\2/')
	printf "<td rowspan="2" font face="arial">"$NAME"</td>"	>> $MAILFILE
	awk -vcount=0 -vbuddy=${BUDDIES[$NUM]} -F'","' '($26~buddy) {count++} END {printf "<td rowspan="2" font face="arial">"count"</td>"}' $OPEN >> $MAILFILE # Number of tickets assigned to this person
	awk -vcount=0 -vbuddy=${BUDDIES[$NUM]} -vtoday="$TODAY" -vyesterday="$YESTERDAY" -F'","' '($25~buddy)&&(($6~today)||($6~yesterday)) {count++} END {printf "<td rowspan="2" class=xl693002>"count"</td>"}' $OPEN >> $MAILFILE # Number of tickets updated by that person
	awk -vcount=0 -vbuddy=${BUDDIES[$NUM]} -F'","' '($13~buddy) {count++} END {printf "<td rowspan="2" class=xl693002>"count"</td>"}' $CLOSED >> $MAILFILE # Number of tickets closed by that person
}
buddy3rows() {
NUM=$1
NAME=$(echo ${BUDDIES[$NUM]}|awk -F@ '{print $1 }'|awk -F. '{ print $1" "$2 }'|sed -r 's/([a-z]+) ([a-z]+)/\u\1 \u\2/')
	printf "<td rowspan="3" font face="arial">"$NAME"</td>"	>> $MAILFILE
	awk -vcount=0 -vbuddy=${BUDDIES[$NUM]} -F'","' '($26~buddy) {count++} END {printf "<td rowspan="3" font face="arial">"count"</td>"}' $OPEN >> $MAILFILE # Number of tickets assigned to this person
	awk -vcount=0 -vbuddy=${BUDDIES[$NUM]} -vtoday="$TODAY" -vyesterday="$YESTERDAY" -F'","' '($25~buddy)&&(($6~today)||($6~yesterday)) {count++} END {printf "<td rowspan="3" class=xl693002>"count"</td>"}' $OPEN >> $MAILFILE # Number of tickets updated by that person
	awk -vcount=0 -vbuddy=${BUDDIES[$NUM]} -F'","' '($13~buddy) {count++} END {printf "<td rowspan="3" class=xl693002>"count"</td>"}' $CLOSED >> $MAILFILE # Number of tickets closed by that person
}
buddyor() {
NUM1=$1
NUM2=$2
BUDDY1=$(echo ${BUDDIES[$NUM1]} |awk -F@ '{print $1 }'|awk -F. '{ print $1" "$2 }'|sed -r 's/([a-z]+) ([a-z]+)/\u\1 \u\2/')
BUDDY2=$(echo ${BUDDIES[$NUM2]} |awk -F@ '{print $1 }'|awk -F. '{ print $1" "$2 }'|sed -r 's/([a-z]+) ([a-z]+)/\u\1 \u\2/')
	printf "<td>$BUDDY1/$BUDDY2</td>"	>> $MAILFILE
	awk -vcount=0 -vbuddy1=${BUDDIES[$NUM1]} -vbuddy2=${BUDDIES[$NUM2]} -F'","' '($26~buddy1)||($26~buddy2) {count++} END {printf "<td font face="arial">"count"</td>"}' $OPEN >> $MAILFILE # Number of tickets assigned to this person
	awk -vcount=0 -vbuddy1=${BUDDIES[$NUM1]} -vbuddy2=${BUDDIES[$NUM2]}  -vtoday="$TODAY" -vyesterday="$YESTERDAY" -F'","' '($25~buddy1)||($25~buddy2)&&(($6~today)||($6~yesterday)) {count++} END {printf "<td class=xl693002>"count"</td>"}' $OPEN >> $MAILFILE # Number of tickets updated by that person
	awk -vcount=0 -vbuddy1=${BUDDIES[$NUM1]} -vbuddy2=${BUDDIES[$NUM2]} -F'","' '($13~buddy1)||($13~buddy2) {count++} END {printf "<td class=xl693002>"count"</td>"}' $CLOSED >> $MAILFILE # Number of tickets closed by that person
}
teamall() {
TOT=0
for MEMBER in $@
	do MEMTOT=$(awk -vcount=0 -vbuddy=${BUDDIES[$MEMBER]} -F'","' '($26~buddy) { print }' $OPEN|wc -l)
	TOT=$(($TOT+$MEMTOT))
done
printf "<td font face="arial"><b>$TOT</b></td>"  >> $MAILFILE
}
teamall2() {
TOT=0
for MEMBER in $@
	do MEMTOT=$(awk -vcount=0 -vbuddy=${BUDDIES[$MEMBER]} -F'","' '($26~buddy) { print }' $OPEN|wc -l)
	TOT=$(($TOT+$MEMTOT))
done
printf "<td font face="arial" rowspan="2"><b>$TOT</b></td>"  >> $MAILFILE
}
teamall3() {
TOT=0
for MEMBER in $@
	do MEMTOT=$(awk -vcount=0 -vbuddy=${BUDDIES[$MEMBER]} -F'","' '($26~buddy) { print }' $OPEN|wc -l)
	TOT=$(($TOT+$MEMTOT))
done
printf "<td font face="arial" rowspan="3"><b>$TOT</b></td>"  >> $MAILFILE
}
teammail() {
FILE=/tmp/buddy-mail
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

</style></head><body>" > $TEAMMAIL
echo "<table><tr bgcolor="yellow"><td>Number</td><td>Assignment Group</td><td>Urgency</td><td>Priority</td><td>State</td><td>Short Description</td><td>Created</td><td>Updated</td><td>Company</td><td>Assignee</td></tr>" >> $TEAMMAIL
for MEMBER in $@
	do awk -vbuddy=${BUDDIES[$MEMBER]} -F'","' '($26~buddy) { print "<tr><td>"$1"</td><td>"$10"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$9"</td><td>"$6"</td><td>"$7"</td><td>"$12"</td><td>"$26"</td></tr>"}' $OPEN|sed 's/"//g' >> $TEAMMAIL
done
echo "</table>" >> $TEAMMAIL
unset IFS
ADDRESSES=$(for i in `awk -F'</td><td>' '{ print $10 }' $TEAMMAIL |awk -F'<' '{ print $1 }'|sed '1d'|uniq|grep @`; do printf "$i,"; done|sed '$s/.$//')
#ADDRESSES="paul.ferguson@sungardas.com,fergup@gmail.com"
mutt -e 'set content_type="text/html"' "$ADDRESSES" -c paul.ferguson@sungardas.com -s "### Your TOC Buddy list open tickets for $DDATE ###" < $TEAMMAIL
}
# Create HTML
printf "<body>
<H2 style='font-family:arial'>Network Buddies</H2>
<table border=1 cellpadding=0 cellspacing=0 width=1164 style='border-collapse:
 collapse;table-layout:fixed;width:873pt;font-family:arial;font-size:12;text-align:center' >
 <col width=82 style='mso-width-source:userset;mso-width-alt:2998;width:62pt'>
 <col class=xl6830022 width=53 style='mso-width-source:userset;mso-width-alt:
 1938;width:40pt'>
 <col width=152 style='width:114pt'>
 <col width=38 style='mso-width-source:userset;mso-width-alt:1389;width:29pt'>
 <col width=43 style='mso-width-source:userset;mso-width-alt:1572;width:32pt'>
 <col width=34 style='mso-width-source:userset;mso-width-alt:1243;width:26pt'>
 <col width=152 style='width:114pt'>
 <col width=35 span=3 style='mso-width-source:userset;mso-width-alt:1280;
 width:26pt'>
 <col width=152 style='width:114pt'>
 <col width=32 span=3 style='mso-width-source:userset;mso-width-alt:1170;
 width:24pt'>
 <col width=164 style='mso-width-source:userset;mso-width-alt:5997;width:123pt'>
 <col width=31 span=3 style='mso-width-source:userset;mso-width-alt:1133;
 width:23pt'>
 <tr height=22 style='height:16.5pt'>
  <td rowspan=2 height=44 class=xl6330022 width=82 style='border-bottom:1.0pt solid black;
  height:33.0pt;width:62pt'>Queue</td>
  <td rowspan=2 class=xl6330022 width=53 style='border-bottom:1.0pt solid black;
  width:40pt'>Team<span style='mso-spacerun:yes'> </span></td>
  <td colspan=8 class=xl6630022 width=524 style='border-right:1.0pt solid black;
  border-left:none;width:393pt'>India Buddies</td>
  <td colspan=8 class=xl6630022 width=505 style='border-left:none;width:378pt'>US Buddies</td>
  <td class=xl6630022 width=31 style='width:23pt' rowspan="2">Total A</td>
 </tr>
 <tr height=22 style='height:16.5pt'>
  <td height=22 class=xl8730022 width=152 style='height:16.5pt;width:114pt'>India
  - FED</td>
  <td class=xl8730022 width=38 style='width:29pt'>A</td>
  <td class=xl8730022 width=43 style='width:32pt'>U</td>
  <td class=xl8730022 width=34 style='width:26pt'>C</td>
  <td class=xl8730022 width=152 style='width:114pt'>India - BED</td>
  <td class=xl8730022 width=35 style='width:26pt'>A</td>
  <td class=xl8730022 width=35 style='width:26pt'>U</td>
  <td class=xl8730022 width=35 style='width:26pt'>C</td>
  <td class=xl8730022 width=152 style='width:114pt'>US - FED</td>
  <td class=xl8730022 width=32 style='width:24pt'>A</td>
  <td class=xl8730022 width=32 style='width:24pt'>U</td>
  <td class=xl8730022 width=32 style='width:24pt'>C</td>
  <td class=xl8730022 width=164 style='width:123pt'>US - BED</td>
  <td class=xl8730022 width=31 style='width:23pt'>A</td>
  <td class=xl8730022 width=31 style='width:23pt'>U</td>
  <td class=xl8730022 width=31 style='width:23pt'>C</td>
 </tr>
 <tr height=21 style='height:15.75pt;mso-yfti-irow:2'>
  <td rowspan=6 height=119 class=xl8830022 width=82 style='border-bottom:1.0pt solid black;
  height:89.25pt;border-top:none;width:62pt'>Tier 1</td>
  <td class=xl9930022 width=53 style='width:40pt'>A</td>" >> $MAILFILE
# Team A
buddy 7;buddy 8;buddy2rows 58;buddy2rows 21;teamall2 7 8 58 21 4 12;teammail 7 8 58 21 4 12
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>B</td>" >> $MAILFILE
# Team B
buddy 4;buddy 12
printf " </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>C</td>" >> $MAILFILE
buddy 15;buddy 18;buddy 50;buddy 22;teamall 15 18 22;teammail 15 18 22
printf " </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>D</td>" >> $MAILFILE
buddy 16;buddy 17;buddy 13;buddy 14;teamall 16 17 13 14;teammail 16 17 13 14
printf " </tr>
 <tr height=35 style='height:26.25pt'>
  <td rowspan="2" height=35 class=xl9930022 width=53 style='height:26.25pt;width:40pt'>E</td>" >> $MAILFILE
buddy 51;buddy 54;buddy 59;buddy2rows 63;teamall2 51 54 59 63 52 55 60;teammail 51 54 59 63 52 55 60
printf " </tr>
 <tr height=35 style='height:26.25pt'>" >> $MAILFILE
buddy 52;buddy 55;buddy 60
printf " </tr>
 <tr height=35 style='height:26.25pt;mso-yfti-irow:7'>
  <td rowspan=4 height=77 class=xl9130022 width=82 style='border-bottom:1.0pt solid black;
  height:57.75pt;border-top:none;width:62pt'>Tier 2</td>
  <td class=xl10030022 width=53 style='width:40pt'>F</td>" >> $MAILFILE
buddy 30;buddy 56;buddy 61;buddy 26;teamall 30 56 61 26;teammail 30 56 61 26
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl10030022 width=53 style='height:15.75pt;width:40pt'>G</td>" >> $MAILFILE
buddy 48;buddy 1;buddy 25;buddy 10;teamall 48 1 25 10;teammail 48 1 25 10
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl10030022 width=53 style='height:15.75pt;width:40pt'>H</td>" >> $MAILFILE
buddy 53;buddy 5;buddy 62;buddy 3;teamall 53 5 62 3;teammail  53 5 62 3
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl10030022 width=53 style='height:15.75pt;width:40pt'>I</td>" >> $MAILFILE
buddydub 125;buddy 32;buddy 33;teamall 32 33;teammail 32 33
printf "</tr>
 <tr height=21 style='height:15.75pt;mso-yfti-irow:10'>
  <td rowspan=2 colspan=2 height=42 class=xl9430022 width=82 style='border-bottom:1.0pt solid black;
  height:31.5pt;border-top:none;width:62pt'>Tier 3</td>" >> $MAILFILE
buddy 34;buddy 23;buddy 39;buddy 40;teamall2 34 23 39 40 28 38 29 37;teammail 34 23 39 40 28 38 29 37
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddy 28;buddy 38;buddy 29;buddy 37
printf " </tr>
 <tr height=21 style='height:15.75pt;mso-yfti-irow:12'>
  <td rowspan=2 colspan=2 height=42 class=xl9630022 width=82 style='border-bottom:1.0pt solid black;
  height:31.5pt;border-top:none;width:62pt'>Transport</td> " >> $MAILFILE
buddy 45;buddy 57;buddy 43;buddy 44;teamall2 45 57 43 44 11 46 47 64;teammail 45 57 43 44 11 46 47 64
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddy 11;buddy 46;buddy 47;buddy 64
printf "</tr>
 <![if supportMisalignedColumns]>
 <tr height=0 style='display:none'>
  <td width=82 style='width:62pt'></td>
  <td width=53 style='width:40pt'></td>
  <td width=152 style='width:114pt'></td>
  <td width=38 style='width:29pt'></td>
  <td width=43 style='width:32pt'></td>
  <td width=34 style='width:26pt'></td>
  <td width=152 style='width:114pt'></td>
  <td width=35 style='width:26pt'></td>
  <td width=35 style='width:26pt'></td>
  <td width=35 style='width:26pt'></td>
  <td width=152 style='width:114pt'></td>
  <td width=32 style='width:24pt'></td>
  <td width=32 style='width:24pt'></td>
  <td width=32 style='width:24pt'></td>
  <td width=164 style='width:123pt'></td>
  <td width=31 style='width:23pt'></td>
  <td width=31 style='width:23pt'></td>
  <td width=31 style='width:23pt'></td>
 </tr>
 <![endif]>
</table>
<span style=font-family:arial;font-size:12><b>Key: A</b> = All assigned tickets,<b> U</b> = Updated in last 24 hours,<b> C</b> = Closed in last 24 hours</span>
</div>
<H2 style='font-family:arial'>Compute Buddies</H2>
<table border=1 cellpadding=0 cellspacing=0 width=1164 style='border-collapse:
 collapse;table-layout:fixed;width:873pt;font-family:arial;font-size:12;text-align:center' >
 <col width=82 style='mso-width-source:userset;mso-width-alt:2998;width:62pt'>
 <col class=xl6830022 width=53 style='mso-width-source:userset;mso-width-alt:
 1938;width:40pt'>
 <col width=152 style='width:114pt'>
 <col width=38 style='mso-width-source:userset;mso-width-alt:1389;width:29pt'>
 <col width=43 style='mso-width-source:userset;mso-width-alt:1572;width:32pt'>
 <col width=34 style='mso-width-source:userset;mso-width-alt:1243;width:26pt'>
 <col width=152 style='width:114pt'>
 <col width=35 span=3 style='mso-width-source:userset;mso-width-alt:1280;
 width:26pt'>
 <col width=152 style='width:114pt'>
 <col width=32 span=3 style='mso-width-source:userset;mso-width-alt:1170;
 width:24pt'>
 <col width=164 style='mso-width-source:userset;mso-width-alt:5997;width:123pt'>
 <col width=31 span=3 style='mso-width-source:userset;mso-width-alt:1133;
 width:23pt'>
 <tr height=22 style='height:16.5pt'>
  <td rowspan=2 height=44 class=xl6330022 width=82 style='border-bottom:1.0pt solid black;
  height:33.0pt;width:62pt'>Queue</td>
  <td rowspan=2 class=xl6330022 width=53 style='border-bottom:1.0pt solid black;
  width:40pt'>Team<span style='mso-spacerun:yes'> </span></td>
  <td colspan=8 class=xl6630022 width=524 style='border-right:1.0pt solid black;
  border-left:none;width:393pt'>India Buddies</td>
  <td colspan=8 class=xl6630022 width=505 style='border-left:none;width:378pt'>US Buddies</td>
  <td class=xl6630022 width=31 style='width:23pt' rowspan="2">Total A</td>
 </tr>
 <tr height=22 style='height:16.5pt'>
  <td height=22 class=xl8730022 width=152 style='height:16.5pt;width:114pt'>India
  - FED</td>
  <td class=xl8730022 width=38 style='width:29pt'>A</td>
  <td class=xl8730022 width=43 style='width:32pt'>U</td>
  <td class=xl8730022 width=34 style='width:26pt'>C</td>
  <td class=xl8730022 width=152 style='width:114pt'>India - BED</td>
  <td class=xl8730022 width=35 style='width:26pt'>A</td>
  <td class=xl8730022 width=35 style='width:26pt'>U</td>
  <td class=xl8730022 width=35 style='width:26pt'>C</td>
  <td class=xl8730022 width=152 style='width:114pt'>US - FED</td>
  <td class=xl8730022 width=32 style='width:24pt'>A</td>
  <td class=xl8730022 width=32 style='width:24pt'>U</td>
  <td class=xl8730022 width=32 style='width:24pt'>C</td>
  <td class=xl8730022 width=164 style='width:123pt'>US - BED</td>
  <td class=xl8730022 width=31 style='width:23pt'>A</td>
  <td class=xl8730022 width=31 style='width:23pt'>U</td>
  <td class=xl8730022 width=31 style='width:23pt'>C</td>
 </tr>
 <tr height=21 style='height:15.75pt;mso-yfti-irow:2'>
  <td rowspan=13 height=119 class=xl8830022 width=82 style='border-bottom:1.0pt solid black;
  height:89.25pt;border-top:none;width:62pt'>Tier 1</td>
  <td rowspan=2 class=xl9930022 width=53 style='width:40pt'>A - Monitoring</td>" >> $MAILFILE
buddy2rows 65;buddy 83;buddy2rows 101;buddy2rows 114;teamall2 65 83 101 114 84;teammail 65 83 101 114 84
printf "</tr>
 <tr height=21 style='height:15.75pt'>"  >> $MAILFILE
buddy 84
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td rowspan=2 height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>B - Monitoring</td>" >> $MAILFILE
buddy 66;buddy 85;buddy2rows 102;buddy2rows 115;teamall2 66 85 102 115 67 86;teammail 66 85 102 115 67 86
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddy 67;buddy 86
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td rowspan=2 height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>C - Monitoring/Analyst</td>" >> $MAILFILE
buddy 68;buddy 87;buddy2rows 103;buddy2rows 116;teamall2 68 87 103 116;teammail 68 87 103 116
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddy 69;buddy 88
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td rowspan=3 height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>D - Monitoring/Analyst</td>" >> $MAILFILE
buddy 70;buddy 89;buddy3rows 104;buddy3rows 117;teamall3 70 89 104 117 71 90 72;teammail 70 89 104 117 71 90 72
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddy 71;buddy 90
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddydub 72
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td rowspan=2 height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>E - Systems Win/Evault</td>" >> $MAILFILE
buddy 73;buddy 91;buddy2rows 105;buddy2rows 118;teamall2 73 91 105 118 74 92;teammail 73 91 105 118 74 92
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddy 74;buddy 92
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td rowspan=2 height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>F - Systems Win</td>" >> $MAILFILE
buddy 75;buddy 93;buddy 106;buddy 119;teamall2 75 93 106 119 94 107;teammail 75 93 106 119 94 107
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddy 76;buddy 94; buddydub 107
printf " </tr>
 <tr height=35 style='height:26.25pt;mso-yfti-irow:7'>
  <td rowspan=7 height=77 class=xl9130022 width=82 style='border-bottom:1.0pt solid black;
  height:57.75pt;border-top:none;width:62pt'>Tier 2</td>
  <td rowspan=3 height=21 class=xl10030022 width=53 style='height:15.75pt;width:40pt'>G - System Win T2</td>" >> $MAILFILE
buddy 77;buddy 95;buddy3rows 108;buddy3rows 120;teamall3 77 95 108 120 78 96 79;teammail 77 95 108 120 78 96 79
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddy 78;buddy 96
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddydub 79
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td rowspan=2 height=21 class=xl10030022 width=53 style='height:15.75pt;width:40pt'>H - Systems Unix T2</td>" >> $MAILFILE
buddy2rows 80;buddy 97;buddy2rows 109;buddy2rows 2;teamall2 80 97 109 98;teammail 80 97 109 98
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddy 98
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td rowspan=2 height=21 class=xl10030022 width=53 style='height:15.75pt;width:40pt'>I - Systems Unix T2</td>" >> $MAILFILE
buddy 81;buddy 99;buddy2rows 110;buddy2rows 121;teamall2 81 99 110 121;teammail 81 99 110 121
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddy 82;buddy 100
printf "</tr>
 <tr height=21 style='height:15.75pt;mso-yfti-irow:10'>
  <td rowspan=3  height=42 class=xl9430022 width=82 style='border-bottom:1.0pt solid black;
  height:31.5pt;border-top:none;width:62pt'>Tier 3</td><td class=xl9430022 width=53 style='width:40pt'>Tier 3 Win</td>" >> $MAILFILE
buddy 2;buddy 2;buddy 111;buddy 120;teamall 111 120;teammail 111 120
printf "</tr>
 <tr height=21 style='height:15.75pt'>
   <td height=21 class=xl9430022 width=53 style='height:15.75pt;width:40pt'>Tier 3 Win</td>" >> $MAILFILE
buddy 2;buddy 2;buddy 112;buddy 123;teamall 112 123;teammail 112 123
printf "</tr>
 <tr height=21 style='height:15.75pt'>
   <td height=21 class=xl9430022 width=53 style='height:15.75pt;width:40pt'>Tier 3 Unix</td>" >> $MAILFILE
buddy 2;buddy 2;buddy 113;buddy 124;teamall 113 124;teammail 113 124
printf "</tr>
 <![if supportMisalignedColumns]>
 <tr height=0 style='display:none'>
  <td width=82 style='width:62pt'></td>
  <td width=53 style='width:40pt'></td>
  <td width=152 style='width:114pt'></td>
  <td width=38 style='width:29pt'></td>
  <td width=43 style='width:32pt'></td>
  <td width=34 style='width:26pt'></td>
  <td width=152 style='width:114pt'></td>
  <td width=35 style='width:26pt'></td>
  <td width=35 style='width:26pt'></td>
  <td width=35 style='width:26pt'></td>
  <td width=152 style='width:114pt'></td>
  <td width=32 style='width:24pt'></td>
  <td width=32 style='width:24pt'></td>
  <td width=32 style='width:24pt'></td>
  <td width=164 style='width:123pt'></td>
  <td width=31 style='width:23pt'></td>
  <td width=31 style='width:23pt'></td>
  <td width=31 style='width:23pt'></td>
 </tr>
 <![endif]>
</table>
<span style=font-family:arial;font-size:12><b>Key: A</b> = All assigned tickets,<b> U</b> = Updated in last 24 hours,<b> C</b> = Closed in last 24 hours</span>
</div>
</body>

</html>" >> $MAILFILE
unset IFS
# Create PDF
cp $MAILFILE $HTMLFILE
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,xande.craveiro-lopes@sungardas.com,jan.clayton-adamson@sungardas.com"  -s "### Daily TOC Buddy List for $DDATE ###" < $MAILFILE 
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com"  -s "### Daily TOC Buddy List ###"  < $MAILFILE 
