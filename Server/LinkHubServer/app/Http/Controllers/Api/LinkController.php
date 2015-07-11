<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use Auth,DB,Input,Redirect,Log;
use App\PrivateLink;

class LinkController extends Controller
{
    private function ssdbConn()
    {
        $ssdb = new \SSDB\Client('127.0.0.1',8888);
        return $ssdb;
    }
    private function linkSetName()
    {
        $setName = 'link.user:'.Auth::user()->id;
        return $setName;
    }

    public function saveLink()
    {
        $req = json_decode(Input::getContent());
        $ssdb = $this->ssdbConn();
        $setName = $this->linkSetName();
        if($ssdb->hexists($setName,$req->url)->data){
            Log::info('link existed:'.$req->url.' - '.$setName.' # ');
            return response()->json(['result'=>'ok','msg'=>'已存在']);
        }

        $link = new PrivateLink();
        $link->user_id = Auth::user()->id;
        $link->type = 0;
        $link->name = $req->name;
        $link->url = $req->url;
        $link->tags = $req->tags;


        if(! $link->save()){
            return response()->json(['result'=>'error','msg'=>'保存出错']);
        }

        $ssdb->hset($setName,$link->url,$link->id);

        return response()->json(['result'=>'ok']);
    }

    public function saveLinkBatch()
    {
        $req = json_decode(Input::getContent());
        Log::info('save link batch='.Input::getContent());

        $ssdb = $this->ssdbConn();
        $setName = $this->linkSetName();

        $totalCount = count($req);
        $errorCount = 0;
        foreach($req->links as $item){
            if($ssdb->hexists($setName,$item->url)){
                continue;
            }

            $link = new PrivateLink();
            $link->user_id = Auth::user()->id;
            $link->type = 0;
            $link->name = $item->name;
            $link->url = $item->url;
            $link->tags = $item->tags;

            if(! $link->save()) {
                ++$errorCount;
                continue;
            }

            $ssdb->hset($setName,$link->url,$link->id);
        }
        if($totalCount == $errorCount){
            return response()->json(['result'=>'error','msg'=>'所有项目保存出错']);
        }

        return response()->json(['result'=>'ok']);
    }
}
