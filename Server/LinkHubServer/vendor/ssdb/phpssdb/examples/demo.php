<?php
/**
 * Copyright (c) 2012, ideawu
* All rights reserved.
* @author: ideawu
* @link: http://www.ideawu.com/
*
* SSDB PHP API demo.
*/

spl_autoload_register(function($class){
    require str_replace('SSDB', '../src/', str_replace('\\', '/', $class)) . '.php';
    return true;
});

$host = '127.0.0.1';
$port = 8888;


try{
    $ssdb = new SSDB\SimpleClient($host, $port);
    //$ssdb->easy();
}catch(Exception $e){
    die(__LINE__ . ' ' . $e->getMessage());
}

var_dump($ssdb->set('test', time()));
var_dump($ssdb->set('test', time()));
echo $ssdb->get('test') . "\n";
var_dump($ssdb->del('test'));
var_dump($ssdb->del('test'));
var_dump($ssdb->get('test'));
echo "\n";

var_dump($ssdb->hset('test', 'b', time()));
var_dump($ssdb->hset('test', 'b', time()));
echo $ssdb->hget('test', 'b') . "\n";
var_dump($ssdb->hdel('test', 'b'));
var_dump($ssdb->hdel('test', 'b'));
var_dump($ssdb->hget('test', 'b'));
echo "\n";

var_dump($ssdb->zset('test', 'a', time()));
var_dump($ssdb->zset('test', 'a', time()));
echo $ssdb->zget('test', 'a') . "\n";
var_dump($ssdb->zdel('test', 'a'));
var_dump($ssdb->zdel('test', 'a'));
var_dump($ssdb->zget('test', 'a'));
echo "\n";

$ssdb->close();
