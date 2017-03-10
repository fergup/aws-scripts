#!/usr/bin/php
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
curl_setopt($ch, CURLOPT_URL, "http://10.236.16.75/_int_api/index.php/Servicecenter/TruncateData?table=ECSFLEX");
curl_setopt($ch, CURLOPT_HEADER, 0);

// grab URL and pass it to the browser
curl_exec($ch);

// close cURL resource, and free up system resources
curl_close($ch);

# Get the newest file, should probably add some decent checks on this
$files = glob("/data/flex/archive/flex*.in.EdisonUKSite1.txt");
rsort($files);
$newest_file = $files[0];

$psv= file_get_contents($newest_file);
# Remove any additional lines
$psv = str_replace("\r\n", "\n", $psv);

# Convert the string from pipe to comma seperated
$csv = preg_replace('/\|/',',',$psv);
$array = array_map('str_getcsv', explode("\n", $csv));

# Remove the first row as it is the heading and remove any empty elements
unset($array[0]);

foreach($array as $server) {
if (is_array ($server)){
  $fred = PostToIrelandWeb('sgas','ecsflexData',$server);
}
}

?>
