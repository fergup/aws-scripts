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
IFS=
# Useful files
HEADFILE=/data/buddy/buddy_head
MAILFILE=/data/mail/buddy_all_mail
HTMLFILE=/data/mail/buddy_all.html
#BUDDIES=("Sawan Anarse" "Nikhil Brij" "Mary DeLisle" "Tanveer Jinabade" "Sravani Potharaju" "John Slomski" "Ketan Belekar" "Sumeet Kondvilkar" "Gautham Gavini" "Vivek Mayuranathan" "Tanmayee Deshpande" "Akshay Behere" "Adam Bergquist" "Brad Barnhart" "Rutuja  TBJ" "Rimi Deka" "Tejashree" "Abhinav" "Ken Crandall" "Xande" "David Reese" "Nathan Pyle" "Haris Majeed" "Jay Jani" "Rich Blea" "Joshua Johnson" "TBH" "Rahul Kumar" "Jarrod Porter" "Tribhawan Singh" "Geetha Arumugham" "Sean Kerrane" "Matt Lemmo" "Anand Mittal" "TBJ (Haider Syed)" "Rob Fye" "Rob Vrba" "Anshul Jain" "" "Kevin Leydon" "Steve Nold" "TBH" "Rohit Malvade" "Terry Sims" "Cory Cass" "Debajyoti Debnath" "Rahil Bhatkar" "Adam Mathis" "Kavish Agnani" "Kishori Gaikwad")
BUDDIES=("sawan.anarse@sungardas.com" "nikhil.brij@sungardas.com" "mary.delisle@sungardas.com" "tanveer.jinabade@sungardas.com" "sravani.potharaju@sungardas.com" "john.slomski@sungardas.com" "ketan.belekar@sungardas.com" "sumeet.kondvilkar@sungardas.com" "gautham.gavini@sungardas.com" "vivek.mayuranathan@sungardas.com" "tanmayee.deshpande@sungardas.com" "akshay.behere@sungardas.com" "adam.bergquist@sungardas.com" "brad.barnhart@sungardas.com" "rutuja..tbj@sungardas.com" "rimi.deka@sungardas.com" "tejashree@sungardas.com" "abhinav@sungardas.com" "ken.crandall@sungardas.com" "xande.craveiro-lopes@sungardas.com" "david.reese@sungardas.com" "nathan.pyle@sungardas.com" "haris.majeed@sungardas.com" "jay.jani@sungardas.com" "rich.blea@sungardas.com" "joshua.johnson@sungardas.com" "tbh@sungardas.com" "rahul.kumar@sungardas.com" "jarrod.porter@sungardas.com" "tribhawan.singh@sungardas.com" "geetha.arumugham@sungardas.com" "sean.kerrane@sungardas.com" "matt.lemmo@sungardas.com" "anand.mittal@sungardas.com" "tbj.(haider.syed)@sungardas.com" "rob.fye@sungardas.com" "rob.vrba@sungardas.com" "anshul.jain@sungardas.com" "kevin.leydon@sungardas.com" "steve.nold@sungardas.com" "tbh@sungardas.com" "rohit.malvade@sungardas.com" "terry.sims@sungardas.com" "cory.cass@sungardas.com" "debajyoti.debnath@sungardas.com" "rahil.bhatkar@sungardas.com" "adam.mathis@sungardas.com" "kavish.agnani@sungardas.com" "kishori.gaikwad@sungardas.com" "gobbldygook@sungardas.com")
# Create mail file
cat $HEADFILE > $MAILFILE
# GLOB table
buddy() {
NUM=$1
	printf "<td>"${BUDDIES[$NUM]}"</td>"	
	awk -vbuddy=${BUDDIES[$NUM]} -F'","' '($26~buddy) {count++} END {printf "<td>"count"</td>"}' $OPEN # Number of tickets assigned to this person
	awk -vbuddy=${BUDDIES[$NUM]} -F'","' '($25~buddy) {count++} END {printf "<td>"count"</td>"}' $OPEN # Number of tickets updated by that person
	awk -vbuddy=${BUDDIES[$NUM]} -F'","' '($13~buddy) {count++} END {printf "<td>"count"</td>"}' $CLOSED >> $MAILFILE # Number of tickets closed by that person
}

