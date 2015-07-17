<?php

spl_autoload_register(function($class){
   require str_replace('SSDB', '../src/', str_replace('\\', '/', $class)) . '.php';
   return true;
});

$host = '127.0.0.1';
$port = 8888;

/* a simple bench mark */
$data = array();
for($i=0; $i<1000; $i++){
    $k = '' . mt_rand(0, 100000);
    $v = mt_rand(100000, 100000 * 10 - 1) . '';
    $data[$k] = $v;
}

speed();
try{
    $ssdb = new SSDB\Client($host, $port);
}catch(Exception $e){
    die(__LINE__ . ' ' . $e->getMessage());
}
foreach($data as $k=>$v){
    $ret = $ssdb->set($k, $v);
    if($ret === false){
        echo "error\n";
        break;
    }
}
$ssdb->close();
speed('set speed: ', count($data));


speed();
try{
    $ssdb = new SSDB\Client($host, $port);
}catch(Exception $e){
    die(__LINE__ . ' ' . $e->getMessage());
}
foreach($data as $k=>$v){
    $ret = $ssdb->get($k);
    if($ret === false){
        echo "error\n";
        break;
    }
}
$ssdb->close();
speed('get speed: ', count($data));



function speed($msg=null, $count=0){
    static $stime;
    if(!$msg && !$count){
        $stime = microtime(1);
    }else{
        $etime = microtime(1);
        $ts = ($etime - $stime == 0)? 1 : $etime - $stime;
        $speed = $count / floatval($ts);
        $speed = sprintf('%.2f', $speed);
        echo "$msg: " . $speed . "\n";

        $stime = $etime;
    }
}
