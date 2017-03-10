#!/usr/bin/php -q
<?php

$link = mysql_connect('localhost', 'root', '');
if (!$link) {
    die('Could not connect: ' . mysql_error());
}
echo "Connected successfully\n";
mysql_select_db("testing", $link);
if (file_exists('/tmp/zenoss.sql'))
{
	shell_exec("echo '' > /tmp/zenoss.sql");

}


clearTables($link);

$file = fopen('/data/zenoss_latest.csv', 'r');
if ($file)
{
	$i=0;
	while (($line = fgetcsv($file, 100000, ",")) !== FALSE) {
	  //$line is an array of the csv elements
	  if ($i==0)
	  {
		$header=$line;
	  }else{
		//print_r($line);
		$line2=map_fields($header,$line);
		if ($line2['asset_guid'] <> "" ){
			if (!check_guid_exists($line2,$link))
			{
				echo "asset Guid:".$line2['asset_guid']." - ".strlen($line2['asset_guid'])." - Needs Creating\n";
				if (insert_guid($line2,$link))
				{
					echo "Created: ".$line2['asset_guid']."\n";
				}else{
					echo "Failed to create: ".$line2['asset_guid']."\n";
				}
			}else{
				echo "The GUID: ".$line2['asset_guid']." - Already Exists\n";
			}
			updateAssetData($line2, $line2['asset_guid'],$link);
		}else{
			//device has no asset_guid defines in Zenoss - Ticketing will be a problem
			$emptyGuid[]=$line2;
			$id=genMySQLGuid($link);
			$line2['asset_guid']=$id;
			insert_missing_guid($line2,$link);
			echo "Missing Guid: ".$line2['asset_guid']."\n";
			updateMissingAssetData($line2, $id,$link);
		}
	  }
	  
	  $i++;
	}
	fclose($file);
	echo $i;
	//print_r($header);
}

if (count($emptyGuid) > 0)
{
$to      = 'andrew.philp@sungardas.com, paul.ferguson@sungardas.com';
$subject = 'Zenoss Items without GUID';
$message = 'Hi, The following devices do not have a GUID assigned to them within Zenoss - You need to fix this!!\n\n\n'.print_r($emptyGuid,true);
$headers = 'From: reports@sungardas.local' . "\r\n" .
    'Reply-To: reports@sungardas.local' . "\r\n" .
    'X-Mailer: PHP/' . phpversion();

mail($to, $subject, $message, $headers);

}

mysql_close($link);


if (file_exists('/tmp/zenoss.sql'))
{
	shell_exec("mysql -uroot testing < /tmp/zenoss.sql");
	shell_exec("rm -rf /tmp/zenoss.sql");

}




function map_fields($header,$line)
{
	foreach ($header as $key => $value) {
		$newarr[$value]=$line[$key];
	}
	return $newarr;
}


function check_guid_exists($line,$link)
{
	
	$sql    = 'select asset_guid FROM `testing`.`zenoss` WHERE asset_guid = "'.$line['asset_guid'].'"';
	$result = mysql_query($sql, $link);
	if ($result) {
		$num_rows = mysql_num_rows($result);
		if ($num_rows ==0)
		{
			return false;
		}else{
			return true;
		}
	}else{
		return false;
	}	
	
	
}

function insert_guid($line,$link)
{
	$sql    = 'insert into `testing`.`zenoss` (asset_guid) VALUES("'.$line['asset_guid'].'")';
	$result = mysql_query($sql, $link);
	if ($result) {
		
		return true;
	}else{
		return false;
	}
}

function insert_missing_guid($line,$link)
{
	$sql    = 'insert into `testing`.`zenossMissingGuid` (asset_guid) VALUES("'.$line['asset_guid'].'")';
	$result = mysql_query($sql, $link);
	if ($result) {
		
		return true;
	}else{
		return false;
	}
}

function genMySQLGuid($link)
{
	$sql    = 'select uuid() as id';
	$result = mysql_query($sql, $link);
	if ($result) {
		$num_rows = mysql_num_rows($result);
		if ($num_rows ==0)
		{
			return false;
		}else{
			while($row = mysql_fetch_array($result)) {
				// do something with the $row
				$uuid=$row['id'];
			  }
			return $uuid;
		}
	}else{
		return false;
	}
}

function clearTables($link)
{
	$sql    = 'truncate zenossMissingGuid;';
	$result = mysql_query($sql, $link);
}

function updateAssetData($array, $id,$link) {
	$sql='UPDATE `testing`.`zenoss` SET ';
    foreach ($array as $key => $value) {
		$sql.=$key."='".mysql_real_escape_string($value)."',";
	}
		if (substr($sql,-1)==",")
		{
			$sql = substr($sql,0,-1);
		}
		$sql.=" where asset_guid='".$id."';";
		file_put_contents("/tmp/zenoss.sql", $sql, FILE_APPEND | LOCK_EX);
	
}

function updateMissingAssetData($array, $id,$link) {
	$sql='UPDATE `testing`.`zenossMissingGuid` SET ';
	echo "HERE Writing Data to missing Table\n\n";
    foreach ($array as $key => $value) {
		$sql.=$key."='".mysql_real_escape_string($value)."',";
	}
		if (substr($sql,-1)==",")
		{
			$sql = substr($sql,0,-1);
		}
		$sql.=" where asset_guid='".$id."';";
		$result = mysql_query($sql, $link);
		//file_put_contents("/tmp/zenoss.sql", $sql, FILE_APPEND | LOCK_EX);
		
	
}



?>