printf "
<div id="buddy2_30022" align=center x:publishsource="Excel">
<table border=0 cellpadding=0 cellspacing=0 width=1164 style='border-collapse:
 collapse;table-layout:fixed;width:873pt'>
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
  <td class=xl8730022 width=38 style='width:29pt'>O</td>
  <td class=xl8730022 width=43 style='width:32pt'>U</td>
  <td class=xl8730022 width=34 style='width:26pt'>C</td>
  <td class=xl8730022 width=152 style='width:114pt'>India - BED</td>
  <td class=xl8730022 width=35 style='width:26pt'>O</td>
  <td class=xl8730022 width=35 style='width:26pt'>U</td>
  <td class=xl8730022 width=35 style='width:26pt'>C</td>
  <td class=xl8730022 width=152 style='width:114pt'>US - FED</td>
  <td class=xl8730022 width=32 style='width:24pt'>O</td>
  <td class=xl8730022 width=32 style='width:24pt'>U</td>
  <td class=xl8730022 width=32 style='width:24pt'>C</td>
  <td class=xl8730022 width=164 style='width:123pt'>US - BED</td>
  <td class=xl8730022 width=31 style='width:23pt'>O</td>
  <td class=xl8730022 width=31 style='width:23pt'>U</td>
  <td class=xl8730022 width=31 style='width:23pt'>C</td>
 </tr>
 <tr height=21 style='height:15.75pt;mso-yfti-irow:2'>
  <td rowspan=5 height=119 class=xl8830022 width=82 style='border-bottom:1.0pt solid black;
  height:89.25pt;border-top:none;width:62pt'>Tier 1</td>
  <td class=xl9930022 width=53 style='width:40pt'>A</td>
  <td class=xl6930022 width=152 style='width:114pt'>Sawan Anarse</td>
  <td class=xl6930022 width=38 style='width:29pt'>&nbsp;</td>
  <td class=xl6930022 width=43 style='width:32pt'>&nbsp;</td>
  <td class=xl6930022 width=34 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=152 style='width:114pt'>Nikhil Brij</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7030022 width=152 style='width:114pt'>&nbsp;</td>
  <td class=xl6930022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl6930022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl6930022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl6930022 width=164 style='width:123pt'>Mary DeLisle</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>B</td>
  <td class=xl6930022 width=152 style='width:114pt'>Tanveer Jinabade</td>
  <td class=xl6930022 width=38 style='width:29pt'>&nbsp;</td>
  <td class=xl6930022 width=43 style='width:32pt'>&nbsp;</td>
  <td class=xl6930022 width=34 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=152 style='width:114pt'>Sravani Potharaju</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td colspan=5 class=xl7130022 width=412 style='border-right:1.0pt solid black;
  border-left:none;width:309pt'>John Slomski</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>C</td>
  <td class=xl6930022 width=152 style='width:114pt'>Ketan Belekar</td>
  <td class=xl6930022 width=38 style='width:29pt'>&nbsp;</td>
  <td class=xl6930022 width=43 style='width:32pt'>&nbsp;</td>
  <td class=xl6930022 width=34 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=152 style='width:114pt'>Sumeet Kondvilkar</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=152 style='width:114pt'>Gautham Gavini</td>
  <td class=xl6930022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl6930022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl6930022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl6930022 width=164 style='width:123pt'>Vivek Mayuranathan</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl9930022 width=53 style='height:15.75pt;width:40pt'>D</td>
  <td class=xl6930022 width=152 style='width:114pt'>Tanmayee Deshpande</td>
  <td class=xl6930022 width=38 style='width:29pt'>&nbsp;</td>
  <td class=xl6930022 width=43 style='width:32pt'>&nbsp;</td>
  <td class=xl6930022 width=34 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=152 style='width:114pt'>Akshay Behere</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=152 style='width:114pt'>Adam Bergquist</td>
  <td class=xl6930022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl6930022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl6930022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl6930022 width=164 style='width:123pt'>Brad Barnhart</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
 <tr height=35 style='height:26.25pt'>
  <td height=35 class=xl9930022 width=53 style='height:26.25pt;width:40pt'>E</td>
  <td class=xl6930022 width=152 style='width:114pt'>Rutuja / TBJ (Rimi Deka)</td>
  <td class=xl6930022 width=38 style='width:29pt'>&nbsp;</td>
  <td class=xl6930022 width=43 style='width:32pt'>&nbsp;</td>
  <td class=xl6930022 width=34 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=152 style='width:114pt'>Tejashree / Abhinav</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl6930022 width=152 style='width:114pt'>Ken Crandall / Xande</td>
  <td class=xl6930022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl6930022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl6930022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl6930022 width=164 style='width:123pt'>David Reese / Nathan Pyle</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl6930022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
 <tr height=35 style='height:26.25pt;mso-yfti-irow:7'>
  <td rowspan=3 height=77 class=xl9130022 width=82 style='border-bottom:1.0pt solid black;
  height:57.75pt;border-top:none;width:62pt'>Tier 2</td>
  <td class=xl10030022 width=53 style='width:40pt'>F</td>
  <td class=xl7430022 width=152 style='width:114pt'>Haris Majeed</td>
  <td class=xl7430022 width=38 style='width:29pt'>&nbsp;</td>
  <td class=xl7430022 width=43 style='width:32pt'>&nbsp;</td>
  <td class=xl7430022 width=34 style='width:26pt'>&nbsp;</td>
  <td class=xl7430022 width=152 style='width:114pt'>Jay Jani (Jay Leaving, TBH)</td>
  <td class=xl7430022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7430022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7430022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7430022 width=152 style='width:114pt'>Rich Blea</td>
  <td class=xl7430022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7430022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7430022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7430022 width=164 style='width:123pt'>Joshua Johnson</td>
  <td class=xl7430022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl7430022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl7430022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl10030022 width=53 style='height:15.75pt;width:40pt'>G</td>
  <td class=xl7430022 width=152 style='width:114pt'>TBH</td>
  <td class=xl7430022 width=38 style='width:29pt'>&nbsp;</td>
  <td class=xl7430022 width=43 style='width:32pt'>&nbsp;</td>
  <td class=xl7430022 width=34 style='width:26pt'>&nbsp;</td>
  <td class=xl7430022 width=152 style='width:114pt'>Rahul Kumar</td>
  <td class=xl7430022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7430022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7430022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7430022 width=152 style='width:114pt'>Jarrod Porter</td>
  <td class=xl7430022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7430022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7430022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7530022 width=164 style='width:123pt'>&nbsp;</td>
  <td class=xl7430022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl7430022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl7430022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl10030022 width=53 style='height:15.75pt;width:40pt'>H</td>
  <td class=xl7430022 width=152 style='width:114pt'>Tribhawan Singh</td>
  <td class=xl7430022 width=38 style='width:29pt'>&nbsp;</td>
  <td class=xl7430022 width=43 style='width:32pt'>&nbsp;</td>
  <td class=xl7430022 width=34 style='width:26pt'>&nbsp;</td>
  <td class=xl7430022 width=152 style='width:114pt'>Geetha Arumugham</td>
  <td class=xl7430022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7430022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7430022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7430022 width=152 style='width:114pt'>Sean Kerrane</td>
  <td class=xl7430022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7430022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7430022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7430022 width=164 style='width:123pt'>Matt Lemmo</td>
  <td class=xl7430022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl7430022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl7430022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
 <tr height=21 style='height:15.75pt;mso-yfti-irow:10'>
  <td rowspan=2 height=42 class=xl9430022 width=82 style='border-bottom:1.0pt solid black;
  height:31.5pt;border-top:none;width:62pt'>Tier 3</td>
  <td rowspan=2 class=xl9430022 width=53 style='border-bottom:1.0pt solid black;
  border-top:none;width:40pt'>I</td>
  <td class=xl7630022 width=152 style='width:114pt'>Anand Mittal</td>
  <td class=xl7630022 width=38 style='width:29pt'>&nbsp;</td>
  <td class=xl7630022 width=43 style='width:32pt'>&nbsp;</td>
  <td class=xl7630022 width=34 style='width:26pt'>&nbsp;</td>
  <td class=xl7630022 width=152 style='width:114pt'>TBJ (Haider Syed)</td>
  <td class=xl7630022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7630022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7630022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7630022 width=152 style='width:114pt'>Rob Fye</td>
  <td class=xl7630022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7630022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7630022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7630022 width=164 style='width:123pt'>Rob Vrba</td>
  <td class=xl7630022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl7630022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl7630022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
 <tr height=21 style='height:15.75pt'>
  <td colspan=5 height=21 class=xl7730022 width=419 style='border-right:1.0pt solid black;
  height:15.75pt;border-left:none;width:315pt'>Anshul Jain</td>
  <td class=xl8030022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl8030022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl8030022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl7630022 width=152 style='width:114pt'>Kevin Leydon</td>
  <td class=xl8030022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl8030022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl8030022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl7630022 width=164 style='width:123pt'>Steve Nold</td>
  <td class=xl8030022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl8030022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl8030022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
 <tr height=21 style='height:15.75pt;mso-yfti-irow:12'>
  <td rowspan=2 height=42 class=xl9630022 width=82 style='border-bottom:1.0pt solid black;
  height:31.5pt;border-top:none;width:62pt'>Transport</td>
  <td rowspan=2 class=xl9630022 width=53 style='border-bottom:1.0pt solid black;
  border-top:none;width:40pt'>T</td>
  <td class=xl8130022 width=152 style='width:114pt'>TBH</td>
  <td class=xl8130022 width=38 style='width:29pt'>&nbsp;</td>
  <td class=xl8130022 width=43 style='width:32pt'>&nbsp;</td>
  <td class=xl8130022 width=34 style='width:26pt'>&nbsp;</td>
  <td class=xl8130022 width=152 style='width:114pt'>Rohit Malvade</td>
  <td class=xl8130022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl8130022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl8130022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl8130022 width=152 style='width:114pt'>Terry Sims</td>
  <td class=xl8130022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl8130022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl8130022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl8130022 width=164 style='width:123pt'>Cory Cass</td>
  <td class=xl8130022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl8130022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl8130022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
 <tr height=21 style='height:15.75pt'>
  <td height=21 class=xl8130022 width=152 style='height:15.75pt;width:114pt'>Debajyoti
  Debnath</td>
  <td class=xl8130022 width=38 style='width:29pt'>&nbsp;</td>
  <td class=xl8130022 width=43 style='width:32pt'>&nbsp;</td>
  <td class=xl8130022 width=34 style='width:26pt'>&nbsp;</td>
  <td class=xl8130022 width=152 style='width:114pt'>Rahil Bhatkar</td>
  <td class=xl8130022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl8130022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl8130022 width=35 style='width:26pt'>&nbsp;</td>
  <td colspan=5 class=xl8230022 width=412 style='border-right:1.0pt solid black;
  border-left:none;width:309pt'>Adam Mathis</td>
  <td class=xl8130022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl8130022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl8130022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
 <tr height=21 style='height:15.75pt;mso-yfti-irow:14;mso-yfti-lastrow:yes'>
  <td height=21 class=xl9830022 width=82 style='height:15.75pt;width:62pt'>Tier
  1 / 2</td>
  <td class=xl10130022 width=53 style='width:40pt'>J</td>
  <td class=xl8530022 width=152 style='width:114pt'>Kavish Agnani</td>
  <td class=xl8530022 width=38 style='width:29pt'>&nbsp;</td>
  <td class=xl8530022 width=43 style='width:32pt'>&nbsp;</td>
  <td class=xl8530022 width=34 style='width:26pt'>&nbsp;</td>
  <td class=xl8530022 width=152 style='width:114pt'>Kishori Gaikwad</td>
  <td class=xl8530022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl8530022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl8530022 width=35 style='width:26pt'>&nbsp;</td>
  <td class=xl8630022 width=152 style='width:114pt'>&nbsp;</td>
  <td class=xl8530022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl8530022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl8530022 width=32 style='width:24pt'>&nbsp;</td>
  <td class=xl8630022 width=164 style='width:123pt'>&nbsp;</td>
  <td class=xl8530022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl8530022 width=31 style='width:23pt'>&nbsp;</td>
  <td class=xl8530022 width=31 style='width:23pt'>&nbsp;</td>
 </tr>
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
</div>
</body>

</html>" >> $MAILFILE
unset IFS
# Create PDF
cp $MAILFILE $HTMLFILE
#mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com,pushkar.shirolkar@sungardas.com,jan.clayton-adamson@sungardas.com,kevin.erickson@sungardas.com,paul.higgins@sungardas.com,as.toc.network.management@sungardas.com,mark.hill@sungardas.com" -s "### Daily Global Open Ticket Report ###" -a $RRDGRAPH < $MAILFILE
mutt -e 'set content_type="text/html"' "paul.ferguson@sungardas.com"  -s "### TEST Daily TOC Buddy List ###" < $MAILFILE 
#mv /tmp/*.mail /data/sn/archive
