These Reports are made up of three files, one that provides information on Virtual Machines, one on Datastores and finally one on the number of ESXi Blades.

This script connects to all Vcenters for ECS and MPC across the UK and then outputs the results to 3 csv files that are zipped/compressed and emailed. 

VM Report excludes template and inventory VMs (beginning t-* and i-*). 

Datastore Report excludes type NFS and Datastore Names with the following *-inmage* *internal* *inventory* and *local*.  

Blade Report doesn't have any excludes.   

The zip file attached in this email is also saved to D:\PowerCLI\Reports on OAMPUK TS Servers so we have an archive of the weekly reports. 

Scripts Created and Scheduled by Stephen Davies but runs under service account called oampuk\svc_ad_ps
