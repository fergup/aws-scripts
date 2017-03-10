#!/bin/bash

MYI=`which mysqlimport`

/usr/local/bin/convutf8.sh /data/sn/EuropeXAllXCompanies.csv /data/sn/customers.csv

$MYI -uroot --ignore-lines=1 --compress --delete --fields-optionally-enclosed-by='"' --fields-terminated-by=',' --fields-escaped-by='' --lines-terminated-by='\n' --local uktools /data/sn/customers.csv

rm -rf /data/sn/customers.csv



/usr/local/bin/convutf8.sh /data/sn/EuropeanXOpenXIncidentsXPFXExport.csv /data/sn/open_incidents.csv
$MYI -uroot --ignore-lines=1 --compress --delete --fields-optionally-enclosed-by='"' --fields-terminated-by=',' --fields-escaped-by='' --lines-terminated-by='\n' --local uktools /data/sn/open_incidents.csv

rm -rf /data/sn/open_incidents.csv

/usr/local/bin/convutf8.sh /data/sn/EuropeanXUsersXPFXExport.csv /data/sn/sn_users.csv
$MYI -uroot --ignore-lines=1 --compress --delete --fields-optionally-enclosed-by='"' --fields-terminated-by=',' --fields-escaped-by='' --lines-terminated-by='\n' --local uktools /data/sn/sn_users.csv

rm -rf /data/sn/sn_users.csv

/usr/local/bin/convutf8.sh /data/sn/UKXOpenXINCXCHGXRITM.csv /data/sn/ukopen.csv

$MYI -uroot --ignore-lines=1 --compress --delete --fields-optionally-enclosed-by='"' --fields-terminated-by=',' --fields-escaped-by='' --lines-terminated-by='\n' --local uktools /data/sn/ukopen.csv

rm -rf /data/sn/ukopen.csv

/usr/local/bin/convutf8.sh /data/sn/DailyXUKXChangesXNotXClosed.csv /data/sn/dailynotclosed.csv

$MYI -uroot --ignore-lines=1 --compress --delete --fields-optionally-enclosed-by='"' --fields-terminated-by=',' --fields-escaped-by='' --lines-terminated-by='\n' --local uktools /data/sn/dailynotclosed.csv

rm -rf /data/sn/dailynotclosed.csv



/usr/local/bin/convutf8.sh /data/sn/EuropeanXProjectsXPFXexport.csv /data/sn/euro_projects.csv

$MYI -uroot --ignore-lines=1 --compress --delete --fields-optionally-enclosed-by='"' --fields-terminated-by=',' --fields-escaped-by='' --lines-terminated-by='\n' --local uktools /data/sn/euro_projects.csv

rm -rf /data/sn/euro_projects.csv




/usr/local/bin/convutf8.sh /data/sn/EuropeanXTicketsXPFXexport.csv /data/sn/euro_tickets.csv

$MYI -uroot --ignore-lines=1 --compress --delete --fields-optionally-enclosed-by='"' --fields-terminated-by=',' --fields-escaped-by='' --lines-terminated-by='\n' --local uktools /data/sn/euro_tickets.csv

rm -rf /data/sn/euro_tickets.csv


#UKXClosedXYesterdayXINCXCHGXRITM.csv

/usr/local/bin/convutf8.sh /data/sn/UKXClosedXYesterdayXINCXCHGXRITM.csv /data/sn/tickets_closed_yesterday.csv

$MYI -uroot --ignore-lines=1 --compress --delete --fields-optionally-enclosed-by='"' --fields-terminated-by=',' --fields-escaped-by='' --lines-terminated-by='\n' --local uktools /data/sn/tickets_closed_yesterday.csv

rm -rf /data/sn/tickets_closed_yesterday.csv





/usr/local/bin/convutf8.sh /data/sn/UKXPFXDirectorsXOpenXTickets.csv /data/sn/directors_open_tickets.csv

$MYI -uroot --ignore-lines=1 --compress --delete --fields-optionally-enclosed-by='"' --fields-terminated-by=',' --fields-escaped-by='' --lines-terminated-by='\n' --local uktools /data/sn/directors_open_tickets.csv

rm -rf /data/sn/directors_open_tickets.csv

#hpsa servers

$MYI -uroot --ignore-lines=1 --compress --delete --fields-optionally-enclosed-by='"' --fields-terminated-by=',' --fields-escaped-by='' --lines-terminated-by='\n' --local uktools /data/hpsa_servers.csv


$MYI  -uroot uktools -e "insert into hpsaOSAudit SELECT CURRENT_DATE,\`Operating system\` as os,count(*) as TotalDevices FROM hpsa_servers GROUP BY \`Operating system\`"

$MYI -uroot uktools -e "insert into customerCount SELECT CURRENT_DATE,u_support_organization, count(*) as total FROM customers GROUP BY u_support_organization"

$MYI -uroot uktools -e "insert into customerStateAudit SELECT CURRENT_DATE,u_status,count(*) as total FROM `customers` GROUP BY u_status"

