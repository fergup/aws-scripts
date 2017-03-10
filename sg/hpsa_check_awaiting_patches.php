<?php
//echo "http://213.212.69.3:23/index.php/welcome/hpsa_test4/".$argv[1];

//170970103

$url = 'http://10.236.16.75/_int_api/index.php/audit/auditPatches';
$file2 = file_get_contents($url);
$data2 = json_decode($file2);


//print_r($data2);


if (isset($data2))
{

	print_r($data2);
	if (is_array($data2)){
	foreach ($data2 as $key => $value)
	   {
		  $APIUrl = 'http://213.212.69.3:23/index.php/welcome/hpsa_patches/'.$value->mid.'/'.$value->policy_long;
		  $filex = file_get_contents($APIUrl);
		  echo ".";
		
	   }

	}
}else{
	echo "Nothing Waiting\n";
}
/*

$options = array(
        'http' => array(
        'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
        'method'  => 'POST',
        'content' => http_build_query($data2),
    )
);

$context  = stream_context_create($options);
$result = file_get_contents($url, false, $context);
var_dump($result);







$url = 'http://10.236.16.75/_int_api/index.php/sgas/hpsa_device_push';
$data = json_decode($file);
$options = array(
        'http' => array(
        'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
        'method'  => 'POST',
        'content' => http_build_query($data),
    )
);

$context  = stream_context_create($options);
$result = file_get_contents($url, false, $context);
var_dump($result);
*/

?>
