#!/bin/bash
mysqldump -h alarmreport.sgns.net -umonnoise --password='R3p0rt1ng!@' --single-transaction mon_noise alarms | mysql -h10.236.16.76 -unoiserestore -pPassword123 mon_noise
