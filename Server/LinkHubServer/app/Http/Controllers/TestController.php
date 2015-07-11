<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;

class TestController extends Controller
{
    public function ssdb()
    {
        $ssdb = new \SSDB\Client('127.0.0.1', 8888);

        var_dump($ssdb->set('test', time()));

        echo $ssdb->get('test') . "\n";

        var_dump($ssdb->del('test'));

        var_dump($ssdb->get('test'));
    }
}
