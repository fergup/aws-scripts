<?php
set_time_limit(0);


$url = 'http://10.236.16.75/_int_api/index.php/audit/patchVoRequired';
$file2 = file_get_contents($url);
$data2 = json_decode($file2);
//getPatchVO




foreach ($data2 as $key => $value)
{
	$url ='http://213.212.69.3:23/index.php/welcome/getPatchVO/'.$value->patch_id;
	$file2 = file_get_contents($url);
	$data = json_decode($file2);
	postVO($data,$argv[1]);
	
}



function postVO($data,$policy){

$url = 'http://10.236.16.75/_int_api/index.php/sgas/hpsa_PatchVO/'.$policy;

		$options = array(
				'http' => array(
				'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
				'method'  => 'POST',
				'content' => http_build_query($data),
			)
		);

		$context  = stream_context_create($options);
		$result = file_get_contents($url, false, $context);
	print_r($result);
}




?>