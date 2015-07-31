<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\Link;
use App\PrivateLink;
use Auth,Input,Redirect,Log;
use App\Tipoff;

class LinkController extends Controller
{
    public function favorite($id)
    {
        $link = Link::find($id);

        $ssdb = \LinkSSDB::ssdbConn();
        $setName = \LinkSSDB::linkSetName();
        $urlhash = md5($link->url);

        $setFavoName = \LinkSSDB::linkFavoriteSetName();
        if($ssdb->hexists($setFavoName,$urlhash)->data){
            return response()->json(['result'=>'error','msg'=>'已收藏']);
        }

        Link::increment('favo');
        $ssdb->hset($setFavoName,$urlhash,$link->id);

        if($ssdb->hexists($setName,$urlhash)->data){
            return response()->json(['result'=>'error','msg'=>'已拥有']);
        }
        PrivateLink::create([
            'user_id'=>Auth::user()->id,
            'type'=>$link->type,
            'name'=>$link->name,
            'url'=>$link->url,
            'tags'=>$link->tags,
        ]);

        return response()->json(['result'=>'ok']);
    }
    public function greet($id)
    {
        $link = Link::find($id);
        $ssdb = \LinkSSDB::ssdbConn();
        $urlhash = md5($link->url);
        $setGreetName = \LinkSSDB::linkGreetSetName();
        if($ssdb->hexists($setGreetName,$urlhash)->data){
            return response()->json(['result'=>'error','msg'=>'已点赞']);
        }
        Link::increment('greet');
        $ssdb->hset($setGreetName,$urlhash,$link->id);
        return response()->json(['result'=>'ok']);
    }
    public function disgreet($id)
    {
        $link = Link::find($id);
        $ssdb = \LinkSSDB::ssdbConn();
        $urlhash = md5($link->url);
        $setDisgreetName = \LinkSSDB::linkDisgreetSetName();
        if($ssdb->hexists($setDisgreetName,$urlhash)->data){
            return response()->json(['result'=>'error','msg'=>'已点赞']);
        }
        Link::increment('disgreet');
        $ssdb->hset($setDisgreetName,$urlhash,$link->id);
        return response()->json(['result'=>'ok']);
    }
    public function getTipoff($id)
    {
        $link = Link::find($id);
        return view('tipoff')->with('link',$link);
    }
    public function postTipoff($id)
    {
        Tipoff::create([
            'link_id'=>$id,
            'reason'=>Input::get('reason'),
            'user_id'=>Auth::user()->id,
        ]);

        return view('info')->with('info','已举报，我们会尽快审查这条链接。');
    }
}
