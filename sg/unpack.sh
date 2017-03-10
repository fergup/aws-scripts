#/bin/bash
# Script to unpack incoming email attachments
munpack -f /var/spool/mail/reporting -C /data/sn; >/var/spool/mail/reporting 
