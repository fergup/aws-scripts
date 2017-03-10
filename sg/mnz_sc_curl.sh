#!/bin/bash
###################################################################################
#
# mnz_sc_curl.sh
# --------------
# Auto-populates Service Center via the Spotlight API for Menzies
#
# Version Control
# ---------------------------------------------------------------------------------
# | Version |   Date   | Author | Comments
# ---------------------------------------------------------------------------------
# |   1.0   | 11/03/16 |  PRF   | First edition
# ---------------------------------------------------------------------------------
#
# Working example:
# ----------------
#  curl  -H "Authorization:5bc63cd5088e4d5c4c0ed3fefa1aff43" -H "Content-Type: application/json" -X POST -d '{"vendor_id": "HP","vendor_model": "MODEL123","serial_number": "ADPCURLTST123","company_use": "SUNGARD","company_own": "SUNGARD","contracting_company": "SUNGARD","location": "PA.PHILADELPHIA.011","ip_address": "67.67.67.1","ip_hostname": "my-bogus-test-1","server_os": "LINUX","istatus": "Installed-Active"}' https://staging.sl.tools.sgns.net/api/sc/servers
###################################################################################
# Set variables
UATAPI=https://staging.sl.tools.sgns.net/api/sc/servers
PRODAPI=spotlight.sungardas.com/api/sc/servers
UATTOKEN=5bc63cd5088e4d5c4c0ed3fefa1aff43
PRODTOKEN=19d045254c8b3881ea0d62c4996116bc
>/tmp/ppp
# Dates
uat() {
HOSTNAME=$1
IP=$5
LOCATION=$9
VENDOR=$2
MODEL=$3
OS=$7
SERIAL=$4
DESC=$8
#echo "$HOSTNAME,$IP,$LOCATION,$VENDOR,$MODEL,$OS,$SERIAL"
echo "curl -k -H \"Authorization: Token token=$PRODTOKEN\" -H \"Content-Type: application/json\" -X POST -d \'{\"vendor_id\": \"$VENDOR\",\"vendor_model\": \"$MODEL\",\"serial_number\": \"$SERIAL\",\"company_use\": \"MENZIES PLC\",\"company_own\": \"SASU\",\"contracting_company\": \"MENZIES PLC\",\"location\": \"$LOCATION\",\"ip_address\": \"$IP\",\"ip_hostname\": \"$HOSTNAME\",\"server_os\": \"$OS\",\"istatus\": \"Installed-Active\",\"description\": \"$DESC\"}\' $PRODAPI" >> /tmp/ppp
}
#
# THIS ACTUALLY WORKED 
#
# curl -H "Authorization: Token token=5bc63cd5088e4d5c4c0ed3fefa1aff43" -H "Content-Type: application/json" -X POST -d '{"vendor_id": "HP","vendor_model": "MODEL123","serial_number": "ADPCURLTST123","company_use": "SUNGARD","company_own": "SUNGARD","contracting_company": "SUNGARD","location": "PA.PHILADELPHIA.011","ip_address": "67.67.67.1","ip_hostname": "my-bogus-test-1","server_os": "LINUX","istatus": "Installed-Active"}' https://staging.sl.tools.sgns.net/api/sc/servers
#uat "5as-am-dc01" "MICROSOFT" "Virtual Machine" "1302-2083-6736-9672-5387-2615-98" "10.3.90.87" "5as-am-dc01" "WINDOWS" "Menzies Aviation DC Server" GB:BRACKNELL.001"
#uat "5as-as-dc01" "MICROSOFT" "Virtual Machine" "2987-9223-2411-2160-7788-1147-41" "10.3.90.88" "5as-as-dc01" "WINDOWS" "Menzies Aviation DC Server" GB:BRACKNELL.001"
#uat "5as-em-arc1" "DELL" "PowerEdge R710" "FC1RT4J" "10.200.16.87" "5as-em-arc1" "WINDOWS" "Menzies Aviation Cpmmvault Archive Server" GB:BRACKNELL.001"
#uat "5as-em-audit1" "MICROSOFT" "Virtual Machine" "7003-1970-9087-9813-7841-7518-26" "10.3.91.69" "5as-em-audit1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.001"
#uat "5as-em-back1" "DELL" "PowerEdge R620" "J3MJD5J" "10.200.16.110" "5as-em-back1" "WINDOWS" "Menzies Aviation Commserve Server" GB:BRACKNELL.001"
#uat "5as-em-cv1" "DELL" "PowerEdge R720" "3ZVJD5J" "10.3.130.26" "5as-em-cv1" "WINDOWS" "Menzies Aviation Commvault Media Server" GB:BRACKNELL.001"
#uat "5as-em-data1" "DELL" "PowerEdge R620" "558JD5J" "10.200.16.61" "5as-em-data1" "WINDOWS" "Menzies Aviation Data Server" GB:BRACKNELL.001"
#uat "5as-em-data2" "DELL" "PowerEdge R620" "658JD5J" "10.200.16.62" "5as-em-data2" "WINDOWS" "Menzies Aviation Data Server" GB:BRACKNELL.001"
#uat "5as-em-dc01" "MICROSOFT" "Virtual Machine" "2457-4680-6236-3614-8627-3077-84" "10.3.90.86" "5as-em-dc01" "WINDOWS" "Menzies Aviation DC Server" GB:BRACKNELL.001"
#uat "5as-em-exch1" "MICROSOFT" "Virtual Machine" "6010-8880-5759-7894-9078-7128-62" "10.3.92.37" "5as-em-exch1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.001"
#uat "5as-em-exch2" "MICROSOFT" "Virtual Machine" "1845-9411-7027-0139-1774-7386-21" "10.3.92.38" "5as-em-exch2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.001"
#uat "5as-em-fedex02" "MICROSOFT" "Virtual Machine" "8191-4921-3714-5616-5226-0957-55" "10.3.93.100" "5as-em-fedex02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.001"
#uat "5as-em-gns3" "MICROSOFT" "Virtual Machine" "7883-7898-9279-0547-3594-1124-05" "10.3.95.164" "5as-em-gns3" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.001"
#uat "5as-em-hv01" "DELL" "PowerEdge R720" "878RD5J" "10.200.16.10" "5as-em-hv01" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.001"
#uat "5as-em-hv02" "DELL" "PowerEdge R720" "G68RD5J" "10.200.16.8" "5as-em-hv02" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.001"
#uat "5as-em-hv03" "DELL" "PowerEdge R720" "H68RD5J" "10.200.16.12" "5as-em-hv03" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.001"
#uat "5as-em-hv04" "DELL" "PowerEdge R720" "J68RD5J" "10.200.16.13" "5as-em-hv04" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.001"
uat "5as-am-dc01" "MICROSOFT" "Virtual Machine" "1302-2083-6736-9672-5387-2615-98" "10.3.90.87" "5as-am-dc01" "WINDOWS" "Menzies Aviation DC Server" GB:BRACKNELL.102
uat "5as-as-dc01" "MICROSOFT" "Virtual Machine" "2987-9223-2411-2160-7788-1147-41" "10.3.90.88" "5as-as-dc01" "WINDOWS" "Menzies Aviation DC Server" GB:BRACKNELL.102
uat "5as-em-arc1" "DELL" "PowerEdge R710" "FC1RT4J" "10.200.16.87" "5as-em-arc1" "WINDOWS" "Menzies Aviation Cpmmvault Archive Server" GB:BRACKNELL.102
uat "5as-em-audit1" "MICROSOFT" "Virtual Machine" "7003-1970-9087-9813-7841-7518-26" "10.3.91.69" "5as-em-audit1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-back1" "DELL" "PowerEdge R620" "J3MJD5J" "10.200.16.110" "5as-em-back1" "WINDOWS" "Menzies Aviation Commserve Server" GB:BRACKNELL.102
uat "5as-em-cv1" "DELL" "PowerEdge R720" "3ZVJD5J" "10.3.130.26" "5as-em-cv1" "WINDOWS" "Menzies Aviation Commvault Media Server" GB:BRACKNELL.102
uat "5as-em-data1" "DELL" "PowerEdge R620" "558JD5J" "10.200.16.61" "5as-em-data1" "WINDOWS" "Menzies Aviation Data Server" GB:BRACKNELL.102
uat "5as-em-data2" "DELL" "PowerEdge R620" "658JD5J" "10.200.16.62" "5as-em-data2" "WINDOWS" "Menzies Aviation Data Server" GB:BRACKNELL.102
uat "5as-em-dc01" "MICROSOFT" "Virtual Machine" "2457-4680-6236-3614-8627-3077-84" "10.3.90.86" "5as-em-dc01" "WINDOWS" "Menzies Aviation DC Server" GB:BRACKNELL.102
uat "5as-em-exch1" "MICROSOFT" "Virtual Machine" "6010-8880-5759-7894-9078-7128-62" "10.3.92.37" "5as-em-exch1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-exch2" "MICROSOFT" "Virtual Machine" "1845-9411-7027-0139-1774-7386-21" "10.3.92.38" "5as-em-exch2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-fedex02" "MICROSOFT" "Virtual Machine" "8191-4921-3714-5616-5226-0957-55" "10.3.93.100" "5as-em-fedex02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-gns3" "MICROSOFT" "Virtual Machine" "7883-7898-9279-0547-3594-1124-05" "10.3.95.164" "5as-em-gns3" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-hv01" "DELL" "PowerEdge R720" "878RD5J" "10.200.16.10" "5as-em-hv01" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv02" "DELL" "PowerEdge R720" "G68RD5J" "10.200.16.8" "5as-em-hv02" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv03" "DELL" "PowerEdge R720" "H68RD5J" "10.200.16.12" "5as-em-hv03" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv04" "DELL" "PowerEdge R720" "J68RD5J" "10.200.16.13" "5as-em-hv04" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv05" "DELL" "PowerEdge R720" "978RD5J" "10.200.16.14" "5as-em-hv05" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv06" "DELL" "PowerEdge R720" "778RD5J" "10.200.16.15" "5as-em-hv06" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv07" "DELL" "PowerEdge R720" "678RD5J" "10.200.16.16" "5as-em-hv07" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv08" "DELL" "PowerEdge R720" "378RD5J" "10.200.16.17" "5as-em-hv08" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv09" "DELL" "PowerEdge R720" "278RD5J" "10.200.16.5" "5as-em-hv09" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv10" "DELL" "PowerEdge R720" "178RD5J" "10.200.16.19" "5as-em-hv10" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv11" "DELL" "PowerEdge R720" "73HKD5J" "10.200.16.20" "5as-em-hv11" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv12" "DELL" "PowerEdge R720" "53HKD5J" "10.200.16.7" "5as-em-hv12" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv13" "DELL" "PowerEdge R720" "JQWJD5J" "10.200.16.107" "5as-em-hv13" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-hv14" "DELL" "PowerEdge R720" "F78RD5J" "10.200.16.106" "5as-em-hv14" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-hv15" "DELL" "PowerEdge R720" "BTJYH5J" "10.200.16.24" "5as-em-hv15" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv16" "DELL" "PowerEdge R720" "9TJYH5J" "10.200.16.25" "5as-em-hv16" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv17" "DELL" "PowerEdge R630" "H7CFG42" "10.200.16.26" "5as-em-hv17" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv18" "DELL" "PowerEdge R630" "38CFG42" "10.200.16.27" "5as-em-hv18" "WINDOWS" "Menzies Aviation Hypervisor Server" GB:BRACKNELL.102
uat "5as-em-hv19" "DELL" "PowerEdge R620" "CS8JD5J" "10.200.16.91" "5as-em-hv19" "WINDOWS" "Menzies Aviation Hyperion Server" GB:BRACKNELL.102
uat "5as-em-hv20" "DELL" "PowerEdge R620" "BS8JD5J" "10.200.16.93" "5as-em-hv20" "WINDOWS" "Menzies Aviation Hyperion Server" GB:BRACKNELL.102
uat "5as-em-hv21" "DELL" "PowerEdge R720" "F2DJD5J" "10.200.16.94" "5as-em-hv21" "WINDOWS" "Menzies Aviation Hyperion Server" GB:BRACKNELL.102
uat "5as-em-itcap1" "MICROSOFT" "Virtual Machine" "7359-0331-9811-6356-8613-1935-17" "10.3.95.93" "5as-em-itcap1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-mdmon1" "MICROSOFT" "Virtual Machine" "0158-7958-9173-3289-3399-8550-43" "10.3.90.93" "5as-em-mdmon1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-np1" "DELL" "PowerEdge R610" "CS7MZ4J" "10.200.16.52" "5as-em-np1" "WINDOWS" "Menzies Aviation BI Server" GB:BRACKNELL.102
uat "5as-em-npdev1" "DELL" "PowerEdge R610" "8S7MZ4J" "10.200.16.53" "5as-em-npdev1" "WINDOWS" "Menzies Aviation BI Server" GB:BRACKNELL.102
uat "5as-em-print11" "MICROSOFT" "Virtual Machine" "5858-4740-5791-0400-8758-7905-32" "10.3.90.116" "5as-em-print11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-print12" "MICROSOFT" "Virtual Machine" "2767-5058-9654-4723-1906-4375-52" "10.3.90.117" "5as-em-print12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-print13" "MICROSOFT" "Virtual Machine" "6843-2111-3834-8836-8863-1809-89" "10.3.90.118" "5as-em-print13" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-print13" "MICROSOFT" "Virtual Machine" "4645-9809-4371-1404-6746-9210-59" "10.3.90.118" "5as-em-print13" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-print14" "MICROSOFT" "Virtual Machine" "6236-1805-2078-0849-0638-1141-59" "10.3.90.119" "5as-em-print14" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-print15" "MICROSOFT" "Virtual Machine" "2473-9799-5563-4375-0623-4226-43" "10.3.90.120" "5as-em-print15" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-print16" "MICROSOFT" "Virtual Machine" "8714-4595-5202-8673-2434-9149-70" "10.3.90.121" "5as-em-print16" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-print17" "MICROSOFT" "Virtual Machine" "9013-0264-3050-5624-2806-9606-34" "10.3.90.122" "5as-em-print17" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-print18" "MICROSOFT" "Virtual Machine" "9548-3176-9967-3698-1680-9527-97" "10.3.90.123" "5as-em-print18" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-qmm01" "MICROSOFT" "Virtual Machine" "8260-4732-7055-0077-2187-2348-78" "10.3.90.219" "5as-em-qmm01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-qmm02" "MICROSOFT" "Virtual Machine" "4095-5285-7715-8929-8507-9655-04" "10.3.90.220" "5as-em-qmm02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-qmm03" "MICROSOFT" "Virtual Machine" "2509-8594-7073-1738-1948-0880-91" "10.3.90.221" "5as-em-qmm03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-qmm04" "MICROSOFT" "Virtual Machine" "5306-5755-2790-6222-2409-8840-30" "10.3.90.222" "5as-em-qmm04" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-qvapp1" "DELL" "PowerEdge R820" "9R6JD5J" "10.200.16.50" "5as-em-qvapp1" "WINDOWS" "Menzies Aviation BI Server" GB:BRACKNELL.102
uat "5as-em-qvdev1" "DELL" "PowerEdge R720" "3Y1JD5J" "10.200.16.51" "5as-em-qvdev1" "WINDOWS" "Menzies Aviation BI Server" GB:BRACKNELL.102
uat "5as-em-qvfs1" "DELL" "PowerEdge R720" "4Y1JD5J" "10.200.16.54" "5as-em-qvfs1" "WINDOWS" "Menzies Aviation BI Server" GB:BRACKNELL.102
uat "5as-em-rdcb1" "MICROSOFT" "Virtual Machine" "6006-4782-8296-5378-5700-1012-46" "10.3.94.164" "5as-em-rdcb1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-rdweb1" "MICROSOFT" "Virtual Machine" "9856-3216-1482-3030-7973-1626-92" "10.3.94.165" "5as-em-rdweb1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-sanhq01" "MICROSOFT" "Virtual Machine" "0135-7943-0178-4748-0494-8059-35" "10.3.90.92" "5as-em-sanhq01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-sc01" "DELL" "PowerEdge R720" "5YJTC5J" "10.200.16.60" "5as-em-sc01" "WINDOWS" "Menzies Aviation SCOM Server" GB:BRACKNELL.102
uat "5as-em-scom1" "MICROSOFT" "Virtual Machine" "5535-9792-1404-0063-8807-3781-28" "10.3.90.124" "5as-em-scom1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-sms01" "DELL" "PowerEdge 1950" "1NHTF3J" "10.200.16.35" "5as-em-sms01" "WINDOWS" "Menzies Aviation SMS Gateway Server" GB:BRACKNELL.102
uat "5as-em-sq01" "MICROSOFT" "Virtual Machine" "6261-8820-9635-7677-1264-3296-52" "10.3.91.4" "5as-em-sq01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-sq02" "MICROSOFT" "Virtual Machine" "4309-3921-1889-1964-6306-7982-30" "10.3.91.20" "5as-em-sq02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-sq4" "MICROSOFT" "Virtual Machine" "0151-7959-2583-3508-5149-2339-61" "10.3.91.21" "5as-em-sq4" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-srv1" "MICROSOFT" "Virtual Machine" "1498-6154-9391-8084-3874-1812-74" "10.3.95.91" "5as-em-srv1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-stor1" "MICROSOFT" "Virtual Machine" "3456-6325-4510-1370-4220-1215-08" "10.3.95.92" "5as-em-stor1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-subca01" "MICROSOFT" "Virtual Machine" "8903-6031-8473-0876-9521-5907-96" "10.3.129.181" "5as-em-subca01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-subv01" "MICROSOFT" "Virtual Machine" "3673-7885-9422-2824-7650-6169-20" "10.3.91.70" "5as-em-subv01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-vault1" "DELL" "PowerEdge R610" "C8XB85J" "10.200.16.95" "5as-em-vault1" "WINDOWS" "Menzies Aviation Vault Server" GB:BRACKNELL.102
uat "5as-em-vaultsq1" "DELL" "PowerEdge R610" "9GXB85J" "10.200.16.96" "5as-em-vaultsq1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-em-vc1" "DELL" "PowerEdge R610" "BS7MZ4J" "10.200.16.85" "5as-em-vc1" "WINDOWS" "Menzies Aviation VMM Server" GB:BRACKNELL.102
uat "5as-li-cvprx01" "DELL" "PowerEdge R720" "4ZVJD5J" "10.200.16.34" "5as-li-cvprx01" "LINUX" "Menzies Aviation Commvault Media Server" GB:BRACKNELL.102
uat "5as-li-myamidb01" "DELL" "PowerEdge R720" "DLFYH5J" "10.200.16.63" "5as-li-myamidb01" "LINUX" "Menzies Aviation MYAMI APP Server" GB:BRACKNELL.102
uat "5as-li-oem01" "DELL" "PowerEdge R710" "1FY5X4J" "10.200.16.89" "5as-li-oem01" "LINUX" "Menzies Aviation Database Monitor Server" GB:BRACKNELL.102
uat "5as-li-ora01" "DELL" "PowerEdge R610" "GQSM85J" "10.150.129.100" "5as-li-ora01" "LINUX" "Menzies Aviation Oracle Rac Server" GB:BRACKNELL.102
uat "5as-li-ora02" "DELL" "PowerEdge R610" "HQSM85J" "10.150.129.101" "5as-li-ora02" "LINUX" "Menzies Aviation Oracle Rac Server" GB:BRACKNELL.102
uat "5as-li-ora03" "DELL" "PowerEdge R610" "JQSM85J" "10.150.129.102" "5as-li-ora03" "LINUX" "Menzies Aviation Oracle Rac Server" GB:BRACKNELL.102
uat "5as-li-oradev01" "DELL" "PowerEdge R610" "DQSM85J" "10.200.16.40" "5as-li-oradev01" "LINUX" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-md-dc01" "MICROSOFT" "Virtual Machine" "1660-3761-7332-5135-2904-3746-65" "10.3.90.125" "5as-md-dc01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-md-pp01" "MICROSOFT" "Virtual Machine" "5599-4460-6155-2149-9134-3363-52" "10.3.86.37" "5as-md-pp01" "WINDOWS" "Menzies Aviation File & Print Server" GB:BRACKNELL.102
uat "5as-ro-dc01" "MICROSOFT" "Virtual Machine" "2816-6242-6849-3670-6568-7766-08" "10.3.90.85" "5as-ro-dc01" "WINDOWS" "Menzies Aviation CCTV Server" GB:BRACKNELL.102
uat "5as-ro-dhcp01" "MICROSOFT" "Virtual Machine" "2748-4746-6781-5227-2732-2836-44" "10.3.90.91" "5as-ro-dhcp01" "WINDOWS" "Menzies Aviation File & Print Server" GB:BRACKNELL.102
uat "5as-ro-dhcp02" "MICROSOFT" "Virtual Machine" "5222-7508-1518-2534-1403-4901-94" "10.3.90.94" "5as-ro-dhcp02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-ro-kmrd01" "MICROSOFT" "Virtual Machine" "2270-2503-4812-3847-8467-7517-15" "10.3.90.90" "5as-ro-kmrd01" "WINDOWS" "Menzies Aviation File & Print Server" GB:BRACKNELL.102
uat "5as-ro-radius1" "MICROSOFT" "Virtual Machine" "9472-4025-6811-5958-0393-0119-88" "10.3.94.213" "5as-ro-radius1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-ro-subca1" "MICROSOFT" "Virtual Machine" "4767-8952-8049-9150-0962-8585-56" "10.3.84.55" "5as-ro-subca1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "5as-wg-root-ca" "MICROSOFT" "Virtual Machine" "8590-3239-8188-6117-2545-2877-30" "10.3.129.180" "5as-wg-root-ca" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "108ps-em-fp1" "DELL" "PowerEdge R720" "288XD5J" "10.34.0.20" "108ps-em-fp1" "WINDOWS" "Menzies Aviation Server" GB:EDINBURGH.101
uat "acc-em-cctv01" "DELL" "PowerEdge R520" "..CN7792153O002E." "" "acc-em-cctv01" "WINDOWS" "Menzies Aviation Server" GH:ACCRA.101
uat "acc-em-data01" "DELL" "PowerEdge T710" "B9XTT4J" "" "acc-em-data01" "WINDOWS" "Menzies Aviation Server" GH:ACCRA.101
uat "akl-as-app01" "" "VMware Virtual Platform" "VMWARE-56 4D DC CA BD 50 0E 45-A3 6D 3B B6 A6 50 E9 1A" "10.45.9.18" "akl-as-app01" "WINDOWS" "Menzies Aviation Server" NZ:AUCKLAND.101
uat "akl-as-data01" "MICROSOFT" "Virtual Machine" "5031-7002-3202-6721-1425-4497-46" "10.45.8.228" "akl-as-data01" "WINDOWS" "Menzies Aviation Server" NZ:AUCKLAND.101
uat "akl-as-fp01" "DELL" "PowerEdge T310" "1S6Y62S" "10.45.10.254" "akl-as-fp01" "WINDOWS" "Menzies Aviation File & Print Server" NZ:AUCKLAND.101
uat "akl-as-mafp01" "DELL" "PowerEdge T430" "99PHH62" "10.45.8.156" "akl-as-mafp01" "WINDOWS" "Menzies Aviation Server" NZ:AUCKLAND.101
uat "ami-em-projman1" "MICROSOFT" "Virtual Machine" "2521-4108-3347-7442-1949-4719-13" "10.3.84.5" "ami-em-projman1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "ami-ofbiz-02" "" "VMware Virtual Platform" "VMWARE-56 4D 9B CD 6B A5 2D 73-62 B7 80 90 C9 73 9A 71" "10.3.82.181" "ami-ofbiz-02" "LINUX" "Menzies Aviation Server" GB:BRACKNELL.102
uat "amm-em-data01" "DELL" "PowerEdge 2900" "D29RC4J" "" "amm-em-data01" "WINDOWS" "Menzies Aviation File & Print Server" JO:AMMAN.101
uat "ams-em-adm01" "" "VMware Virtual Platform" "VMWARE-42 29 F6 2D 9C 6E 6B 4D-49 B2 44 0D 5A 0A 4F A0" "10.51.1.17" "ams-em-adm01" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-app01" "" "VMware Virtual Platform" "VMWARE-42 06 59 41 99 50 57 51-6D A9 1D 93 80 BC 1B 93" "10.51.1.31" "ams-em-app01" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-back01" "DELL" "PowerEdge R630" "67CFG42" "10.51.0.50" "ams-em-back01" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-batch01" "" "VMware Virtual Platform" "VMWARE-42 29 17 E7 7C A8 5C 15-0E E2 39 D8 E0 3C 45 99" "10.51.1.35" "ams-em-batch01" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-citrix1" "" "VMware Virtual Platform" "VMWARE-42 29 45 A1 63 8B 91 96-07 04 2B 02 E2 FE F7 E5" "10.51.1.61" "ams-em-citrix1" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-citrix01" "" "VMware Virtual Platform" "VMWARE-42 06 BC 5E F5 2B 58 26-C4 CC 7E EE BC A7 EE 46" "10.51.1.44" "ams-em-citrix01" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-citrix02" "" "VMware Virtual Platform" "VMWARE-42 06 CE 73 32 A7 51 74-43 D2 42 EF CF 1E A7 AB" "10.51.1.45" "ams-em-citrix02" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-citrix2" "" "VMware Virtual Platform" "VMWARE-42 29 A7 EF 7B 03 E3 C7-1E 37 F7 21 2F 1B D8 D2" "10.51.1.62" "ams-em-citrix2" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-citrix3" "" "VMware Virtual Platform" "VMWARE-42 29 35 85 5E 6F 8C 10-5F BD FD 82 84 51 E9 A1" "10.51.1.63" "ams-em-citrix3" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-citrix03" "" "VMware Virtual Platform" "VMWARE-42 06 B6 54 9F 53 77 E5-C4 B1 FF BD 62 DD 20 75" "10.51.1.46" "ams-em-citrix03" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-citrix04" "" "VMware Virtual Platform" "VMWARE-42 06 CE 51 A8 05 D7 58-8F 0C BC 89 03 DF 1A A2" "10.51.1.47" "ams-em-citrix04" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-data1" "" "VMware Virtual Platform" "VMWARE-42 29 78 E5 E2 0A A4 F5-75 08 0D 58 65 1A 53 F4" "10.51.1.64" "ams-em-data1" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-dc1" "" "VMware Virtual Platform" "VMWARE-42 06 42 E4 99 F8 DA E9-68 65 30 79 82 10 D3 D9" "10.51.1.21" "ams-em-dc1" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-dev01" "" "VMware Virtual Platform" "VMWARE-42 29 1E 6F CF E5 36 71-6F CC 81 5D BA 61 26 9C" "10.51.1.53" "ams-em-dev01" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-epmp" "" "VMware Virtual Platform" "VMWARE-42 06 6D B2 86 A7 C9 7B-9A 29 7A 2F B7 98 AE 39" "10.51.1.41" "ams-em-epmp" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-epo01" "" "VMware Virtual Platform" "VMWARE-42 06 B5 5A 1D 35 EE 13-7F 2A BE BE 1B FF A2 25" "10.51.1.19" "ams-em-epo01" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-eprtm" "" "VMware Virtual Platform" "VMWARE-42 06 8D 4A 67 1C E8 E1-BC 3C 71 63 37 53 B6 72" "10.51.1.42" "ams-em-eprtm" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-epspl" "" "VMware Virtual Platform" "VMWARE-42 06 FD E6 E9 63 79 46-0C 2A DE B4 F9 C0 BE 52" "10.51.1.40" "ams-em-epspl" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-iis1" "" "VMware Virtual Platform" "VMWARE-42 29 02 FD D4 40 7D 02-F5 B7 9E E8 88 FC C4 CD" "10.8.5.1" "ams-em-iis1" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-iis2" "" "VMware Virtual Platform" "VMWARE-42 29 F6 B5 AC CF 0B FA-8E 52 B1 51 63 C4 EF 8F" "10.51.1.27" "ams-em-iis2" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-iis3" "" "VMware Virtual Platform" "VMWARE-42 29 AD FF 14 71 FA 37-55 45 E2 06 84 4F 6A 87" "10.51.1.30" "ams-em-iis3" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-itmon1" "" "VMware Virtual Platform" "VMWARE-42 06 84 45 E1 D4 6B EE-E0 33 FD 83 AD A2 B5 12" "10.51.1.18" "ams-em-itmon1" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-itmon2" "" "VMware Virtual Platform" "VMWARE-42 29 4A A9 77 D6 2F C3-18 C4 90 2B 39 FA 7B 3F" "10.51.1.48" "ams-em-itmon2" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-plc" "" "VMware Virtual Platform" "VMWARE-42 06 80 7A F0 09 C0 77-DE 91 D9 79 F1 B5 6C 84" "10.51.1.38" "ams-em-plc" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-print01" "" "VMware Virtual Platform" "VMWARE-42 06 12 E2 10 CA 46 CD-E9 0C D8 0E 0B 3A A7 6F" "10.51.1.22" "ams-em-print01" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-rad1" "" "VMware Virtual Platform" "VMWARE-42 06 2B D7 6D C0 D5 15-4F C7 BB 55 28 B9 CA 1D" "10.51.1.60" "ams-em-rad1" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-sql1" "" "VMware Virtual Platform" "VMWARE-42 29 8D CB 9C BA 56 20-71 B9 55 EB F0 F2 40 50" "10.51.1.72" "ams-em-sql1" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-sql01" "" "VMware Virtual Platform" "VMWARE-56 4D 10 20 B9 44 10 B7-20 41 FE C1 A9 D8 CB 92" "10.51.1.12" "ams-em-sql01" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-sql2" "" "VMware Virtual Platform" "VMWARE-42 29 08 54 40 D4 B9 68-10 D3 27 BA B4 3E CE CC" "10.51.1.73" "ams-em-sql2" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-sql02" "" "VMware Virtual Platform" "VMWARE-42 06 BF 1C 27 2C F4 86-70 6C D6 D8 FC A2 7D 3C" "10.51.1.13" "ams-em-sql02" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-sql03" "" "VMware Virtual Platform" "VMWARE-42 06 13 40 E6 57 47 4F-50 81 08 8B 17 D1 84 5F" "10.51.1.29" "ams-em-sql03" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-sqldev1" "" "VMware Virtual Platform" "VMWARE-42 29 6C 77 BD CE F3 21-2B DF 13 E2 16 22 B6 E4" "10.51.1.66" "ams-em-sqldev1" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-sqldev2" "" "VMware Virtual Platform" "VMWARE-42 29 03 38 F5 EF 13 34-01 F6 A2 55 64 B4 34 FC" "10.51.1.67" "ams-em-sqldev2" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-wsus01" "" "VMware Virtual Platform" "VMWARE-42 06 8D 67 32 B4 2E B7-8A 36 CE 40 1D 2D 78 B3" "10.51.1.16" "ams-em-wsus01" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "ams-em-wsus1" "" "VMware Virtual Platform" "VMWARE-42 29 61 E8 36 1D DD C3-34 25 B9 C3 38 DA F6 5D" "10.51.1.11" "ams-em-wsus1" "WINDOWS" "Menzies Aviation Server" NL:SCHIPHOL.101
uat "arn-em-back01" "DELL" "PowerEdge R620" "5S2J8X1" "10.53.20.75" "arn-em-back01" "WINDOWS" "Menzies Aviation Commvault Media Server" SE:STOCKHOLM.109
uat "arn-em-data1" "MICROSOFT" "Virtual Machine" "1442-2095-9843-7911-7343-5791-48" "10.53.18.53" "arn-em-data1" "WINDOWS" "Menzies Aviation File & Print Server" SE:STOCKHOLM.109
uat "arn-em-hv01" "DELL" "PowerEdge R720" "3Z2J8X1" "10.53.20.72" "arn-em-hv01" "WINDOWS" "Menzies Aviation Hypervisor Server" SE:STOCKHOLM.109
uat "arn-em-print1" "MICROSOFT" "Virtual Machine" "5374-3660-6758-7089-7399-0096-44" "10.53.18.54" "arn-em-print1" "WINDOWS" "Menzies Aviation File & Print Server" SE:STOCKHOLM.109
uat "arn-em-wsus1" "MICROSOFT" "Virtual Machine" "2902-6230-9565-3714-2747-8181-66" "10.53.20.79" "arn-em-wsus1" "WINDOWS" "Menzies Aviation Server" SE:STOCKHOLM.109
uat "au-em-batch01" "MICROSOFT" "Virtual Machine" "6430-6514-8193-6244-3914-0452-00" "10.3.82.86" "au-em-batch01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-batch1" "MICROSOFT" "Virtual Machine" "3987-6198-1324-1786-3480-9216-13" "10.3.85.52" "au-em-batch1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-batch02" "MICROSOFT" "Virtual Machine" "1860-0243-5230-8495-5138-7323-57" "10.3.82.87" "au-em-batch02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-batch2" "MICROSOFT" "Virtual Machine" "3881-3303-5305-1640-7185-5680-81" "10.3.85.53" "au-em-batch2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-citrix1" "MICROSOFT" "Virtual Machine" "1973-1867-5532-7919-5292-3035-75" "10.3.82.94" "au-em-citrix1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-citrix01" "MICROSOFT" "Virtual Machine" "4442-8957-6412-0502-8436-8447-11" "10.3.82.88" "au-em-citrix01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-citrix02" "MICROSOFT" "Virtual Machine" "6366-8550-2253-6416-3917-0353-47" "10.3.82.89" "au-em-citrix02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-citrix2" "MICROSOFT" "Virtual Machine" "2365-8394-3125-7147-3959-8386-31" "10.3.85.55" "au-em-citrix2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-citrix03" "MICROSOFT" "Virtual Machine" "0777-5639-7284-3815-3473-4067-85" "10.3.82.90" "au-em-citrix03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-citrix3" "MICROSOFT" "Virtual Machine" "4970-6092-2240-9431-6272-0946-11" "10.3.85.56" "au-em-citrix3" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-citrix04" "MICROSOFT" "Virtual Machine" "1263-6157-9370-5720-7397-3983-28" "10.3.82.93" "au-em-citrix04" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-mess01" "MICROSOFT" "Virtual Machine" "1607-2575-6588-4563-3470-1976-43" "10.3.82.84" "au-em-mess01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-mess1" "MICROSOFT" "Virtual Machine" "2927-7672-1042-2829-4222-9768-94" "10.3.85.57" "au-em-mess1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-schr1" "MICROSOFT" "Virtual Machine" "1564-0347-5322-3395-6025-9436-66" "10.3.85.58" "au-em-schr1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-schr01" "MICROSOFT" "Virtual Machine" "4407-4549-3090-0194-6040-1450-28" "10.3.82.91" "au-em-schr01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-shfo01" "MICROSOFT" "Virtual Machine" "5852-5148-0845-2217-0421-0244-16" "10.3.82.85" "au-em-shfo01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-shfo1" "MICROSOFT" "Virtual Machine" "6307-3956-8237-0255-1749-5558-32" "10.3.85.59" "au-em-shfo1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "au-em-skystar" "MICROSOFT" "Virtual Machine" "0217-7658-8236-6668-6207-2339-99" "10.3.82.164" "au-em-skystar" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "bgf-em-data02" "DELL" "PowerEdge R520" "BMBBJ32" "" "bgf-em-data02" "WINDOWS" "Menzies Aviation Server" CF:BANGUI.101
uat "blr-as-cust01" "DELL" "PowerEdge 1950" "4FNDT1S" "10.49.4.198" "blr-as-cust01" "WINDOWS" "Menzies Aviation Custom app server Server" IN:BENGALURU.101
uat "blr-as-data01" "" "VMware Virtual Platform" "VMWARE-42 06 35 9D F6 AF 4E 4F-F5 74 9F E1 16 8E 48 F2" "10.49.8.11" "blr-as-data01" "WINDOWS" "Menzies Aviation Server" IN:BENGALURU.101
uat "blr-as-fp01" "DELL" "PowerEdge 2900" "83B4V1S" "10.49.4.201" "blr-as-fp01" "WINDOWS" "Menzies Aviation File & Print Server" IN:BENGALURU.101
uat "blr-as-hwcam4" "" "VMware Virtual Platform" "VMWARE-42 06 53 F5 A9 BB 1A B1-78 E7 23 84 6D E7 E4 FA" "10.49.8.14" "blr-as-hwcam4" "WINDOWS" "Menzies Aviation Server" IN:BENGALURU.101
uat "blr-as-hwdb2" "" "VMware Virtual Platform" "VMWARE-42 06 32 4F 45 E0 4B C3-DA E6 38 1F B8 18 9C 43" "10.49.8.15" "blr-as-hwdb2" "WINDOWS" "Menzies Aviation Server" IN:BENGALURU.101
uat "blr-as-hwdb3" "" "VMware Virtual Platform" "VMWARE-42 06 A4 D3 30 E0 06 B5-C8 9C F6 27 9F 29 3A 9B" "10.49.8.15" "blr-as-hwdb3" "WINDOWS" "Menzies Aviation Server" IN:BENGALURU.101
uat "blr-as-mile1" "" "VMware Virtual Platform" "VMWARE-42 06 13 0E A0 1A CC D2-36 20 73 1E 6E D3 2B 71" "10.49.8.13" "blr-as-mile1" "WINDOWS" "Menzies Aviation Server" IN:BENGALURU.101
uat "blr-as-milefail" "" "VMware Virtual Platform" "VMWARE-42 06 41 E8 59 D2 2D E2-13 0E 5F 99 56 62 39 51" "10.49.8.26" "blr-as-milefail" "WINDOWS" "Menzies Aviation Server" IN:BENGALURU.101
uat "blr-as-milemgmt" "" "VMware Virtual Platform" "VMWARE-42 06 29 4A AA 20 9A 62-B7 B1 57 77 38 EE 08 50" "10.49.8.24" "blr-as-milemgmt" "WINDOWS" "Menzies Aviation Server" IN:BENGALURU.101
uat "blr-as-milerec0" "" "VMware Virtual Platform" "VMWARE-42 06 6D 5B 87 4A A6 F7-6F 83 E5 F4 B0 0C 6D 04" "10.49.8.25" "blr-as-milerec0" "WINDOWS" "Menzies Aviation Server" IN:BENGALURU.101
uat "blr-as-print1" "" "VMware Virtual Platform" "VMWARE-42 06 0D 5A AD AB B9 FF-58 1D 46 AC EB 44 AC C1" "10.49.8.12" "blr-as-print1" "WINDOWS" "Menzies Aviation Server" IN:BENGALURU.101
uat "blr-as-vi01" "" "VMware Virtual Platform" "VMWARE-56 4D A6 7E 3C FF 86 CA-DA 1E E8 8D 9D 95 27 1C" "10.49.8.5" "blr-as-vi01" "WINDOWS" "Menzies Aviation Server" IN:BENGALURU.101
uat "blr-as-vms" "" "VMware Virtual Platform" "VMWARE-42 06 EE 9A 2C D8 EF CC-91 1A CC F2 25 80 0C 9C" "10.49.8.21" "blr-as-vms" "WINDOWS" "Menzies Aviation Server" IN:BENGALURU.101
uat "blr-as-webdev01" "DELL" "PowerEdge 1950" "5FNDT1S" "10.49.4.199" "blr-as-webdev01" "WINDOWS" "Menzies Aviation eres-dev Server" IN:BENGALURU.101
uat "blr-as-wsus1" "" "VMware Virtual Platform" "VMWARE-42 06 D3 F0 C5 72 2D 73-5D B1 F7 30 77 12 EB 3B" "10.49.8.20" "blr-as-wsus1" "WINDOWS" "Menzies Aviation Server" IN:BENGALURU.101
uat "bne-as-amidata1" "MICROSOFT" "Virtual Machine" "9620-5258-6615-2182-7034-7727-42" "10.46.4.102" "bne-as-amidata1" "WINDOWS" "Menzies Aviation AMI file and Print Server" AU:BRISBANE.101
uat "bne-as-amifp01" "DELL" "PowerEdge T320" "3P88GY1" "10.46.4.73" "bne-as-amifp01" "WINDOWS" "Menzies Aviation File & Print Server" AU:BRISBANE.101
uat "bog-am-data" "MICROSOFT" "Virtual Machine" "2317-2761-5803-2622-2676-9176-37" "10.38.1.167" "bog-am-data" "WINDOWS" "Menzies Aviation File & Print Server" CO:BOGOTA.102
uat "bog-am-hv01" "DELL" "PowerEdge R720" "CRRJCY1" "10.38.1.142" "bog-am-hv01" "WINDOWS" "Menzies Aviation Server" CO:BOGOTA.102
uat "bog-am-nom" "MICROSOFT" "Virtual Machine" "7004-1590-7101-8243-0827-1536-01" "10.38.1.166" "bog-am-nom" "WINDOWS" "Menzies Aviation Mointoring server Server" CO:BOGOTA.102
uat "bog-am-print" "MICROSOFT" "Virtual Machine" "7747-9438-4035-2678-5436-3242-67" "10.38.1.168" "bog-am-print" "WINDOWS" "Menzies Aviation Print Server Server" CO:BOGOTA.102
uat "bog-am-syn" "MICROSOFT" "Virtual Machine" "0981-0380-6250-4879-5234-2871-28" "10.38.1.165" "bog-am-syn" "WINDOWS" "Menzies Aviation App Server Server" CO:BOGOTA.102
uat "c2w-em-data1" "DELL" "PowerEdge T110 II" "FNNT85J" "10.32.4.221" "c2w-em-data1" "WINDOWS" "Menzies Aviation File & Print Server" GB:HEATHROW.101
uat "ca-em-batcit01" "MICROSOFT" "Virtual Machine" "0366-8422-5243-6599-4387-1343-31" "10.3.84.84" "ca-em-batcit01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "ca-em-batcit02" "MICROSOFT" "Virtual Machine" "6561-2861-8494-8076-8937-7999-53" "10.3.84.85" "ca-em-batcit02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "ca-em-schr01" "MICROSOFT" "Virtual Machine" "2646-7974-9521-3401-4109-5264-83" "10.3.84.86" "ca-em-schr01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "ca-em-sfmess01" "MICROSOFT" "Virtual Machine" "4011-6624-3011-1687-2635-2818-33" "10.3.84.87" "ca-em-sfmess01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "chc-as-data01" "MICROSOFT" "Virtual Machine" "9263-4925-3742-4858-6994-6802-14" "10.46.13.11" "chc-as-data01" "WINDOWS" "Menzies Aviation Server" NZ:CHRISTCHURCH.101
uat "chc-as-mafp01" "DELL" "PowerEdge T430" "99TDH62" "10.46.13.10" "chc-as-mafp01" "WINDOWS" "Menzies Aviation Server" NZ:CHRISTCHURCH.101
uat "co-em-citapp3" "MICROSOFT" "Virtual Machine" "4794-1083-7671-3140-8880-1375-45" "10.3.92.182" "co-em-citapp3" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "coo-em-data03" "DELL" "PowerEdge R730" "7HGTV42" "" "coo-em-data03" "WINDOWS" "Menzies Aviation Server" BJ:COTONOU.101
uat "cpt-em-data01" "DELL" "PowerEdge R720" "8QJC302" "" "cpt-em-data01" "WINDOWS" "Menzies Aviation Server" ZA:CAPETOWN.101
uat "cz-em-batch01" "MICROSOFT" "Virtual Machine" "7402-6346-1555-7844-5216-3181-18" "10.3.88.244" "cz-em-batch01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "cz-em-batch02" "MICROSOFT" "Virtual Machine" "9676-9715-0648-7085-5436-2791-76" "10.3.88.245" "cz-em-batch02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "cz-em-citrix01" "MICROSOFT" "Virtual Machine" "6245-8796-1714-2765-0762-2814-81" "10.3.88.246" "cz-em-citrix01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "cz-em-citrix02" "MICROSOFT" "Virtual Machine" "0765-9002-9576-2844-6403-5370-77" "10.3.88.247" "cz-em-citrix02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "cz-em-citrix03" "MICROSOFT" "Virtual Machine" "1658-9461-0186-6820-3317-0884-01" "10.3.88.248" "cz-em-citrix03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "cz-em-mess01" "MICROSOFT" "Virtual Machine" "5132-8838-8682-4992-2922-2076-60" "10.3.88.249" "cz-em-mess01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "cz-em-schr01" "MICROSOFT" "Virtual Machine" "3139-5809-8913-8196-1061-5905-12" "10.3.88.250" "cz-em-schr01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "cz-em-shfo01" "MICROSOFT" "Virtual Machine" "2968-6625-2190-9939-5715-9920-93" "10.3.88.251" "cz-em-shfo01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "cz-em-target01" "MICROSOFT" "Virtual Machine" "3851-7212-5840-4802-3568-0673-26" "10.3.84.164" "cz-em-target01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "den-am-data1" "DELL" "PowerEdge T110 II" "JCVCY12" "10.38.4.190" "den-am-data1" "WINDOWS" "Menzies Aviation File & Print Server" CO.DENVER.322
uat "dev-em-inbrk01" "MICROSOFT" "Virtual Machine" "1944-1027-4220-3811-7548-6692-02" "10.3.90.216" "dev-em-inbrk01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "dev-em-inbrk02" "MICROSOFT" "Virtual Machine" "6077-1435-7477-8512-1999-9523-48" "10.3.90.218" "dev-em-inbrk02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "dev-em-inweb01" "MICROSOFT" "Virtual Machine" "7568-9772-4789-3839-1591-9475-48" "10.3.90.215" "dev-em-inweb01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "dev-em-inweb02" "MICROSOFT" "Virtual Machine" "3658-7721-0841-1627-5287-7441-75" "10.3.90.217" "dev-em-inweb02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "dfw-am-data01" "" "VMware Virtual Platform" "VMWARE-56 4D 5A 8E E9 C4 24 C4-8A F4 9B BF 16 69 30 66" "10.36.6.21" "dfw-am-data01" "WINDOWS" "Menzies Aviation Server" TX.DALLAS.199
uat "dfw-am-dc1" "" "VMware Virtual Platform" "VMWARE-56 4D FD 82 AF C9 B4 B5-DF 0D F1 70 4A EA DB 7C" "10.36.6.29" "dfw-am-dc1" "WINDOWS" "Menzies Aviation Server" TX.DALLAS.199
uat "dfw-am-nmon01" "" "VMware Virtual Platform" "VMWARE-56 4D 68 1A 33 C1 DD F7-C4 F6 E8 D7 1D F1 E3 00" "10.36.6.27" "dfw-am-nmon01" "WINDOWS" "Menzies Aviation Server" TX.DALLAS.199
uat "dfw-am-print01" "" "VMware Virtual Platform" "VMWARE-56 4D 4E 2A 21 A4 3A DA-82 DA B7 B8 B1 10 C7 DD" "10.36.6.23" "dfw-am-print01" "WINDOWS" "Menzies Aviation Server" TX.DALLAS.199
uat "dfw-am-radius" "" "VMware Virtual Platform" "VMWARE-56 4D 4D E4 EC AC F9 F0-2C 92 91 C4 4F F6 DF 7A" "10.36.6.26" "dfw-am-radius" "WINDOWS" "Menzies Aviation Server" TX.DALLAS.199
uat "dfw-am-wsus1" "" "VMware Virtual Platform" "VMWARE-56 4D 13 3A 73 56 2F A8-CB D7 21 EC 45 4A 78 A7" "10.36.6.30" "dfw-am-wsus1" "WINDOWS" "Menzies Aviation Server" TX.DALLAS.199
uat "dfw-ro-dhcp01" "" "VMware Virtual Platform" "VMWARE-56 4D B3 0A 08 E0 CA 9C-8B 30 C1 30 21 A9 62 E1" "10.36.6.20" "dfw-ro-dhcp01" "WINDOWS" "Menzies Aviation Server" TX.DALLAS.199
uat "fab-em-ami01" "DELL" "PowerEdge R710" "38TKS4J" "10.3.231.77" "fab-em-ami01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "fab-em-sq01" "MICROSOFT" "Virtual Machine" "1143-4548-5285-0820-6530-0271-82" "10.3.91.85" "fab-em-sq01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "fab-em-zapastel" "DELL" "PowerEdge 1950" "5HX584J" "10.3.230.150" "fab-em-zapastel" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "fab-ro-bc01" "DELL" "PowerEdge 850" "H0JFK2J" "10.3.245.14" "fab-ro-bc01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-a4image" "MICROSOFT" "Virtual Machine" "9698-1180-0111-9785-2039-9360-48" "10.3.90.229" "gl-em-a4image" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-adfs1" "MICROSOFT" "Virtual Machine" "4901-9730-8331-5030-7703-2546-82" "10.3.130.132" "gl-em-adfs1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-adm01" "MICROSOFT" "Virtual Machine" "3408-3244-6634-7748-7444-1734-76" "10.3.82.72" "gl-em-adm01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-adm1" "MICROSOFT" "Virtual Machine" "2657-4604-1840-1188-0664-6836-65" "10.3.90.104" "gl-em-adm1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-adm2" "MICROSOFT" "Virtual Machine" "1939-0785-0486-5270-3866-2165-04" "10.3.90.105" "gl-em-adm2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-adm02" "MICROSOFT" "Virtual Machine" "6546-6230-0012-9936-0689-3062-29" "10.3.82.73" "gl-em-adm02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-adm3" "MICROSOFT" "Virtual Machine" "5760-1260-0607-5044-3010-8566-18" "10.3.90.106" "gl-em-adm3" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-adm4" "MICROSOFT" "Virtual Machine" "2004-3010-4966-9256-5665-5652-71" "10.3.90.107" "gl-em-adm4" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-adm5" "MICROSOFT" "Virtual Machine" "5181-4265-4214-8291-2268-3755-20" "10.3.90.108" "gl-em-adm5" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-adm6" "MICROSOFT" "Virtual Machine" "4274-8526-2893-2804-9702-0477-03" "10.3.90.109" "gl-em-adm6" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-adm7" "MICROSOFT" "Virtual Machine" "7143-0287-0235-7997-8457-9864-28" "10.3.90.110" "gl-em-adm7" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-adm8" "MICROSOFT" "Virtual Machine" "8194-8779-6930-3976-4595-1414-70" "10.3.90.102" "gl-em-adm8" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-admsvr1" "MICROSOFT" "Virtual Machine" "3233-4190-9759-3882-8184-8272-58" "10.3.86.21" "gl-em-admsvr1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-alftp1" "MICROSOFT" "Virtual Machine" "0443-6787-2785-2452-2170-4867-89" "10.3.130.116" "gl-em-alftp1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-appdata" "MICROSOFT" "Virtual Machine" "1237-0874-3285-1815-9174-2501-39" "10.3.83.4" "gl-em-appdata" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincap1" "MICROSOFT" "Virtual Machine" "8347-9915-4346-7010-9228-0216-73" "10.3.80.150" "gl-em-arincap1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincap01" "MICROSOFT" "Virtual Machine" "7337-5472-6173-2101-0771-6224-02" "10.3.80.149" "gl-em-arincap01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincap2" "MICROSOFT" "Virtual Machine" "8616-1818-5680-7833-2756-4509-92" "10.3.80.166" "gl-em-arincap2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincap02" "MICROSOFT" "Virtual Machine" "5209-4071-7388-8570-9347-5052-28" "10.3.80.165" "gl-em-arincap02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincap03" "MICROSOFT" "Virtual Machine" "5335-9855-7131-5584-7775-9089-83" "10.3.80.181" "gl-em-arincap03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincap3" "MICROSOFT" "Virtual Machine" "6941-1985-9363-7822-6872-9556-06" "10.3.80.183" "gl-em-arincap3" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincap4" "MICROSOFT" "Virtual Machine" "1254-0849-6252-5735-4418-2780-63" "10.3.80.198" "gl-em-arincap4" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincap04" "MICROSOFT" "Virtual Machine" "0092-2939-0073-4264-7147-3772-69" "10.3.80.197" "gl-em-arincap04" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincgw01" "MICROSOFT" "Virtual Machine" "1681-9712-7603-2985-0801-8516-29" "10.3.80.148" "gl-em-arincgw01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincgw02" "MICROSOFT" "Virtual Machine" "8820-2131-3279-9244-0363-3330-56" "10.3.80.164" "gl-em-arincgw02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincgw03" "MICROSOFT" "Virtual Machine" "4543-4666-8697-8588-7945-8755-64" "10.3.80.180" "gl-em-arincgw03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincgw04" "MICROSOFT" "Virtual Machine" "5811-0543-8865-2909-8976-5056-13" "10.3.80.196" "gl-em-arincgw04" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-arincgw05" "MICROSOFT" "Virtual Machine" "8079-4009-0057-7968-1882-2165-80" "10.3.80.212" "gl-em-arincgw05" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-citapp1" "MICROSOFT" "Virtual Machine" "5227-5636-7750-8940-3167-9367-90" "10.3.83.148" "gl-em-citapp1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-citapp2" "MICROSOFT" "Virtual Machine" "6398-9204-1990-8308-4453-6608-82" "10.3.83.149" "gl-em-citapp2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-citcsg01" "MICROSOFT" "Virtual Machine" "9298-5004-5968-5668-9055-7565-17" "10.3.129.116" "gl-em-citcsg01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-citcsg02" "MICROSOFT" "Virtual Machine" "1488-2464-8242-8444-4066-6805-91" "10.3.129.117" "gl-em-citcsg02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-citddc1" "MICROSOFT" "Virtual Machine" "0893-1877-6525-7146-7982-8123-88" "10.3.92.213" "gl-em-citddc1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-citddc2" "MICROSOFT" "Virtual Machine" "9064-5385-0925-6405-2123-3552-71" "10.3.92.229" "gl-em-citddc2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-citstore1" "MICROSOFT" "Virtual Machine" "3923-6763-2396-9248-0684-3213-08" "10.3.92.212" "gl-em-citstore1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-citstore2" "MICROSOFT" "Virtual Machine" "5241-0655-4963-8516-3826-1120-43" "10.3.92.228" "gl-em-citstore2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-citweb01" "MICROSOFT" "Virtual Machine" "9912-7827-5690-4205-6940-5847-30" "10.3.92.116" "gl-em-citweb01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-citweb02" "MICROSOFT" "Virtual Machine" "7631-4761-0463-9521-4452-2225-46" "10.3.92.117" "gl-em-citweb02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-crystal01" "MICROSOFT" "Virtual Machine" "2286-7859-8859-1197-4932-5414-65" "10.3.88.228" "gl-em-crystal01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-crystal02" "MICROSOFT" "Virtual Machine" "8533-1397-0130-7141-6299-2125-92" "10.3.90.126" "gl-em-crystal02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-dasftp1" "MICROSOFT" "Virtual Machine" "8543-5788-0074-0214-5523-0659-70" "10.3.130.52" "gl-em-dasftp1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-deng1" "MICROSOFT" "Virtual Machine" "1175-8807-8823-1189-6754-9877-99" "10.3.84.132" "gl-em-deng1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-deng01" "MICROSOFT" "Virtual Machine" "7600-5642-5373-6520-0372-3100-43" "10.3.80.22" "gl-em-deng01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-deng2" "MICROSOFT" "Virtual Machine" "4057-6391-0764-7068-4418-9467-09" "10.3.84.133" "gl-em-deng2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-deng02" "MICROSOFT" "Virtual Machine" "4802-3564-0080-2589-8374-1205-98" "10.3.80.20" "gl-em-deng02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-deng03" "MICROSOFT" "Virtual Machine" "5767-4033-5338-1227-7326-2618-42" "10.3.80.21" "gl-em-deng03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-deng04" "MICROSOFT" "Virtual Machine" "9204-0574-9201-7332-9296-2776-89" "10.3.80.23" "gl-em-deng04" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-dengd1" "MICROSOFT" "Virtual Machine" "6292-9079-5083-3344-8356-1610-52" "10.3.84.134" "gl-em-dengd1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-dis02" "MICROSOFT" "Virtual Machine" "5370-2744-9219-0931-2676-0948-08" "10.3.88.197" "gl-em-dis02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-e2db02" "MICROSOFT" "Virtual Machine" "7838-5167-6251-8762-3350-0845-96" "10.3.82.244" "gl-em-e2db02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-edifly04" "MICROSOFT" "Virtual Machine" "7609-3104-6888-1450-5249-4178-78" "10.3.129.35" "gl-em-edifly04" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-epo2" "MICROSOFT" "Virtual Machine" "2411-1931-5674-5428-9107-2392-84" "10.3.88.234" "gl-em-epo2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-epow1" "MICROSOFT" "Virtual Machine" "1785-5771-8227-8786-0463-0397-58" "10.3.85.27" "gl-em-epow1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-epow11" "MICROSOFT" "Virtual Machine" "9938-8215-0185-8783-7401-8669-02" "10.3.85.91" "gl-em-epow11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-fbweb01" "MICROSOFT" "Virtual Machine" "5469-1257-3687-9640-7510-6275-97" "10.3.128.36" "gl-em-fbweb01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-fleet01" "MICROSOFT" "Virtual Machine" "5324-7833-3936-3803-3054-3831-36" "10.3.90.20" "gl-em-fleet01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-gpo1" "MICROSOFT" "Virtual Machine" "2026-9813-1842-1295-3804-8326-60" "10.3.90.100" "gl-em-gpo1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-gse1" "MICROSOFT" "Virtual Machine" "0279-1971-8045-4886-8717-4647-14" "10.3.90.53" "gl-em-gse1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-gse01" "MICROSOFT" "Virtual Machine" "6788-7777-2895-3619-6889-0548-51" "10.3.90.52" "gl-em-gse01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-heatapp1" "MICROSOFT" "Virtual Machine" "0952-7019-1372-5877-1636-4510-13" "10.3.90.5" "gl-em-heatapp1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-hrscan01" "MICROSOFT" "Virtual Machine" "6422-2875-4457-9732-6949-2416-73" "10.3.90.244" "gl-em-hrscan01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-hyadm1" "MICROSOFT" "Virtual Machine" "8468-2925-6055-3979-1593-7554-54" "10.3.83.36" "gl-em-hyadm1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-hycit11" "MICROSOFT" "Virtual Machine" "6438-8948-0350-9339-5016-3857-78" "10.3.83.20" "gl-em-hycit11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-hycit12" "MICROSOFT" "Virtual Machine" "3225-7953-0810-0063-5293-3726-82" "10.3.83.21" "gl-em-hycit12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-hycit13" "MICROSOFT" "Virtual Machine" "1041-3570-3148-1836-0560-0289-52" "10.3.83.22" "gl-em-hycit13" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-hyepm1" "MICROSOFT" "Virtual Machine" "9318-4223-1166-8468-6802-7693-32" "10.3.83.52" "gl-em-hyepm1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-hyepm2" "MICROSOFT" "Virtual Machine" "9871-5964-1225-5165-2031-8703-17" "10.3.83.53" "gl-em-hyepm2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-hyesb1" "MICROSOFT" "Virtual Machine" "2875-7513-3338-1742-7534-3799-63" "10.3.83.68" "gl-em-hyesb1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-hyplan1" "MICROSOFT" "Virtual Machine" "6716-3703-0637-6746-1012-3806-74" "10.3.83.37" "gl-em-hyplan1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-hyshfo01" "MICROSOFT" "Virtual Machine" "8148-3484-3474-1609-8075-2621-33" "10.3.93.150" "gl-em-hyshfo01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-hyweb1" "MICROSOFT" "Virtual Machine" "5946-7431-2401-5544-7174-5372-12" "10.3.83.38" "gl-em-hyweb1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-infor1" "MICROSOFT" "Virtual Machine" "6831-3791-5907-3407-3149-4978-12" "10.3.93.230" "gl-em-infor1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-infor01" "MICROSOFT" "Virtual Machine" "8088-0895-6222-9510-4502-1683-17" "10.3.93.232" "gl-em-infor01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-iposcit1" "MICROSOFT" "Virtual Machine" "3450-1599-8228-2069-7967-6857-54" "10.3.90.37" "gl-em-iposcit1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-iposcit01" "MICROSOFT" "Virtual Machine" "5970-3873-1298-1562-2576-0185-08" "10.3.83.106" "gl-em-iposcit01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-iposweb1" "MICROSOFT" "Virtual Machine" "0882-0864-8560-9600-3335-2627-42" "10.3.90.36" "gl-em-iposweb1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-iposweb01" "MICROSOFT" "Virtual Machine" "6450-6835-1022-5577-4119-6470-15" "10.3.83.107" "gl-em-iposweb01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-itsmapp01" "MICROSOFT" "Virtual Machine" "0071-9201-6959-0120-8206-1443-81" "10.3.90.4" "gl-em-itsmapp01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-jm1" "MICROSOFT" "Virtual Machine" "5631-6373-0522-6280-7352-3582-82" "10.3.84.116" "gl-em-jm1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-lync1" "MICROSOFT" "Virtual Machine" "2175-5806-5887-9388-4369-1466-04" "10.3.82.228" "gl-em-lync1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-lync1" "MICROSOFT" "Virtual Machine" "1618-4141-9605-0546-7521-4202-16" "10.3.82.228" "gl-em-lync1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-lync01" "MICROSOFT" "Virtual Machine" "2175-5806-5887-9388-4369-1466-04" "10.3.82.232" "gl-em-lync01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-matv2" "MICROSOFT" "Virtual Machine" "6801-0807-8569-7175-6674-0114-84" "10.3.80.245" "gl-em-matv2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-net1" "MICROSOFT" "Virtual Machine" "6712-8727-4119-9477-3465-1274-27" "" "gl-em-net1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-nflowcs" "MICROSOFT" "Virtual Machine" "0876-5615-7648-7621-2548-9255-72" "10.3.95.148" "gl-em-nflowcs" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-ong1" "MICROSOFT" "Virtual Machine" "1911-0191-4710-9889-3510-1841-19" "10.3.95.100" "gl-em-ong1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-outman" "MICROSOFT" "Virtual Machine" "0735-3292-9213-0076-5599-9086-33" "10.3.91.72" "gl-em-outman" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-owa1" "MICROSOFT" "Virtual Machine" "2068-5603-3785-7673-0130-7197-70" "10.3.82.229" "gl-em-owa1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-printman1" "MICROSOFT" "Virtual Machine" "9571-7145-7550-0469-2675-4274-15" "10.3.94.100" "gl-em-printman1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-qars1" "MICROSOFT" "Virtual Machine" "0114-5975-7128-6825-4720-2825-82" "10.3.90.69" "gl-em-qars1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-qars2" "MICROSOFT" "Virtual Machine" "3717-4520-1540-9492-5613-0690-16" "10.3.90.70" "gl-em-qars2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-qvdmz1" "MICROSOFT" "Virtual Machine" "6950-8754-6936-8143-0264-1057-09" "10.3.130.68" "gl-em-qvdmz1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-qvqmc1" "MICROSOFT" "Virtual Machine" "8953-7219-6310-4621-8785-2374-53" "10.3.95.116" "gl-em-qvqmc1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-radlan01" "MICROSOFT" "Virtual Machine" "0881-2372-9566-1752-3058-2537-53" "10.3.84.69" "gl-em-radlan01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms01" "MICROSOFT" "Virtual Machine" "4660-9575-1063-1365-1536-5209-86" "10.3.93.181" "gl-em-rsms01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms03" "MICROSOFT" "Virtual Machine" "6722-3082-8292-5090-5509-4261-62" "10.3.94.5" "gl-em-rsms03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms04" "MICROSOFT" "Virtual Machine" "4502-1517-9482-1954-1593-8642-88" "10.3.94.6" "gl-em-rsms04" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms05" "MICROSOFT" "Virtual Machine" "8564-3551-5354-6385-2304-5536-68" "10.3.94.7" "gl-em-rsms05" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms06" "MICROSOFT" "Virtual Machine" "3330-2405-2497-1549-9233-7793-35" "10.3.94.8" "gl-em-rsms06" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms07" "MICROSOFT" "Virtual Machine" "2212-8125-7759-5528-1211-0752-58" "10.3.94.9" "gl-em-rsms07" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms08" "MICROSOFT" "Virtual Machine" "3094-2875-3353-9574-7152-7446-44" "10.3.94.10" "gl-em-rsms08" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms09" "MICROSOFT" "Virtual Machine" "7789-3270-8059-9199-0239-4938-51" "10.3.94.11" "gl-em-rsms09" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms10" "MICROSOFT" "Virtual Machine" "9383-8403-4120-7381-5671-0200-71" "10.3.94.12" "gl-em-rsms10" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms11" "MICROSOFT" "Virtual Machine" "5960-5440-1903-6415-2104-3764-61" "10.3.94.13" "gl-em-rsms11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms12" "MICROSOFT" "Virtual Machine" "3488-4687-6778-0813-2490-4591-33" "10.3.94.14" "gl-em-rsms12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms13" "MICROSOFT" "Virtual Machine" "7906-3661-5190-4008-3804-8598-97" "10.3.94.4" "gl-em-rsms13" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms15" "MICROSOFT" "Virtual Machine" "9519-8519-4671-0149-3166-3163-06" "10.3.94.25" "gl-em-rsms15" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms20" "MICROSOFT" "Virtual Machine" "6524-7893-1784-9294-9369-1886-86" "10.3.94.30" "gl-em-rsms20" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms21" "MICROSOFT" "Virtual Machine" "2715-0860-8884-7404-6085-4658-47" "10.3.94.31" "gl-em-rsms21" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms22" "MICROSOFT" "Virtual Machine" "2234-4608-7361-5707-5414-1946-93" "10.3.94.32" "gl-em-rsms22" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms23" "MICROSOFT" "Virtual Machine" "5896-0614-4340-6277-5813-2901-68" "10.3.94.33" "gl-em-rsms23" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms24" "MICROSOFT" "Virtual Machine" "2586-3311-1722-6171-2843-6903-78" "10.3.94.34" "gl-em-rsms24" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms25" "MICROSOFT" "Virtual Machine" "4848-7631-9492-2713-9356-2425-98" "10.3.94.35" "gl-em-rsms25" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms26" "MICROSOFT" "Virtual Machine" "8156-9149-2431-5918-3077-2150-51" "10.3.94.36" "gl-em-rsms26" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms27" "MICROSOFT" "Virtual Machine" "3666-4340-0379-0751-1390-1788-49" "10.3.85.73" "gl-em-rsms27" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms28" "MICROSOFT" "Virtual Machine" "0506-1082-3694-0842-0416-1056-79" "10.3.85.74" "gl-em-rsms28" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms29" "MICROSOFT" "Virtual Machine" "2181-2573-3013-8426-3987-0309-19" "10.3.85.75" "gl-em-rsms29" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsms30" "MICROSOFT" "Virtual Machine" "1911-0059-6202-2612-4776-5093-37" "10.3.85.76" "gl-em-rsms30" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsbat1" "MICROSOFT" "Virtual Machine" "1942-6348-2273-4575-6006-3555-88" "10.3.94.15" "gl-em-rsmsbat1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsbat2" "MICROSOFT" "Virtual Machine" "0773-8293-7774-3103-9411-3326-45" "10.3.94.16" "gl-em-rsmsbat2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsbat3" "MICROSOFT" "Virtual Machine" "5656-9901-8665-5088-9183-4934-68" "10.3.94.17" "gl-em-rsmsbat3" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsbat4" "MICROSOFT" "Virtual Machine" "0570-3053-5569-6134-1713-6087-47" "10.3.94.18" "gl-em-rsmsbat4" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsbat11" "MICROSOFT" "Virtual Machine" "9332-3854-7807-1535-4457-0636-15" "10.3.94.26" "gl-em-rsmsbat11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsbat12" "MICROSOFT" "Virtual Machine" "5523-6016-1756-9201-2998-1475-37" "10.3.85.68" "gl-em-rsmsbat12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsbat13" "MICROSOFT" "Virtual Machine" "9254-2783-2813-4459-4036-5496-18" "10.3.85.69" "gl-em-rsmsbat13" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsbat14" "MICROSOFT" "Virtual Machine" "3355-7208-3883-7519-8412-9565-54" "10.3.85.70" "gl-em-rsmsbat14" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsgw01" "MICROSOFT" "Virtual Machine" "5030-9644-1130-3183-1309-3767-74" "10.3.94.19" "gl-em-rsmsgw01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsgw1" "MICROSOFT" "Virtual Machine" "1268-4891-1595-0893-9468-6312-85" "10.3.85.71" "gl-em-rsmsgw1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmshfo01" "MICROSOFT" "Virtual Machine" "3837-7725-7852-6179-3948-7169-65" "10.3.94.20" "gl-em-rsmshfo01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmshfo1" "MICROSOFT" "Virtual Machine" "3500-2550-5839-5424-4275-7273-06" "10.3.85.72" "gl-em-rsmshfo1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsmail" "MICROSOFT" "Virtual Machine" "0839-6408-9524-5911-8201-3425-08" "10.3.94.21" "gl-em-rsmsmail" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsweb1" "MICROSOFT" "Virtual Machine" "1371-3362-5449-4153-2020-0044-95" "10.3.91.245" "gl-em-rsmsweb1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-rsmsweb2" "MICROSOFT" "Virtual Machine" "2413-7396-3678-3959-7105-1555-43" "10.3.93.196" "gl-em-rsmsweb2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-scvm1" "DELL" "PowerEdge R720" "8QJTC5J" "10.200.16.108" "gl-em-scvm1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-subca01" "MICROSOFT" "Virtual Machine" "4066-8819-3579-4642-2787-2629-84" "10.3.84.53" "gl-em-subca01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-sunapp1" "MICROSOFT" "Virtual Machine" "4820-0923-4773-9890-1201-4968-71" "10.3.83.104" "gl-em-sunapp1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-sunapp2" "MICROSOFT" "Virtual Machine" "7516-9946-9224-8665-4188-5459-70" "10.3.83.105" "gl-em-sunapp2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-suncit1" "MICROSOFT" "Virtual Machine" "6433-9642-6612-6036-7525-9655-79" "10.3.83.100" "gl-em-suncit1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-suncit2" "MICROSOFT" "Virtual Machine" "4731-7909-7470-4174-2232-3684-60" "10.3.83.101" "gl-em-suncit2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-suncit3" "MICROSOFT" "Virtual Machine" "0723-9554-8342-9900-4431-1005-29" "10.3.83.102" "gl-em-suncit3" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-suncit4" "MICROSOFT" "Virtual Machine" "3873-4349-0804-8033-4516-2268-23" "10.3.83.103" "gl-em-suncit4" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-sunshf11" "MICROSOFT" "Virtual Machine" "9060-0052-7709-0830-2089-6949-41" "10.3.86.85" "gl-em-sunshf11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-svn" "MICROSOFT" "Virtual Machine" "4260-8664-1109-6651-0112-5992-15" "10.3.95.229" "gl-em-svn" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taaf1ep1" "MICROSOFT" "Virtual Machine" "9302-9790-2569-7712-1466-6328-91" "10.3.85.218" "gl-em-taaf1ep1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taaf11" "MICROSOFT" "Virtual Machine" "2688-8787-5398-8139-8219-4220-73" "10.3.85.212" "gl-em-taaf11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taaf12" "MICROSOFT" "Virtual Machine" "3565-2140-9920-8529-3388-4883-25" "10.3.85.213" "gl-em-taaf12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taam1ep1" "MICROSOFT" "Virtual Machine" "5504-2384-1752-4279-6727-1959-92" "10.3.85.202" "gl-em-taam1ep1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taam2ep1" "MICROSOFT" "Virtual Machine" "0850-9849-5838-5606-0867-0210-81" "10.3.88.107" "gl-em-taam2ep1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taam11" "MICROSOFT" "Virtual Machine" "8897-6232-3584-1346-2245-0160-62" "10.3.85.196" "gl-em-taam11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taam12" "MICROSOFT" "Virtual Machine" "7002-3577-8463-9910-8507-3738-19" "10.3.85.197" "gl-em-taam12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taam13" "MICROSOFT" "Virtual Machine" "2292-4964-9098-1845-7295-8319-10" "10.3.85.198" "gl-em-taam13" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taam14" "MICROSOFT" "Virtual Machine" "9838-1010-5207-1123-7814-4375-78" "10.3.85.199" "gl-em-taam14" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taam15" "MICROSOFT" "Virtual Machine" "9824-3689-4889-6716-6187-3812-89" "10.3.85.200" "gl-em-taam15" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taam21" "MICROSOFT" "Virtual Machine" "8126-3002-8160-1585-6044-6968-85" "10.3.88.101" "gl-em-taam21" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taam22" "MICROSOFT" "Virtual Machine" "5177-1658-2452-1647-4682-7834-35" "10.3.88.102" "gl-em-taam22" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taam23" "MICROSOFT" "Virtual Machine" "4125-9835-2563-9548-6654-4459-47" "10.3.88.103" "gl-em-taam23" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taas1ep1" "MICROSOFT" "Virtual Machine" "1400-3093-6589-6218-5371-4314-55" "10.3.85.234" "gl-em-taas1ep1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taas11" "MICROSOFT" "Virtual Machine" "3401-0209-2713-4453-6880-2436-55" "10.3.85.228" "gl-em-taas11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taas12" "MICROSOFT" "Virtual Machine" "4130-4308-7286-0471-5300-3673-84" "10.3.85.229" "gl-em-taas12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tacit01" "MICROSOFT" "Virtual Machine" "2460-2174-2396-9499-0411-3225-64" "10.3.91.212" "gl-em-tacit01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tacit02" "MICROSOFT" "Virtual Machine" "3101-8627-5292-0694-3363-9029-36" "10.3.91.213" "gl-em-tacit02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tacit04" "MICROSOFT" "Virtual Machine" "4380-8916-5554-7036-5720-2281-97" "10.3.92.196" "gl-em-tacit04" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tacit05" "MICROSOFT" "Virtual Machine" "0580-8374-9530-3973-2969-2106-79" "10.3.92.197" "gl-em-tacit05" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tacit06" "MICROSOFT" "Virtual Machine" "9979-3168-0698-5529-0135-3866-65" "10.3.92.198" "gl-em-tacit06" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tacit11" "MICROSOFT" "Virtual Machine" "1145-8574-9138-8553-0050-5361-97" "10.3.88.182" "gl-em-tacit11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tacit12" "MICROSOFT" "Virtual Machine" "3178-4464-1271-8054-2205-8764-43" "10.3.88.183" "gl-em-tacit12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tacit13" "MICROSOFT" "Virtual Machine" "4358-4670-6051-7687-4585-9941-85" "10.3.88.184" "gl-em-tacit13" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tacit14" "MICROSOFT" "Virtual Machine" "4044-1956-1653-7092-8008-7111-12" "10.3.88.185" "gl-em-tacit14" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tadis11" "MICROSOFT" "Virtual Machine" "2176-7207-6137-2647-3380-0909-96" "10.3.85.106" "gl-em-tadis11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu1ep1" "MICROSOFT" "Virtual Machine" "7734-1649-0575-3636-8456-4116-12" "10.3.85.170" "gl-em-taeu1ep1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu2ep1" "MICROSOFT" "Virtual Machine" "3668-4021-3227-9406-2428-8918-74" "10.3.85.186" "gl-em-taeu2ep1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu2ep2" "MICROSOFT" "Virtual Machine" "3021-8827-3292-5728-8534-4819-41" "10.3.85.187" "gl-em-taeu2ep2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu3ep1" "MICROSOFT" "Virtual Machine" "2067-8482-5224-6719-9725-1621-42" "10.3.88.43" "gl-em-taeu3ep1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu4ep1" "MICROSOFT" "Virtual Machine" "8258-3469-0416-0088-0888-3724-35" "10.3.88.59" "gl-em-taeu4ep1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu11" "MICROSOFT" "Virtual Machine" "7159-1405-2113-0446-6544-8557-24" "10.3.85.164" "gl-em-taeu11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu12" "MICROSOFT" "Virtual Machine" "5645-8346-8866-4718-3127-8629-16" "10.3.85.165" "gl-em-taeu12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu13" "MICROSOFT" "Virtual Machine" "3625-4074-4437-0693-3914-7063-77" "10.3.85.166" "gl-em-taeu13" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu21" "MICROSOFT" "Virtual Machine" "8873-3482-6804-7682-2349-8612-78" "10.3.85.180" "gl-em-taeu21" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu22" "MICROSOFT" "Virtual Machine" "6824-5523-5169-7098-2024-3058-26" "10.3.85.181" "gl-em-taeu22" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu23" "MICROSOFT" "Virtual Machine" "5853-8205-0303-8831-9193-3266-89" "10.3.85.182" "gl-em-taeu23" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu31" "MICROSOFT" "Virtual Machine" "5844-1111-7617-2157-0826-1976-67" "10.3.88.37" "gl-em-taeu31" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu32" "MICROSOFT" "Virtual Machine" "4481-3131-0210-7407-7545-7649-87" "10.3.88.38" "gl-em-taeu32" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu41" "MICROSOFT" "Virtual Machine" "5802-6786-9920-1241-0308-0643-71" "10.3.88.53" "gl-em-taeu41" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taeu42" "MICROSOFT" "Virtual Machine" "2820-4916-2370-1444-4103-2668-99" "10.3.88.54" "gl-em-taeu42" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tagl1ep1" "MICROSOFT" "Virtual Machine" "9481-7696-4151-8015-4865-1014-61" "10.3.88.172" "gl-em-tagl1ep1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tagl11" "MICROSOFT" "Virtual Machine" "4400-5636-0142-5076-3513-3109-55" "10.3.88.166" "gl-em-tagl11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tagl12" "MICROSOFT" "Virtual Machine" "2016-1285-5317-5613-5236-5990-42" "10.3.88.167" "gl-em-tagl12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-takiosk1" "MICROSOFT" "Virtual Machine" "5117-5401-3161-4894-3336-0973-05" "10.3.128.105" "gl-em-takiosk1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-takiosk01" "MICROSOFT" "Virtual Machine" "3978-9978-5299-6214-0196-6798-69" "10.3.128.107" "gl-em-takiosk01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-talis1" "MICROSOFT" "Virtual Machine" "5010-7352-1966-3715-3241-0236-78" "10.3.85.24" "gl-em-talis1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-talis11" "MICROSOFT" "Virtual Machine" "7319-5712-0572-4026-8473-0858-65" "10.3.85.88" "gl-em-talis11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tango02" "MICROSOFT" "Virtual Machine" "4338-0784-0615-9768-2465-5601-39" "10.3.93.21" "gl-em-tango02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taoc1ep1" "MICROSOFT" "Virtual Machine" "9930-9472-8843-2279-4637-1196-97" "10.3.88.123" "gl-em-taoc1ep1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taoc11" "MICROSOFT" "Virtual Machine" "4484-6764-0618-0914-3366-5216-25" "10.3.88.117" "gl-em-taoc11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taoc12" "MICROSOFT" "Virtual Machine" "3209-6032-5943-6306-1684-2223-71" "10.3.88.118" "gl-em-taoc12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taweb1" "MICROSOFT" "Virtual Machine" "9985-3763-2707-6230-9285-9263-43" "10.3.85.100" "gl-em-taweb1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taweb2" "MICROSOFT" "Virtual Machine" "5290-6106-9110-0871-8887-7151-99" "10.3.85.101" "gl-em-taweb2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taweb3" "MICROSOFT" "Virtual Machine" "3280-8345-2666-8702-0256-1637-99" "10.3.85.102" "gl-em-taweb3" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taweb4" "MICROSOFT" "Virtual Machine" "8402-5264-5587-1591-4473-0041-22" "10.3.85.103" "gl-em-taweb4" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taweb11" "MICROSOFT" "Virtual Machine" "6585-1526-1739-4182-3299-5118-87" "10.3.85.132" "gl-em-taweb11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taweb12" "MICROSOFT" "Virtual Machine" "9683-1227-3871-4741-1267-1012-11" "10.3.85.133" "gl-em-taweb12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taweb13" "MICROSOFT" "Virtual Machine" "8215-4598-9617-5071-3103-3066-14" "10.3.85.134" "gl-em-taweb13" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-taweb14" "MICROSOFT" "Virtual Machine" "2754-8080-6896-9297-1345-8050-43" "10.3.85.135" "gl-em-taweb14" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tiger1" "MICROSOFT" "Virtual Machine" "3483-8999-4656-4078-6291-8123-33" "10.3.83.116" "gl-em-tiger1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-tstweb02" "MICROSOFT" "Virtual Machine" "1730-3634-0761-5290-2816-0598-03" "10.3.92.84" "gl-em-tstweb02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-ttbk01" "MICROSOFT" "Virtual Machine" "9078-0697-3678-8343-3724-1757-87" "10.3.93.164" "gl-em-ttbk01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-ttweb01" "MICROSOFT" "Virtual Machine" "7827-5161-9144-7517-9457-4176-64" "10.3.128.69" "gl-em-ttweb01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-uscheck" "MICROSOFT" "Virtual Machine" "6017-0171-7718-7155-8747-0955-27" "10.3.80.30" "gl-em-uscheck" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-web01" "MICROSOFT" "Virtual Machine" "5895-2728-6445-9310-2165-2036-08" "10.3.82.230" "gl-em-web01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-workb01" "MICROSOFT" "Virtual Machine" "2640-4782-4971-8917-4457-4372-76" "10.3.92.120" "gl-em-workb01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-workb02" "MICROSOFT" "Virtual Machine" "5948-8619-0207-4306-9844-1368-57" "10.3.92.121" "gl-em-workb02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-wsus1" "MICROSOFT" "Virtual Machine" "8687-2813-2777-0579-7606-7244-85" "10.3.88.235" "gl-em-wsus1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-wt1" "MICROSOFT" "Virtual Machine" "3113-3334-9393-3842-1963-3519-86" "10.3.89.182" "gl-em-wt1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-em-wt2" "MICROSOFT" "Virtual Machine" "7938-1726-3201-8723-0129-7671-07" "10.3.89.183" "gl-em-wt2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-li-amirep01" "MICROSOFT" "Virtual Machine" "1622-7268-5894-9535-0759-2403-82" "10.3.93.85" "gl-li-amirep01" "LINUX" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-li-einv01" "" "VMware Virtual Platform" "VMWARE-56 4D 58 FC 7A 28 1E F4-40 1C B0 D9 20 D1 A0 60" "10.3.82.180" "gl-li-einv01" "LINUX" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-li-inv01" "MICROSOFT" "Virtual Machine" "4062-5048-6204-6629-7819-7315-62" "10.3.84.40" "gl-li-inv01" "LINUX" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-li-myamidev01" "MICROSOFT" "Virtual Machine" "3125-0851-1012-1425-2591-2374-20" "10.3.92.245" "gl-li-myamidev01" "LINUX" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-ro-radius" "MICROSOFT" "Virtual Machine" "2919-5400-8847-6210-8185-1212-43" "10.3.94.132" "gl-ro-radius" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-wg-intca01" "MICROSOFT" "Virtual Machine" "0771-6927-2494-3521-0610-2424-84" "10.3.84.22" "gl-wg-intca01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "gl-wg-rootca" "MICROSOFT" "Virtual Machine" "4317-2888-2506-2679-6692-0103-05" "10.3.84.21" "gl-wg-rootca" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "hyd-as-cust01" "DELL" "PowerEdge 1950" "D1F6T1S" "10.49.0.135" "hyd-as-cust01" "WINDOWS" "Menzies Aviation Custom app server Server" IN:HYDERABAD.101
uat "hyd-as-fp01" "DELL" "PowerEdge 2900" "7CGYT1S" "10.49.0.29" "hyd-as-fp01" "WINDOWS" "Menzies Aviation Server" IN:HYDERABAD.101
uat "hydgh-gse-servr" "DELL" "PowerEdge T310" "32G482S" "10.49.3.50" "hydgh-gse-servr" "WINDOWS" "Menzies Aviation GSE Server" IN:HYDERABAD.101
uat "in-em-ebrk01" "MICROSOFT" "Virtual Machine" "2280-9894-9052-4256-3809-3480-22" "10.3.81.238" "in-em-ebrk01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "in-em-eweb01" "MICROSOFT" "Virtual Machine" "8350-2131-8173-0154-5686-9138-18" "10.3.128.227" "in-em-eweb01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "jfk-am-data1" "DELL" "PowerEdge T110 II" "1YW5LS1" "10.36.17.73" "jfk-am-data1" "WINDOWS" "Menzies Aviation File & Print Server" NY.NEWYORK.895
uat "jnb-ami-cctv01" "DELL" "PowerEdge R720" "2G3CF02" "" "jnb-ami-cctv01" "WINDOWS" "Menzies Aviation CCTV Server" ZA:JOHANNESBURG.102
uat "jnb-em-data01" "DELL" "PowerEdge R720" "HPJC302" "" "jnb-em-data01" "WINDOWS" "Menzies Aviation Server" ZA:JOHANNESBURG.102
uat "kta-as-data01" "MICROSOFT" "Virtual Machine" "3134-2274-6697-3699-4446-2381-04" "10.46.11.93" "kta-as-data01" "WINDOWS" "Menzies Aviation File & Print Server" AU:KARRATHA.101
uat "kta-as-mafp01" "DELL" "PowerEdge R620" "7JGN8X1" "10.46.11.103" "kta-as-mafp01" "WINDOWS" "Menzies Aviation File & Print Server" AU:KARRATHA.101
uat "lax-am-data2" "DELL" "PowerEdge T110 II" "1YVBLS1" "10.36.0.61" "lax-am-data2" "WINDOWS" "Menzies Aviation File & Print Server" CA.LOSANGELES.307
uat "lgw-em-data1" "DELL" "PowerEdge R310" "G1G545J" "10.34.13.26" "lgw-em-data1" "WINDOWS" "Menzies Aviation File & Print Server" GB:CRAWLEY.103
uat "lhr-am-dc1" "MICROSOFT" "Virtual Machine" "9582-1022-9796-9232-9149-7124-17" "10.3.90.136" "lhr-am-dc1" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-am-dc11" "DELL" "PowerEdge 2950" "82XVW2J" "10.3.230.142" "lhr-am-dc11" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-as-dc1" "MICROSOFT" "Virtual Machine" "1071-6863-2696-3408-8675-6160-03" "10.3.90.137" "lhr-as-dc1" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-as-dc11" "DELL" "PowerEdge 2950" "G1XVW2J" "10.3.230.143" "lhr-as-dc11" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-adm01" "MICROSOFT" "Virtual Machine" "9517-8334-9258-4618-1876-3725-67" "10.3.88.236" "lhr-em-adm01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-ami01" "DELL" "PowerEdge R710" "48TKS4J" "10.200.16.82" "lhr-em-ami01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-amiasm01" "MICROSOFT" "Virtual Machine" "7544-8884-9445-2852-1062-5567-89" "10.3.91.36" "lhr-em-amiasm01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-back11" "DELL" "PowerEdge R620" "14MJD5J" "10.3.230.133" "lhr-em-back11" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-back13" "DELL" "PowerEdge R710" "D26015J" "10.200.16.31" "lhr-em-back13" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-bid01" "MICROSOFT" "Virtual Machine" "1145-4732-3238-5405-9780-9503-96" "10.3.92.133" "lhr-em-bid01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-bitl01" "MICROSOFT" "Virtual Machine" "6668-9770-1426-6127-8574-9270-33" "10.3.83.132" "lhr-em-bitl01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-cctv1" "DELL" "PowerEdge R730xd" "6CZCC72" "10.34.14.31" "lhr-em-cctv1" "WINDOWS" "Menzies Aviation Server" GB:LONDON.175
uat "lhr-em-cctv2" "DELL" "PowerEdge R730xd" "6D27C72" "10.34.14.32" "lhr-em-cctv2" "WINDOWS" "Menzies Aviation Server" GB:LONDON.175
uat "lhr-em-cctv3" "DELL" "PowerEdge R730xd" "6CXDC72" "10.34.14.33" "lhr-em-cctv3" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-cv1" "DELL" "PowerEdge R720" "5ZVJD5J" "10.3.230.134" "lhr-em-cv1" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-cv2" "DELL" "PowerEdge R710" "F26015J" "10.3.230.135" "lhr-em-cv2" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-data11" "DELL" "PowerEdge R610" "JFB5W4J" "10.3.232.91" "lhr-em-data11" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-data12" "DELL" "PowerEdge R610" "1GB5W4J" "10.3.232.92" "lhr-em-data12" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-dc1" "MICROSOFT" "Virtual Machine" "7221-5047-9796-3184-8233-8521-75" "10.3.90.135" "lhr-em-dc1" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-dc11" "DELL" "PowerEdge 2950" "H1XVW2J" "10.3.230.141" "lhr-em-dc11" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-etvmfc1" "MICROSOFT" "Virtual Machine" "3158-4555-2550-9080-9685-0900-99" "10.3.94.190" "lhr-em-etvmfc1" "WINDOWS" "Menzies Aviation Server" GB:LONDON.175
uat "lhr-em-exch1" "MICROSOFT" "Virtual Machine" "2875-1995-3767-1837-1796-9579-98" "10.3.92.5" "lhr-em-exch1" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-exch2" "MICROSOFT" "Virtual Machine" "7456-9966-8065-5617-8191-8493-21" "10.3.92.6" "lhr-em-exch2" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-fedex01" "MICROSOFT" "Virtual Machine" "0677-6632-2345-9638-4137-2511-76" "10.3.94.68" "lhr-em-fedex01" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv01" "DELL" "PowerEdge R720" "B78RD5J" "10.3.235.10" "lhr-em-hv01" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv02" "DELL" "PowerEdge R720" "478RD5J" "10.3.235.8" "lhr-em-hv02" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv03" "DELL" "PowerEdge R720" "578RD5J" "10.3.235.12" "lhr-em-hv03" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv04" "DELL" "PowerEdge R720" "D78RD5J" "10.3.235.13" "lhr-em-hv04" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv05" "DELL" "PowerEdge R720" "G78RD5J" "10.3.235.8" "lhr-em-hv05" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv07" "DELL" "PowerEdge R720" "D68RD5J" "10.3.235.16" "lhr-em-hv07" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv08" "DELL" "PowerEdge R720" "C68RD5J" "10.3.235.17" "lhr-em-hv08" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv09" "DELL" "PowerEdge R720" "C78RD5J" "10.3.235.5" "lhr-em-hv09" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv10" "DELL" "PowerEdge R720" "F68RD5J" "10.3.235.19" "lhr-em-hv10" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv11" "DELL" "PowerEdge R720" "83HKD5J" "10.3.235.7" "lhr-em-hv11" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv12" "DELL" "PowerEdge R720" "63HKD5J" "10.3.235.21" "lhr-em-hv12" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv15" "DELL" "PowerEdge R720" "7YJYH5J" "10.3.235.24" "lhr-em-hv15" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv16" "DELL" "PowerEdge R720" "8YJYH5J" "10.3.235.25" "lhr-em-hv16" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv17" "DELL" "PowerEdge R630" "D7CFG42" "10.3.235.23" "lhr-em-hv17" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv18" "DELL" "PowerEdge R630" "18CFG42" "10.3.235.22" "lhr-em-hv18" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv19" "DELL" "PowerEdge R620" "8S8JD5J" "10.3.235.37" "lhr-em-hv19" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv20" "DELL" "PowerEdge R620" "9S8JD5J" "10.3.235.36" "lhr-em-hv20" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-hv21" "DELL" "PowerEdge R720" "D2DJD5J" "10.3.235.39" "lhr-em-hv21" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-matel" "MICROSOFT" "Virtual Machine" "5239-6643-6619-8821-0315-2927-51" "10.3.93.52" "lhr-em-matel" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-mwcasm" "MICROSOFT" "Virtual Machine" "5300-9139-1447-9437-6884-9017-18" "10.3.93.212" "lhr-em-mwcasm" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-np1" "DELL" "PowerEdge R610" "9S7MZ4J" "10.3.239.16" "lhr-em-np1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-ome1" "MICROSOFT" "Virtual Machine" "7544-5309-2570-7800-8070-1961-49" "10.3.90.133" "lhr-em-ome1" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-print1" "DELL" "PowerEdge M610" "DD8WW4J" "10.200.16.240" "lhr-em-print1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-print2" "DELL" "PowerEdge M610" "355WW4J" "10.200.16.241" "lhr-em-print2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-print3" "DELL" "PowerEdge M610" "7D8WW4J" "10.200.16.242" "lhr-em-print3" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-print4" "DELL" "PowerEdge M610" "CD8WW4J" "10.200.16.243" "lhr-em-print4" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-print5" "DELL" "PowerEdge M610" "455WW4J" "10.200.16.244" "lhr-em-print5" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-print6" "DELL" "PowerEdge M610" "B55WW4J" "10.200.16.245" "lhr-em-print6" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-print7" "DELL" "PowerEdge M610" "9D8WW4J" "10.200.16.246" "lhr-em-print7" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-print8" "DELL" "PowerEdge M610" "655WW4J" "10.200.16.247" "lhr-em-print8" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-print11" "MICROSOFT" "Virtual Machine" "3967-2477-3181-5988-2968-5516-37" "10.3.90.165" "lhr-em-print11" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-print12" "MICROSOFT" "Virtual Machine" "5536-7471-5024-6102-9621-8679-74" "10.3.90.166" "lhr-em-print12" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-print13" "MICROSOFT" "Virtual Machine" "4645-9809-4371-1404-6746-9210-59" "10.3.90.167" "lhr-em-print13" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-print14" "MICROSOFT" "Virtual Machine" "0335-7041-2208-7986-6653-2266-92" "10.3.90.168" "lhr-em-print14" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-print15" "MICROSOFT" "Virtual Machine" "1430-2255-2690-2012-2538-5845-14" "10.3.90.169" "lhr-em-print15" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-print16" "MICROSOFT" "Virtual Machine" "8987-3648-0462-9193-3003-3737-07" "10.3.90.170" "lhr-em-print16" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-print17" "MICROSOFT" "Virtual Machine" "2087-1361-5792-8145-8956-8150-43" "10.3.90.171" "lhr-em-print17" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-print18" "MICROSOFT" "Virtual Machine" "8180-0213-3574-2156-0954-3876-48" "10.3.90.172" "lhr-em-print18" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-qarsweb01" "MICROSOFT" "Virtual Machine" "3562-3094-4623-0463-6416-1619-20" "10.3.90.71" "lhr-em-qarsweb01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-qvapp1" "DELL" "PowerEdge R820" "8R6JD5J" "10.3.239.17" "lhr-em-qvapp1" "WINDOWS" "Menzies Aviation BI Server" GB:BRACKNELL.102
uat "lhr-em-qvfs1" "DELL" "PowerEdge R720" "5Y1JD5J" "10.3.239.15" "lhr-em-qvfs1" "WINDOWS" "Menzies Aviation BI Server" GB:BRACKNELL.102
uat "lhr-em-radprox1" "MICROSOFT" "Virtual Machine" "3054-1861-4300-8443-5049-6027-64" "10.3.129.3" "lhr-em-radprox1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-rdcb1" "MICROSOFT" "Virtual Machine" "3223-0540-9557-7651-6022-6339-01" "10.3.94.181" "lhr-em-rdcb1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-sanhq01" "MICROSOFT" "Virtual Machine" "3564-4338-8017-2298-7084-4126-28" "10.3.90.141" "lhr-em-sanhq01" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-sc01" "DELL" "PowerEdge R720" "6YJTC5J" "10.3.235.60" "lhr-em-sc01" "WINDOWS" "Menzies Aviation VMM Server" GB:WOKING.001
uat "lhr-em-scom1" "MICROSOFT" "Virtual Machine" "1359-1365-0438-0488-2735-5672-53" "10.3.90.164" "lhr-em-scom1" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-scsq1" "MICROSOFT" "Virtual Machine" "7354-0172-2738-1574-3031-1519-67" "10.3.91.91" "lhr-em-scsq1" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-scsq2" "MICROSOFT" "Virtual Machine" "4154-2692-3659-3570-5624-8898-19" "10.3.91.90" "lhr-em-scsq2" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-sms01" "DELL" "PowerEdge 1950" "B72QF3J" "10.3.235.50" "lhr-em-sms01" "WINDOWS" "Menzies Aviation SMS Gateway Server" GB:BRACKNELL.102
uat "lhr-em-sq1" "MICROSOFT" "Virtual Machine" "5941-8255-6444-1128-7321-4686-46" "10.3.91.84" "lhr-em-sq1" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-sq01" "MICROSOFT" "Virtual Machine" "3592-2189-7956-2270-0338-9020-17" "10.3.91.55" "lhr-em-sq01" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-sq02" "MICROSOFT" "Virtual Machine" "1328-6067-9929-3866-7170-0851-50" "10.3.91.53" "lhr-em-sq02" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-sq2" "MICROSOFT" "Virtual Machine" "5561-3015-0120-0561-8515-4393-87" "10.3.91.86" "lhr-em-sq2" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-sq3" "MICROSOFT" "Virtual Machine" "6564-7428-6301-4509-6261-4989-34" "10.3.91.87" "lhr-em-sq3" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-sq03" "MICROSOFT" "Virtual Machine" "1031-4739-2508-9973-4843-6497-18" "10.3.91.54" "lhr-em-sq03" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-sq4" "MICROSOFT" "Virtual Machine" "9490-1719-2933-6702-6059-4875-34" "10.3.91.22" "lhr-em-sq4" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-srv1" "MICROSOFT" "Virtual Machine" "2497-0436-6124-3106-4803-5486-20" "10.3.95.89" "lhr-em-srv1" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-stor1" "MICROSOFT" "Virtual Machine" "6536-7281-6079-4421-4039-3591-54" "10.3.95.90" "lhr-em-stor1" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-em-vault1" "DELL" "PowerEdge R610" "D8XB85J" "10.3.239.21" "lhr-em-vault1" "WINDOWS" "Menzies Aviation Vault Server" GB:WOKING.001
uat "lhr-em-vaultsq1" "DELL" "PowerEdge R610" "BGXB85J" "10.3.239.20" "lhr-em-vaultsq1" "WINDOWS" "Menzies Aviation Vault Server" GB:WOKING.001
uat "lhr-em-wt01" "MICROSOFT" "Virtual Machine" "7389-7560-0804-9766-0857-0954-44" "10.3.89.180" "lhr-em-wt01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-wt02" "MICROSOFT" "Virtual Machine" "4138-6156-3374-1628-4765-1729-01" "10.3.89.181" "lhr-em-wt02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-em-zapastel" "DELL" "PowerEdge 1950" "4HX584J" "10.200.16.80" "lhr-em-zapastel" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-li-amiproj01" "DELL" "PowerEdge R710" "GC1RT4J" "10.200.16.67" "lhr-li-amiproj01" "LINUX" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-li-cvprx01" "DELL" "PowerEdge R720" "6ZVJD5J" "10.3.233.74" "lhr-li-cvprx01" "LINUX" "Menzies Aviation Commvault Media Server" GB:BRACKNELL.102
uat "lhr-li-emnt01" "DELL" "PowerEdge 2950" "G4MWC3J" "10.3.236.5" "lhr-li-emnt01" "LINUX" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-li-etvora01" "" "VMware Virtual Platform" "VMWARE-42 3F 78 2A 63 3E E6 B4-6E 2D C6 3F 70 D8 BD 08" "" "lhr-li-etvora01" "LINUX" "Menzies Aviation Server" GB:LONDON.175
uat "lhr-li-myamidb01" "DELL" "PowerEdge R720" "FLFYH5J" "10.3.233.63" "lhr-li-myamidb01" "LINUX" "Menzies Aviation Server" GB:BRACKNELL.102
uat "lhr-li-ora01" "DELL" "PowerEdge R610" "CQSM85J" "10.3.109.72" "lhr-li-ora01" "LINUX" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-li-ora02" "DELL" "PowerEdge R610" "4QSM85J" "10.3.109.73" "lhr-li-ora02" "LINUX" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-li-ora03" "DELL" "PowerEdge R610" "FQSM85J" "10.3.109.74" "lhr-li-ora03" "LINUX" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-md-dc1" "MICROSOFT" "Virtual Machine" "5405-9650-1374-0288-3337-3459-48" "10.3.91.165" "lhr-md-dc1" "WINDOWS" "Menzies Aviation DC Server" GB:WOKING.001
uat "lhr-ro-dc1" "MICROSOFT" "Virtual Machine" "3728-1483-7536-0748-6838-5129-96" "10.3.90.134" "lhr-ro-dc1" "WINDOWS" "Menzies Aviation DC Server" GB:WOKING.001
uat "lhr-ro-dc11" "DELL" "PowerEdge 2950" "52XVW2J" "10.3.230.140" "lhr-ro-dc11" "WINDOWS" "Menzies Aviation DC Server" GB:WOKING.001
uat "lhr-ro-dhcp01" "MICROSOFT" "Virtual Machine" "1781-0941-1988-0735-4550-0774-39" "10.3.90.140" "lhr-ro-dhcp01" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-ro-dhcp02" "MICROSOFT" "Virtual Machine" "5661-9853-5804-5050-1131-9669-35" "10.3.91.166" "lhr-ro-dhcp02" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "lhr-ro-ipam" "MICROSOFT" "Virtual Machine" "1789-8682-8117-0861-0518-7630-83" "10.3.90.138" "lhr-ro-ipam" "WINDOWS" "Menzies Aviation Server" GB:WOKING.001
uat "mel-as-adm1" "" "VMware Virtual Platform" "VMWARE-56 4D F7 EE 54 0D FE 95-88 39 87 84 57 EF FE EB" "10.44.2.203" "mel-as-adm1" "WINDOWS" "Menzies Aviation Server" AU:MELBOURNE.101
uat "mel-as-amidata1" "MICROSOFT" "Virtual Machine" "5417-1424-9532-0935-2752-7745-03" "10.46.3.111" "mel-as-amidata1" "WINDOWS" "Menzies Aviation Server" AU:MELBOURNE.101
uat "mel-as-amifp01" "DELL" "PowerEdge T320" "BT88GY1" "10.46.3.104" "mel-as-amifp01" "WINDOWS" "Menzies Aviation Server" AU:MELBOURNE.101
uat "mel-as-data01" "" "VMware Virtual Platform" "VMWARE-56 4D 2C 22 79 F6 68 BE-EA 83 52 86 CB 3A 18 5A" "10.44.2.211" "mel-as-data01" "WINDOWS" "Menzies Aviation Server" AU:MELBOURNE.101
uat "mel-as-dc1" "" "VMware Virtual Platform" "VMWARE-42 35 60 66 B6 45 5C 58-4F A6 6C 4C C1 A1 99 16" "10.44.2.215" "mel-as-dc1" "WINDOWS" "Menzies Aviation Server" AU:MELBOURNE.101
uat "mel-as-print01" "" "VMware Virtual Platform" "VMWARE-56 4D 80 6C 3F 42 51 1C-60 97 45 8A 9A 89 A9 FE" "10.44.2.212" "mel-as-print01" "WINDOWS" "Menzies Aviation Server" AU:MELBOURNE.101
uat "mel-as-wsus01" "" "VMware Virtual Platform" "VMWARE-56 4D 5E 8E 10 C2 7B E3-64 1F 93 49 59 17 51 A5" "10.44.2.210" "mel-as-wsus01" "WINDOWS" "Menzies Aviation Server" AU:MELBOURNE.101
uat "mel-as-wsus1" "" "VMware Virtual Platform" "VMWARE-42 35 D7 DB 3D E4 AE 10-7C 1F 50 93 CE AD 96 5E" "10.44.2.213" "mel-as-wsus1" "WINDOWS" "Menzies Aviation Server" AU:MELBOURNE.101
uat "mmx-em-data01" "DELL" "PowerEdge T710" "9D8285J" "10.54.2.18" "mmx-em-data01" "WINDOWS" "Menzies Aviation File & Print Server" SE:MALMO.101
uat "mo-em-batcit01" "MICROSOFT" "Virtual Machine" "3652-8736-7845-9020-8026-7728-72" "10.3.81.244" "mo-em-batcit01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "mo-em-batcit02" "MICROSOFT" "Virtual Machine" "9270-8289-4402-7791-7227-7318-22" "10.3.81.245" "mo-em-batcit02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "mo-em-repcit01" "MICROSOFT" "Virtual Machine" "7061-5569-1178-2178-3901-1529-42" "10.3.81.246" "mo-em-repcit01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "mo-em-sfmess01" "MICROSOFT" "Virtual Machine" "4728-2221-2240-1896-7843-4409-12" "10.3.81.247" "mo-em-sfmess01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "mon-em-hv1" "DELL" "PowerEdge M610" "C65WW4J" "" "mon-em-hv1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "mon-em-hv2" "DELL" "PowerEdge M610" "8D8WW4J" "" "mon-em-hv2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "mon-em-hv3" "DELL" "PowerEdge M610" "B65WW4J" "" "mon-em-hv3" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "mon-em-hv4" "DELL" "PowerEdge M610" "BD8WW4J" "" "mon-em-hv4" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "mx-em-ebill01" "MICROSOFT" "Virtual Machine" "1798-5731-9193-5807-8906-7237-59" "10.3.89.68" "mx-em-ebill01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "ord-am-data2" "DELL" "PowerEdge T110 II" "1YV5LS1" "10.36.0.186" "ord-am-data2" "WINDOWS" "Menzies Aviation File & Print Server" IL.CHICAGO.423
uat "otp-em-fp01" "DELL" "PowerEdge T310" "4R1SV4J" "10.42.3.70" "otp-em-fp01" "WINDOWS" "Menzies Aviation Server" IL.CHICAGO.423
uat "per-as-amifp01" "DELL" "PowerEdge T320" "5WJFG2S" "10.44.2.82" "per-as-amifp01" "WINDOWS" "Menzies Aviation File & Print Server" AU:PERTH.101
uat "per-as-mafp01" "DELL" "PowerEdge T320" "4WJFG2S" "10.45.1.110" "per-as-mafp01" "WINDOWS" "Menzies Aviation File & Print Server" AU:PERTH.101
uat "sfo-am-data1" "DELL" "PowerEdge T110 II" "1YV9LS1" "10.38.6.78" "sfo-am-data1" "WINDOWS" "Menzies Aviation File & Print Server" GB:BRACKNELL.102
uat "sfo-em-batch01" "MICROSOFT" "Virtual Machine" "8296-1539-5032-4065-2865-4213-53" "10.3.84.148" "sfo-em-batch01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "sfo-em-batch02" "MICROSOFT" "Virtual Machine" "7225-2824-7247-6974-0215-8525-81" "10.3.84.149" "sfo-em-batch02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "sfo-em-citrix01" "MICROSOFT" "Virtual Machine" "3813-7397-3237-0707-2222-0836-07" "10.3.84.150" "sfo-em-citrix01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "sfo-em-citrix02" "MICROSOFT" "Virtual Machine" "6816-6295-9690-6572-4912-6566-16" "10.3.84.151" "sfo-em-citrix02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "sfo-em-mess01" "MICROSOFT" "Virtual Machine" "5110-5096-1218-6113-9070-0795-96" "10.3.84.153" "sfo-em-mess01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "sfo-em-schr01" "MICROSOFT" "Virtual Machine" "6710-1188-1292-5521-0173-0413-65" "10.3.84.152" "sfo-em-schr01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "sfo-em-shfo01" "MICROSOFT" "Virtual Machine" "2759-8891-6810-8545-0703-3417-24" "10.3.84.154" "sfo-em-shfo01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "syd-as-adm1" "" "VMware Virtual Platform" "VMWARE-42 3B 2A 6F E1 F2 A9 D5-75 F1 F0 49 82 62 C3 0A" "10.45.7.144" "syd-as-adm1" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-amifp01" "DELL" "PowerEdge R210" "3JZP62S" "10.46.25.116" "syd-as-amifp01" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-back01" "DELL" "PowerVault DL2200" "HPS4C2S" "10.45.7.139" "syd-as-back01" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-data01" "" "VMware Virtual Platform" "VMWARE-42 19 8E 6C 30 A6 B0 84-97 DA 8B FB DF 5E 18 45" "10.45.7.145" "syd-as-data01" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-data02" "" "VMware Virtual Platform" "VMWARE-42 35 6B E8 78 FC 34 24-24 0B 40 D5 9C 5A 23 D2" "10.45.7.154" "syd-as-data02" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-data03" "" "VMware Virtual Platform" "VMWARE-42 35 F5 27 CC C8 85 08-65 46 1A 04 52 77 09 8A" "10.45.7.160" "syd-as-data03" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-dc1" "" "VMware Virtual Platform" "VMWARE-42 35 DC 1D 37 69 2A 47-21 12 7E E8 E6 11 6C AA" "10.45.7.158" "syd-as-dc1" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-mail01" "" "VMware Virtual Platform" "VMWARE-42 35 C3 1A AA 0D D1 CD-82 5E 8E 54 B5 5D 76 0E" "10.45.7.150" "syd-as-mail01" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-nmon01" "" "VMware Virtual Platform" "VMWARE-42 19 DF 1C 94 FF D4 6B-AC 31 BA F8 69 48 94 EF" "10.45.7.142" "syd-as-nmon01" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-print" "" "VMware Virtual Platform" "VMWARE-56 4D A5 70 CC D4 72 41-73 8E C4 B8 DA E3 43 3A" "10.45.7.146" "syd-as-print" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-psi01" "" "VMware Virtual Platform" "VMWARE-42 35 D5 F0 85 BA C0 EA-32 49 D5 07 7E 36 3C 3C" "10.45.7.159" "syd-as-psi01" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-sedi01" "" "VMware Virtual Platform" "VMWARE-42 35 6D 9D C1 DD 23 0A-DC 3D 05 DE 37 65 84 E1" "10.45.7.149" "syd-as-sedi01" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-sp01" "" "VMware Virtual Platform" "VMWARE-42 35 BC 7E 74 10 2F 21-07 46 AF 9B F1 96 7A 98" "10.45.7.153" "syd-as-sp01" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-spoint01" "" "VMware Virtual Platform" "VMWARE-42 35 D2 88 A5 C3 25 77-58 AE 0A 23 33 D5 93 C1" "10.45.7.164" "syd-as-spoint01" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-sql01" "" "VMware Virtual Platform" "VMWARE-42 35 65 36 F1 35 83 11-9A 06 2A 31 0E 34 E6 FA" "10.45.7.148" "syd-as-sql01" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-vi1" "" "VMware Virtual Platform" "VMWARE-56 4D 9F F2 AB BA A7 B2-8C 70 2F 0E 6C 85 D2 05" "10.45.7.140" "syd-as-vi1" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-wsus01" "" "VMware Virtual Platform" "VMWARE-42 19 F2 D7 24 F2 C3 5E-F9 F9 1E 2B 18 9B 02 11" "10.45.7.143" "syd-as-wsus01" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-as-wsus1" "" "VMware Virtual Platform" "VMWARE-42 35 5C 72 8B 61 75 3B-37 57 CC 4A 37 BF 61 5B" "10.45.7.155" "syd-as-wsus1" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "syd-ro-dhcp01" "" "VMware Virtual Platform" "VMWARE-42 35 F5 F5 1F 60 4A 6E-E2 15 63 DC 13 B0 29 3D" "10.45.7.165" "syd-ro-dhcp01" "WINDOWS" "Menzies Aviation Server" AU:SYDNEY.105
uat "t1-em-epow01" "MICROSOFT" "Virtual Machine" "8320-7016-0007-9527-3916-5294-90" "10.3.88.100" "t1-em-epow01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "t1-em-taweb11" "MICROSOFT" "Virtual Machine" "9786-4777-0675-2728-7895-0794-89" "10.3.88.20" "t1-em-taweb11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "t2-em-epow01" "MICROSOFT" "Virtual Machine" "2592-5335-9144-0099-6691-6554-32" "10.3.88.116" "t2-em-epow01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "t2-em-taweb11" "MICROSOFT" "Virtual Machine" "4623-1805-1647-8516-6437-0051-57" "10.3.88.36" "t2-em-taweb11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "t4-em-epow04" "MICROSOFT" "Virtual Machine" "0448-9007-5326-2051-7833-8702-15" "10.3.88.151" "t4-em-epow04" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "t4-em-taweb01" "MICROSOFT" "Virtual Machine" "9085-1972-5586-0612-5159-6958-38" "10.3.88.73" "t4-em-taweb01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "t4-em-taweb04" "MICROSOFT" "Virtual Machine" "7888-7639-8600-5668-3544-8277-23" "10.3.88.72" "t4-em-taweb04" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "t4-em-taweb12" "MICROSOFT" "Virtual Machine" "5002-2762-5961-6570-6452-4744-61" "10.3.88.69" "t4-em-taweb12" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "t5-em-epow01" "MICROSOFT" "Virtual Machine" "1256-1810-3932-5692-9610-6242-60" "10.3.88.164" "t5-em-epow01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "t5-em-taweb11" "MICROSOFT" "Virtual Machine" "5927-0989-4615-2883-1121-0382-19" "10.3.88.88" "t5-em-taweb11" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-arc01" "DELL" "PowerEdge 2800" "HTCPX1J" "10.200.16.81" "tst-em-arc01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-arincap2" "MICROSOFT" "Virtual Machine" "3659-4884-2524-0079-0858-3858-67" "10.3.90.232" "tst-em-arincap2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-arincgw1" "MICROSOFT" "Virtual Machine" "8624-5343-2547-3649-2756-2197-93" "10.3.95.85" "tst-em-arincgw1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-arincgw2" "MICROSOFT" "Virtual Machine" "2342-8419-0249-7565-2784-7373-50" "10.3.90.233" "tst-em-arincgw2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-ccsuk1" "MICROSOFT" "Virtual Machine" "6742-8546-2063-8753-1012-3855-01" "10.3.90.206" "tst-em-ccsuk1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-heapp01" "MICROSOFT" "Virtual Machine" "4980-2078-3156-3860-1112-9637-32" "10.3.90.199" "tst-em-heapp01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-heapp02" "MICROSOFT" "Virtual Machine" "2664-4412-1312-0106-0098-7108-14" "10.3.90.200" "tst-em-heapp02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-heapp03" "MICROSOFT" "Virtual Machine" "2188-1772-1575-7161-3553-3716-23" "10.3.90.201" "tst-em-heapp03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-heatapp1" "MICROSOFT" "Virtual Machine" "7836-8218-0799-2079-8155-4934-17" "10.3.90.234" "tst-em-heatapp1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hebat1" "MICROSOFT" "Virtual Machine" "2818-9459-6965-7244-6397-4006-88" "10.3.84.101" "tst-em-hebat1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hebrk01" "MICROSOFT" "Virtual Machine" "3228-3268-1110-5591-1013-8632-46" "10.3.90.214" "tst-em-hebrk01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hecit1" "MICROSOFT" "Virtual Machine" "8717-1943-9330-5576-4947-7204-74" "10.3.84.102" "tst-em-hecit1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hecit01" "MICROSOFT" "Virtual Machine" "4593-4450-1737-0059-6955-9492-05" "10.3.90.196" "tst-em-hecit01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hecit02" "MICROSOFT" "Virtual Machine" "4396-4667-3358-0916-3731-3705-73" "10.3.90.197" "tst-em-hecit02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hecit03" "MICROSOFT" "Virtual Machine" "9941-4744-6357-7995-9063-7030-23" "10.3.90.198" "tst-em-hecit03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hemes1" "MICROSOFT" "Virtual Machine" "0193-0019-5848-1528-8199-6298-15" "10.3.90.213" "tst-em-hemes1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-heshf1" "MICROSOFT" "Virtual Machine" "2606-2205-3703-4251-9012-0721-24" "10.3.84.103" "tst-em-heshf1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-heshf01" "MICROSOFT" "Virtual Machine" "3997-5719-3043-6709-3313-0765-90" "10.3.90.212" "tst-em-heshf01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hv1" "DELL" "PowerEdge R720" "GQWJD5J" "10.200.16.55" "tst-em-hv1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hv2" "DELL" "PowerEdge R720" "HQWJD5J" "10.200.16.56" "tst-em-hv2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hv4" "DELL" "PowerEdge R720xd" "BPCW522" "10.200.16.99" "tst-em-hv4" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hycit1" "MICROSOFT" "Virtual Machine" "6830-2498-8161-3888-5420-0033-09" "10.3.90.205" "tst-em-hycit1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hyepm1" "MICROSOFT" "Virtual Machine" "6320-3375-0060-7009-7352-8839-73" "10.3.90.202" "tst-em-hyepm1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hyesb1" "MICROSOFT" "Virtual Machine" "9229-3242-7003-8844-0988-6689-47" "10.3.90.203" "tst-em-hyesb1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-hyweb1" "MICROSOFT" "Virtual Machine" "9957-6862-1990-1691-9068-5046-45" "10.3.90.204" "tst-em-hyweb1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-itsm01" "MICROSOFT" "Virtual Machine" "9450-0552-4909-9034-2984-3536-30" "10.3.90.228" "tst-em-itsm01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-mars" "MICROSOFT" "Virtual Machine" "9615-6282-5161-2306-5634-2732-11" "10.3.90.237" "tst-em-mars" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-mess1" "MICROSOFT" "Virtual Machine" "4494-8193-4356-6272-0795-2907-35" "10.3.84.104" "tst-em-mess1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-rsms01" "MICROSOFT" "Virtual Machine" "3933-9789-1783-6900-8707-2660-46" "10.3.90.236" "tst-em-rsms01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-rsmsweb1" "MICROSOFT" "Virtual Machine" "9284-5870-6622-1199-7566-8122-05" "10.3.90.190" "tst-em-rsmsweb1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-sunapp1" "MICROSOFT" "Virtual Machine" "5734-6356-9955-0224-1888-5632-01" "10.3.90.230" "tst-em-sunapp1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-suncit1" "MICROSOFT" "Virtual Machine" "8595-7705-1730-6498-2814-5442-05" "10.3.90.231" "tst-em-suncit1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-tacit01" "MICROSOFT" "Virtual Machine" "1046-0853-2929-7484-0753-4047-65" "10.3.88.181" "tst-em-tacit01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-talis1" "MICROSOFT" "Virtual Machine" "3802-3829-9736-5914-7604-9509-81" "10.3.85.125" "tst-em-talis1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-talis01" "MICROSOFT" "Virtual Machine" "9104-0439-2156-7774-0110-7331-68" "10.3.85.107" "tst-em-talis01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-taweb1" "MICROSOFT" "Virtual Machine" "0131-2197-5874-0893-3575-5844-86" "10.3.85.126" "tst-em-taweb1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-ts5" "MICROSOFT" "Virtual Machine" "1297-0728-8018-2949-9023-3181-20" "10.3.83.9" "tst-em-ts5" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-ts6" "MICROSOFT" "Virtual Machine" "4076-3893-7701-6164-7047-3240-34" "10.3.83.10" "tst-em-ts6" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-uamq1" "MICROSOFT" "Virtual Machine" "7856-6062-4498-2747-1161-1539-03" "10.3.90.238" "tst-em-uamq1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "tst-em-wt1" "MICROSOFT" "Virtual Machine" "9897-1802-2877-6470-6226-0787-24" "10.3.90.235" "tst-em-wt1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-amiapp01" "MICROSOFT" "Virtual Machine" "8090-3556-5440-9956-3555-1630-99" "10.3.93.101" "uk-em-amiapp01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-amiapp1" "MICROSOFT" "Virtual Machine" "8753-6852-3459-9195-6448-0963-68" "10.3.86.53" "uk-em-amiapp1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-amiasm02" "MICROSOFT" "Virtual Machine" "6143-1606-0393-0220-2550-1782-74" "10.3.80.36" "uk-em-amiasm02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-amiasm2" "MICROSOFT" "Virtual Machine" "9500-0138-3537-5236-4900-7056-80" "10.3.80.39" "uk-em-amiasm2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-amines01" "MICROSOFT" "Virtual Machine" "0591-7621-8812-9235-1322-3705-14" "10.3.80.37" "uk-em-amines01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-amines1" "MICROSOFT" "Virtual Machine" "2449-6842-2523-6498-7798-0527-78" "10.3.80.38" "uk-em-amines1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-amitnt01" "MICROSOFT" "Virtual Machine" "4467-7004-4011-8102-0716-2072-29" "10.3.128.147" "uk-em-amitnt01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-aurora1" "MICROSOFT" "Virtual Machine" "5934-7215-0872-9282-6078-2348-64" "10.3.86.4" "uk-em-aurora1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-bagsol01" "MICROSOFT" "Virtual Machine" "5581-5161-8094-3706-9308-0745-30" "10.3.94.148" "uk-em-bagsol01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-batch1" "MICROSOFT" "Virtual Machine" "3475-9101-8823-8949-6335-7892-76" "10.3.83.183" "uk-em-batch1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-batch2" "MICROSOFT" "Virtual Machine" "3437-1282-2455-5938-5170-7828-11" "10.3.83.184" "uk-em-batch2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-boxtop1" "MICROSOFT" "Virtual Machine" "4218-0296-6407-6537-6829-3985-61" "10.3.93.245" "uk-em-boxtop1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-citapp01" "MICROSOFT" "Virtual Machine" "3836-4806-9860-4099-4078-7586-05" "10.3.93.36" "uk-em-citapp01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-citapp02" "MICROSOFT" "Virtual Machine" "3855-3225-5134-7758-3594-3365-53" "10.3.93.37" "uk-em-citapp02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-citapp03" "MICROSOFT" "Virtual Machine" "7168-9035-6606-4572-6365-7284-51" "10.3.93.38" "uk-em-citapp03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-citrix1" "MICROSOFT" "Virtual Machine" "5361-2127-4883-0571-5425-0725-85" "10.3.83.181" "uk-em-citrix1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-citrix2" "MICROSOFT" "Virtual Machine" "4973-3429-9207-7879-2426-6018-02" "10.3.83.182" "uk-em-citrix2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-citrix3" "MICROSOFT" "Virtual Machine" "0031-2468-9263-0495-8747-7101-04" "10.3.83.185" "uk-em-citrix3" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-citrix03" "MICROSOFT" "Virtual Machine" "2515-3533-9901-2568-5620-9708-74" "10.3.89.152" "uk-em-citrix03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-jmcitapp01" "MICROSOFT" "Virtual Machine" "1945-3847-0644-3244-8042-4388-14" "10.3.82.212" "uk-em-jmcitapp01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-mess1" "MICROSOFT" "Virtual Machine" "4094-0478-7595-7448-7701-6180-64" "10.3.83.186" "uk-em-mess1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-mess01" "MICROSOFT" "Virtual Machine" "6523-6219-5047-3711-7201-1446-86" "10.3.89.156" "uk-em-mess01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-mon02" "MICROSOFT" "Virtual Machine" "5366-6906-6552-5519-7784-7132-48" "10.3.90.173" "uk-em-mon02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-mwcasm01" "MICROSOFT" "Virtual Machine" "4513-8281-8027-8785-5671-6342-37" "10.3.93.214" "uk-em-mwcasm01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-pfund01" "MICROSOFT" "Virtual Machine" "0014-7160-8340-3514-2608-2186-20" "10.3.82.133" "uk-em-pfund01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-pfund1" "MICROSOFT" "Virtual Machine" "0896-3595-6511-4134-7428-5379-75" "10.3.82.132" "uk-em-pfund1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-schr1" "MICROSOFT" "Virtual Machine" "6757-3174-1341-3938-3980-9859-04" "10.3.83.187" "uk-em-schr1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-secmon01" "MICROSOFT" "Virtual Machine" "0946-2769-7263-7155-6976-7053-56" "10.3.93.5" "uk-em-secmon01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-shfo1" "MICROSOFT" "Virtual Machine" "6127-3462-6306-6384-4214-3520-58" "10.3.83.188" "uk-em-shfo1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "uk-em-wsus1" "MICROSOFT" "Virtual Machine" "6200-2926-5768-2411-0579-9204-18" "10.3.88.229" "uk-em-wsus1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-am-wkstest" "MICROSOFT" "Virtual Machine" "3971-7579-2470-2498-0382-1122-06" "10.3.88.232" "us-am-wkstest" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-batch1" "MICROSOFT" "Virtual Machine" "8794-9628-3854-6587-4225-0642-83" "10.3.89.164" "us-em-batch1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-batch2" "MICROSOFT" "Virtual Machine" "2326-1898-9832-8210-9300-5425-28" "10.3.89.165" "us-em-batch2" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-citapp1" "MICROSOFT" "Virtual Machine" "4452-5459-0882-9253-6943-1148-02" "10.3.81.23" "us-em-citapp1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-citapp01" "MICROSOFT" "Virtual Machine" "9146-8701-5672-7265-6547-3445-26" "10.3.81.20" "us-em-citapp01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-citrix01" "MICROSOFT" "Virtual Machine" "7014-4010-4129-2052-6448-5023-17" "10.3.89.166" "us-em-citrix01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-citrix02" "MICROSOFT" "Virtual Machine" "7561-8060-1030-6837-0489-0183-02" "10.3.89.167" "us-em-citrix02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-citrix03" "MICROSOFT" "Virtual Machine" "3669-9321-4031-8851-3709-0196-39" "10.3.89.168" "us-em-citrix03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-finance1" "MICROSOFT" "Virtual Machine" "5981-6648-8009-6601-6083-0284-61" "10.3.86.117" "us-em-finance1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-mess01" "MICROSOFT" "Virtual Machine" "3587-2809-2030-9268-7200-5993-19" "10.3.89.169" "us-em-mess01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-pent1" "MICROSOFT" "Virtual Machine" "3323-7296-1031-7591-9171-9878-84" "10.3.81.30" "us-em-pent1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-schr01" "MICROSOFT" "Virtual Machine" "8748-8952-2580-0990-8594-0301-39" "10.3.89.170" "us-em-schr01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-shfo01" "MICROSOFT" "Virtual Machine" "5831-3720-5215-9727-2552-9714-33" "10.3.89.171" "us-em-shfo01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "us-em-uamq1" "MICROSOFT" "Virtual Machine" "5960-3195-9298-3223-6613-0099-79" "10.3.130.84" "us-em-uamq1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "wdh-em-data01" "DELL" "PowerEdge 2900" "..CN1374083Q01W8." "" "wdh-em-data01" "WINDOWS" "Menzies Aviation Server" NA:WINDHOEK.101
uat "wdhinkdcs" "DELL" "PowerEdge 2950" "H4XJT3J" "" "wdhinkdcs" "WINDOWS" "Menzies Aviation Server" NA:WINDHOEK.101
uat "yyc-am-data1" "DELL" "PowerEdge T110 II" "1YW4LS1" "10.38.4.77" "yyc-am-data1" "WINDOWS" "Menzies Aviation File & Print Server" AB.CALGARY.105
uat "yyz-ca-data1" "DELL" "PowerEdge T110 II" "JCV6Q22" "10.36.13.73" "yyz-ca-data1" "WINDOWS" "Menzies Aviation File & Print Server" ON.MISSISSAUGA.138
uat "za-em-amicit01" "MICROSOFT" "Virtual Machine" "8007-9650-5913-0788-0496-1215-22" "10.3.89.197" "za-em-amicit01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-amicit02" "MICROSOFT" "Virtual Machine" "3291-5308-9863-8271-6177-5555-74" "10.3.89.198" "za-em-amicit02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-batch01" "MICROSOFT" "Virtual Machine" "4249-7655-1554-2172-7025-6433-93" "10.3.89.116" "za-em-batch01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-batch02" "MICROSOFT" "Virtual Machine" "3293-2414-5608-6920-8665-6142-21" "10.3.89.117" "za-em-batch02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-cargoss1" "MICROSOFT" "Virtual Machine" "9608-0076-6665-4146-5052-1169-66" "10.3.89.199" "za-em-cargoss1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-citapp01" "MICROSOFT" "Virtual Machine" "6391-7226-9654-5232-5069-1180-54" "10.3.88.212" "za-em-citapp01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-citrix01" "MICROSOFT" "Virtual Machine" "7648-6259-1998-8142-8534-4877-13" "10.3.89.118" "za-em-citrix01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-citrix02" "MICROSOFT" "Virtual Machine" "5167-5315-5053-4078-7608-8224-47" "10.3.89.119" "za-em-citrix02" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-citrix03" "MICROSOFT" "Virtual Machine" "3417-9968-6330-1384-0735-8899-91" "10.3.89.120" "za-em-citrix03" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-cus01" "MICROSOFT" "Virtual Machine" "7380-4604-8798-3605-4185-0867-43" "10.3.89.124" "za-em-cus01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-erp01" "MICROSOFT" "Virtual Machine" "5650-9477-3374-8928-2501-7062-55" "10.3.80.52" "za-em-erp01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-erpcit01" "MICROSOFT" "Virtual Machine" "4782-3974-8536-4369-5958-3506-66" "10.3.80.53" "za-em-erpcit01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-jnb-cgo01" "DELL" "PowerEdge R720" "6LYYMW1" "" "za-em-jnb-cgo01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-mess01" "MICROSOFT" "Virtual Machine" "4931-6824-3189-0481-1412-1210-89" "10.3.89.121" "za-em-mess01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-schr01" "MICROSOFT" "Virtual Machine" "2825-5502-1486-4705-4169-3475-25" "10.3.89.122" "za-em-schr01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-shfo01" "MICROSOFT" "Virtual Machine" "7593-1732-6413-0794-0350-7564-73" "10.3.89.123" "za-em-shfo01" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-vipbe1" "MICROSOFT" "Virtual Machine" "1521-6228-3722-3441-8737-7014-20" "10.3.80.54" "za-em-vipbe1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-vipcit1" "MICROSOFT" "Virtual Machine" "4024-4392-9795-5961-4925-2613-69" "10.3.80.56" "za-em-vipcit1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
uat "za-em-viprds1" "MICROSOFT" "Virtual Machine" "9720-8658-2502-4497-8570-4604-01" "10.3.80.55" "za-em-viprds1" "WINDOWS" "Menzies Aviation Server" GB:BRACKNELL.102
#
# Refine the output and run the actual script
#
sed 's/\\//g' /tmp/ppp > /tmp/p4
#sh -x /tmp/p4
