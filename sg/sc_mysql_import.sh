#!/usr/bin/php -q
<?php

$link = mysql_connect('localhost', 'root', '');
if (!$link) {
    die('Could not connect: ' . mysql_error());
}
echo "Connected successfully\n";
mysql_select_db("testing", $link);
if (file_exists('/tmp/sc.sql'))
{
	shell_exec("echo '' > /tmp/sc.sql");

}

clearTables($link);
$file = fopen('/data/sc-sasu-all.txt', 'r');
if ($file)
{
	$i=0;
	while (($line = fgetcsv($file, 100000, "\t")) !== FALSE) {
	  //$line is an array of the csv elements
	  if ($i==0)
	  {
		$header=$line;
	  }else{
		//print_r($line);
		$line2=map_fields($header,$line);
		if ($line2['asset_guid'] != '')
		{
		
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
			echo "****Asset Guid Empty****\n";
			$emptyGuid[]=$line2;
			$id=genMySQLGuid($link);
			echo "\n\n\n*******$id";
			$line2['asset_guid']=$id;
			insert_missing_guid($line2,$link);
			updateMissingAssetData($line2, $id,$link);
			
		}
	  }
	  
	  $i++;
	}
	fclose($file);
	
}



if (count($emptyGuid) > 0)
{
$to      = 'andrew.philp@sungardas.com, paul.ferguson@sungardas.com';
$subject = 'Service Center Items without GUID';
$message = 'Hi, The following devices do not have a GUID assigned to them within Service Center - You need to fix this!!\n\n\n'.print_r($emptyGuid,true);
$headers = 'From: reports@sungardas.local' . "\r\n" .
    'Reply-To: reports@sungardas.local' . "\r\n" .
    'X-Mailer: PHP/' . phpversion();

mail($to, $subject, $message, $headers);

}


mysql_close($link);


if (file_exists('/tmp/sc.sql'))
{
	shell_exec("mysql -uroot testing < /tmp/sc.sql");
	shell_exec("rm -rf /tmp/sc.sql");

}




function map_fields($header,$line)
{
	foreach ($header as $key => $value) {
		$newarr[$value]=$line[$key];
	}
	return $newarr;
}

function insert_missing_guid($line,$link)
{
	$sql    = 'insert into `testing`.`scMissingGuid` (asset_guid) VALUES("'.$line['asset_guid'].'")';
	$result = mysql_query($sql, $link);
	if ($result) {
		
		return true;
	}else{
		return false;
	}
}


function updateMissingAssetData($array, $id,$link) {
	$sql='UPDATE `testing`.`scMissingGuid` SET ';
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


function genMySQLGuid($link)
{
	echo "HERE GEN UUID";
	$sql    = 'select uuid() as id';
	echo $sql;
	$result = mysql_query($sql, $link);
	if ($result) {
		echo "Got it";
		$num_rows = mysql_num_rows($result);
		if ($num_rows ==0)
		{
			echo "no rows";
			echo "FALSE";
			return false;
		}else{
			echo "*****GOT Rows\n\n\n";
			while($row = mysql_fetch_array($result)) {
				echo "\nLoop\n";
				$uuid=$row['id'];
				echo $uuid;
			  }
			echo "ID";
			return $uuid;
		}
	}else{
		echo "FALSE";
		return false;
	}
}

function check_guid_exists($line,$link)
{
	
	$sql    = 'select asset_guid FROM `testing`.`sc` WHERE asset_guid = "'.$line['asset_guid'].'"';
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
	$sql    = 'insert into `testing`.`sc` (asset_guid) VALUES("'.$line['asset_guid'].'")';
	
	$result = mysql_query($sql, $link);
	if ($result) {
		
		return true;
	}else{
		return false;
	}
}

function clearTables($link)
{
	$sql    = 'truncate scMissingGuid;';
	$result = mysql_query($sql, $link);
}

function updateAssetData($array, $id,$link) {
	$sql='UPDATE `testing`.`sc` SET ';
    foreach ($array as $key => $value) {
		$sql.=$key."='".mysql_real_escape_string($value)."',";
	}
		if (substr($sql,-1)==",")
		{
			$sql = substr($sql,0,-1);
		}
		$sql.=" where asset_guid='".$id."';";
		file_put_contents("/tmp/sc.sql", $sql, FILE_APPEND | LOCK_EX);
	
}



?>
