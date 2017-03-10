#!/bin/bash

MYI=`which mysqlimport`

/usr/local/bin/convutf8.sh /data/sn/EuropeXAllXCompanies.csv /data/sn/customers.csv
/usr/local/bin/convutf8.sh /data/sn/EuropeanXOpenXIncidentsXPFXExport.csv /data/sn/open_incidents.csv
/usr/local/bin/convutf8.sh /data/sn/EuropeanXUsersXPFXExport.csv /data/sn/sn_users.csv
/usr/local/bin/convutf8.sh /data/sn/UKXOpenXINCXCHGXRITM.csv /data/sn/ukopen.csv
/usr/local/bin/convutf8.sh /data/sn/DailyXUKXChangesXNotXClosed.csv /data/sn/dailynotclosed.csv
/usr/local/bin/convutf8.sh /data/sn/EuropeanXProjectsXPFXexport.csv /data/sn/euro_projects.csv
/usr/local/bin/convutf8.sh /data/sn/EuropeanXTicketsXPFXexport.csv /data/sn/euro_tickets.csv
/usr/local/bin/convutf8.sh /data/sn/UKXClosedXYesterdayXINCXCHGXRITM.csv /data/sn/tickets_closed_yesterday.csv
/usr/local/bin/convutf8.sh /data/sn/UKXPFXDirectorsXOpenXTickets.csv /data/sn/directors_open_tickets.csv


