<?php
/**
 * Created by PhpStorm.
 * User: everettjf
 * Date: 15/7/31
 * Time: 15:08
 */

use \Illuminate\Support\Facades\Auth;

class LinkSSDB{

    public static function ssdbConn()
    {
        $ssdb = new \SSDB\Client('127.0.0.1',8888);
        return $ssdb;
    }
    public static function linkSetName()
    {
        $setName = 'link.user:'.Auth::user()->id;
        return $setName;
    }
    public static function linkClickSetName($linkid)
    {
        $setName = 'link.user:'.Auth::user()->id.':click:'.$linkid;
        return $setName;
    }

    public static function linkFavoriteSetName()
    {
        $setName = 'link.user::'.Auth::user()->id.':favo';
        return $setName;
    }
    public static function linkGreetSetName()
    {
        $setName = 'link.user::'.Auth::user()->id.':greet';
        return $setName;
    }
    public static function linkDisgreetSetName()
    {
        $setName = 'link.user::'.Auth::user()->id.':disgreet';
        return $setName;
    }
}
