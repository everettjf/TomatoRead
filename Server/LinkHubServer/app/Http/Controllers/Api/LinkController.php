<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use Auth,DB,Input,Redirect,Log;
use App\PrivateLink;

class LinkController extends Controller
{
    public function saveLink()
    {
        $req = json_decode(Input::getContent());

        $link = new PrivateLink();
        $link->user_id = Auth::user()->id;
        $link->type = 0;
        $link->name = $req->name;
        $link->url = $req->url;
        $link->tags = $req->tags;

        if(! $link->save()){
            return response()->json(['result'=>'error','msg'=>'保存出错']);
        }

        return response()->json(['result'=>'ok']);
    }

    public function saveLinkBatch()
    {
        $req = json_decode(Input::getContent());
        Log::info('save link batch='.Input::getContent());

        $totalCount = count($req);
        $errorCount = 0;
        foreach($req->links as $item){
            $link = new PrivateLink();
            $link->user_id = Auth::user()->id;
            $link->type = 0;
            $link->name = $item->name;
            $link->url = $item->url;
            $link->tags = $item->tags;

            if(! $link->save()) {
                ++$errorCount;
            }
        }
        if($totalCount == $errorCount){
            return response()->json(['result'=>'error','msg'=>'所有项目保存出错']);
        }

        return response()->json(['result'=>'ok']);
    }
}
