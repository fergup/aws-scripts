<?php

function PostToIrelandWeb($controller,$function,$object,$id = null)
{
$url = 'http://10.236.16.75/_int_api/index.php/'.$controller.'/'.$function.'/'.$id;

$options = array(
'http' => array(
'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
'method'  => 'POST',
'content' => http_build_query($object),
)
);

$context  = stream_context_create($options);
$result = file_get_contents($url, false, $context);
return $result;
}

# Run Curl code
// create a new cURL resource
$ch = curl_init();

// set URL and other appropriate options
curl_setopt($ch, CURLOPT_URL, "http://10.236.16.75/_int_api/index.php/Servicecenter/TruncateData?table=sepm");
curl_setopt($ch, CURLOPT_HEADER, 0);

// grab URL and pass it to the browser
curl_exec($ch);

// close cURL resource, and free up system resources
curl_close($ch);


$file="/data/SEP_Client_Information_Query.csv";
$csv= file_get_contents($file);
$array = array_map("str_getcsv", explode("\n", $csv));

foreach($array as $server) {
if (is_array ($server)){
  $fred = PostToIrelandWeb('sgas','sepmData',$server);
  echo $fred;
}
}



?>
