#!/bin/bash
#
#This script back's up to a VM on the HP DL380 Gen 5 Hypervisor in Area 3 / T06
#

mysqldump -uroot uktools | gzip -c | ssh root@10.132.230.9 'cat > /home/backups/uktools.sql.gz'
mysqldump -uroot mon_transfer | gzip -c | ssh root@10.132.230.9 'cat > /home/backups/mon_transfer.sql.gz'
mysqldump -uroot mon_noise | gzip -c | ssh root@10.132.230.9 'cat > /home/backups/mon_noise.sql.gz'


mysqldump -uroot uktools | gzip -c > /data/backups/uktools.sql.gz
mysqldump -uroot mon_transfer | gzip -c > /data/backups/mon_transfer.sql.gz
mysqldump -uroot mon_noise | gzip -c > /data/backups/mon_noise.sql.gz



cd /var/www/
rm -rf ukreports.tgz
tar cvzf ukreports.tgz ukreports
scp ukreports.tgz root@10.132.230.9:/home/backups/
rm -rf /data/backups/ukreports.tgz
cp /var/www/ukreports.tgz /data/backups/ukreports.tgz
rm -rf /var/www/ukreports.tgz

cd /data
tar cvzf /tmp/data.tgz *
scp /tmp/data.tgz root@10.132.230.9:/home/backups/
rm -rf /tmp/data.tgz

cd /usr/local/bin
tar cvzf /tmp/binscripts.tgz *
scp /tmp/binscripts.tgz root@10.132.230.9:/home/backups/
rm -rf /tmp/binscripts.tgz
