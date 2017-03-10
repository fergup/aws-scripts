#!/bin/bash
###################################################################################
#
# buddy_list.sh
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
BUDDIES=("sawan.anarse@sungardas.com" "nikhil.brij@sungardas.com" "nobody@sungardas.com" "mary.delisle@sungardas.com" "tanveer.jinabade@sungardas.com" "sravani.potharaju@sungardas.com" "john.slomski@sungardas.com" "ketan.belekar@sungardas.com" "sumeet.kondvilkar@sungardas.com" "gautham.gavini@sungardas.com" "vivek.mayuranathan@sungardas.com" "tanmayee.deshpande@sungardas.com" "akshay.behere@sungardas.com" "adam.bergquist@sungardas.com" "brad.barnhart@sungardas.com" "rutuja.albur@sungardas.com" "rimi.deka@sungardas.com" "tejashree.nagawade@sungardas.com" "abhinav.wakhloo@sungardas.com" "ken.crandall@sungardas.com" "xande.craveiro-lopes@sungardas.com" "david.reese@sungardas.com" "nathan.pyle@sungardas.com" "haris.majeed@sungardas.com" "jay.jani@sungardas.com" "rich.blea@sungardas.com" "joshua.johnson@sungardas.com" "tbh@sungardas.com" "rahul.kumar@sungardas.com" "jarrod.porter@sungardas.com" "tribhawan.singh@sungardas.com" "geetha.arumugham@sungardas.com" "sean.kerrane@sungardas.com" "matt.lemmo@sungardas.com" "anand.mittal@sungardas.com" "haider.syed@sungardas.com" "rob.fye@sungardas.com" "rob.vrba@sungardas.com" "anshul.jain@sungardas.com" "kevin.leydon@sungardas.com" "steve.nold@sungardas.com" "tbh@sungardas.com" "rohit.malvade@sungardas.com" "terry.sims@sungardas.com" "cory.cass@sungardas.com" "debajyoti.debnath@sungardas.com" "rahil.bhatkar@sungardas.com" "adam.mathis@sungardas.com" "kavish.agnani@sungardas.com" "kishori.gaikwad@sungardas.com" "nobody@sungardas.com")
# Create mail file
cat $HEADFILE > $MAILFILE
# GLOB table
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

printf "<body>
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
  <td colspan=8 class=xl6630022 width=505 style='border-left:none;width:378pt'>US
  Buddies</td>
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
  <td rowspan=5 height=119 class=xl8830022 width=82 style='border-bottom:1.0pt solid black;
  height:89.25pt;border-top:none;width:62pt'>Tier 1</td>
  <td class=xl9930022 width=53 style='width:40pt'>A</td>" >> $MAILFILE
# Team A
buddy 0;buddy 1;buddy 2;buddy 3
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>B</td>" >> $MAILFILE
# Team B
buddy 4;buddy 5;buddydub 6
printf " </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>C</td>" >> $MAILFILE
buddy 7;buddy 8;buddy 9;buddy 10
printf " </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>D</td>" >> $MAILFILE
buddy 11;buddy 12;buddy 13;buddy 14
printf " </tr>
 <tr height=35 style='height:26.25pt'>
  <td height=35 class=xl9930022 width=53 style='height:26.25pt;width:40pt'>E</td>" >> $MAILFILE
buddyor 15 16;buddyor 17 18;buddyor 19 20;buddyor 21 22
printf " </tr>
 <tr height=35 style='height:26.25pt;mso-yfti-irow:7'>
  <td rowspan=3 height=77 class=xl9130022 width=82 style='border-bottom:1.0pt solid black;
  height:57.75pt;border-top:none;width:62pt'>Tier 2</td>
  <td class=xl10030022 width=53 style='width:40pt'>F</td>" >> $MAILFILE
buddy 23;buddy 24;buddy 25;buddy 26
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl10030022 width=53 style='height:15.75pt;width:40pt'>G</td>" >> $MAILFILE
buddy 27;buddy 28;buddy 29;buddy 2
printf "</tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl10030022 width=53 style='height:15.75pt;width:40pt'>H</td>" >> $MAILFILE
buddy 30;buddy 31;buddy 32;buddy 33
printf "</tr>
 <tr height=21 style='height:15.75pt;mso-yfti-irow:10'>
  <td rowspan=2 height=42 class=xl9430022 width=82 style='border-bottom:1.0pt solid black;
  height:31.5pt;border-top:none;width:62pt'>Tier 3</td>
  <td rowspan=2 class=xl9430022 width=53 style='border-bottom:1.0pt solid black;
  border-top:none;width:40pt'>I</td>" >> $MAILFILE
buddy 34;buddy 35;buddy 36;buddy 37
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddydub 38;buddy 39;buddy 40
printf " </tr>
 <tr height=21 style='height:15.75pt;mso-yfti-irow:12'>
  <td rowspan=2 height=42 class=xl9630022 width=82 style='border-bottom:1.0pt solid black;
  height:31.5pt;border-top:none;width:62pt'>Transport</td>
  <td rowspan=2 class=xl9630022 width=53 style='border-bottom:1.0pt solid black;
  border-top:none;width:40pt'>T</td>" >> $MAILFILE
buddy 41;buddy 42;buddy 43;buddy 44
printf "</tr>
 <tr height=21 style='height:15.75pt'>" >> $MAILFILE
buddy 45;buddy 46;buddydub 47
printf "</tr>
 <tr height=21 style='height:15.75pt;mso-yfti-irow:14;mso-yfti-lastrow:yes'>
  <td height=21 class=xl9830022 width=82 style='height:15.75pt;width:62pt'>Tier
  1 / 2</td>
  <td class=xl10130022 width=53 style='width:40pt'>J</td>" >> $MAILFILE
buddy 48;buddy 49;buddy 2;buddy 2
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
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,pushkar.shirolkar@sungardas.com,jan.clayton-adamson@sungardas.com,kevin.erickson@sungardas.com,paul.higgins@sungardas.com,as.toc.network.management@sungardas.com,mark.hill@sungardas.com" -s "### Daily Global Open Ticket Report ###" -a $RRDGRAPH < $MAILFILE
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com"  -s "### TEST Daily TOC Buddy List ###" < $MAILFILE 