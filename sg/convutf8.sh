#!/usr/bin/php -q
<?php

var_dump($argv);
$str = mb_convert_encoding(file_get_contents($argv[1]),"UTF-8");
//echo $str;
file_put_contents($argv[2], $str);


?>
