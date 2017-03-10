<?php

$file = file_get_contents("http://213.212.69.3:23/index.php/welcome/hpsa_test2/".$argv[1]);


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


$file2 = file_get_contents("http://213.212.69.3:23/index.php/welcome/hpsa_test3/".$argv[1]);
$url2 = 'http://10.236.16.75/_int_api/index.php/sgas/hpsa_software_push/'.$argv[1];
$data2 = json_decode($file2);
$options2 = array(
        'http' => array(
        'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
        'method'  => 'POST',
        'content' => http_build_query($data2),
    )
);

$context2  = stream_context_create($options2);
$result2 = file_get_contents($url2, false, $context2);
var_dump($result2);


$file3 = file_get_contents("http://213.212.69.3:23/index.php/welcome/hpsa_test4/".$argv[1]);
$url3 = 'http://10.236.16.75/_int_api/index.php/sgas/hpsa_service_push/'.$argv[1];
$data3 = json_decode($file3);
$options3 = array(
        'http' => array(
        'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
        'method'  => 'POST',
        'content' => http_build_query($data3),
    )
);

$context3  = stream_context_create($options3);
$result3 = file_get_contents($url3, false, $context3);
var_dump($result3);

//######

$file99 = file_get_contents("http://213.212.69.3:23/index.php/welcome/hpsa_test99/".$argv[1]);

//170970103

$url99 = 'http://10.236.16.75/_int_api/index.php/sgas/hpsa_policy_relationship/'.$argv[1];
$data99 = json_decode($file99);



$options99 = array(
        'http' => array(
        'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
        'method'  => 'POST',
        'content' => http_build_query($data99),
    )
);

$context99  = stream_context_create($options99);
$result99 = file_get_contents($url99, false, $context99);
var_dump($result99);





?>
