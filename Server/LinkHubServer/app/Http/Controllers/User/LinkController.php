<?php

namespace App\Http\Controllers\User;

use App\Link;
use App\PrivateTopic;
use App\PrivateShareLog;
use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\PrivateLink;
use App\User;
use DB,Input,Auth,Redirect;

class LinkController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {

    }

    /**
     * Show the form for creating a new resource.
     *
     * @return Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @return Response
     */
    public function store()
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return Response
     */
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  int  $id
     * @return Response
     */
    public function update($id,Request $request)
    {
        $this->validate($request,[
                'name'=>'required',
                'url'=>'required',
                'type'=>'required',
                'topic'=>'required'
            ]
        );

        $tagArray = array_unique(explode(' ',trim(Input::get('tags'))));

        $link = PrivateLink::find($id);
        $link->name = Input::get('name');
        $link->url = Input::get('url');
        $link->tags = implode(' ',$tagArray);
        $link->type = Input::get('type');
        $link->private_topic_id = Input::get('topic');

        if(!$link->save()){
            return Redirect::back()->withErrors('保存出错。');
        }

        return Redirect::back();
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return Response
     */
    public function destroy($id)
    {
        $link = PrivateLink::find($id);
        if(isset($link)){
            $link->delete();
        }
        return Redirect::back();
    }

    public function share($id,Request $request){
        $this->validate($request,[
            'name'=>'required'
        ]);

        $private_link = PrivateLink::find($id);

        $ssdb = \LinkSSDB::ssdbConn();
        $setName = \LinkSSDB::linkPublicSetName();
        if($ssdb->hexists($setName,md5($private_link->url))->data){
            // share already
            return Redirect::back();
        }

        $public_link = new Link();
        $public_link->name = Input::get('name');
        $public_link->url = $private_link->url;
        $public_link->tags = Input::get('tags');
        $public_link->user_id = Auth::user()->id;
        $public_link->mark = Input::get('mark');

        if(Auth::user()->type == 1 || Auth::user()->type == 9){
            $public_link->state = 1;
        }

        if(! $public_link->save()){
            return Redirect::back()->withErrors('分享出错');
        }
        $ssdb->hset($setName,md5($private_link->url));

        $private_link->shared = 1;
        $public_link->save();

        $share_log = new PrivateShareLog();
        $share_log->user_id = Auth::user()->id;
        $share_log->private_link_id = $private_link->id;
        $share_log->public_link_id = $public_link->id;
        $share_log->save();

        User::where('id',Auth::user()->id)->increment('score',10);

        return Redirect::back()->with('shared_name',$public_link->name);
    }

    public function isShared(Request $request){
        $req = json_decode(Input::getContent());

        $ssdb = \LinkSSDB::ssdbConn();
        $setName = \LinkSSDB::linkPrivateSetName();
        if($ssdb->hexists($setName,md5($req->url))->data){
            Log::info('link existed:'.$req->url.' - '.$setName.' # ');
            return response()->json(['result'=>'ok','msg'=>'已存在']);
        }
        return response()->json(['result'=>'error','msg'=>'不存在']);
    }
}
