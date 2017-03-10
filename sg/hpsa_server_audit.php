<?php

$file = file_get_contents("http://10.236.16.75/_int_api/index.php/audit/auditIndex");

$i=0;
$x=0;
foreach (json_decode($file) as $key => $value) {
	
	echo $value."\n";
	//print_r($value);
	exec("/usr/bin/php /usr/local/bin/hpsa_server_detail_audit.php ".$value. " > /dev/null 2>/dev/null &");
	$i++;
	$x++;
	if ($i==30)
	{
		$i=0;
		sleep(10);
	}
	
}


$file1 = file_get_contents("http://10.236.16.75/_int_api/index.php/audit/auditPatchDetails");

foreach (json_decode($file1) as $key => $value) {
	//echo $value."\n"; 
	print_r($value->patch_id);
}

exec("rm -rf /tmp/wsdl-* > /dev/null 2>/dev/null &");

?>
