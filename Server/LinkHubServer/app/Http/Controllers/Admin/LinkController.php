<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\Link;
use Input,Redirect,Log,Auth;
use App\Topic;

class LinkController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {
        return view('admin.link');
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
    public function update($id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return Response
     */
    public function destroy($id)
    {
        //
    }

    public function getLinkApprove()
    {
        $links_first = Link::where('state',0)->orderBy('created_at','asc')->take(1)->get();
        $link_first = null;
        if(count($links_first) > 0){
            $link_first = $links_first[0];
        }

        $link_count = Link::where('state',0)->count();
        $link_approve_count = Link::where('state',1)->count();
        $link_refuse_count = Link::where('state',2)->count();

        return view('admin.linkapprove')
            ->with('link_first',$link_first)
            ->with('link_count',$link_count)
            ->with('link_approve_count',$link_approve_count)
            ->with('link_refuse_count',$link_refuse_count)
            ;
    }

    public function postLinkApprove($id,Request $request)
    {
        $this->validate($request,[
            'name'=>'required',
        ]);

        $link = Link::find($id);
        $link->name = Input::get('name');
        $link->tags = Input::get('tags');
        $link->state = 1;
        if(!$link->save()){
            return Redirect::back()->withErrors('保存出错');
        }
        return Redirect::back();
    }

    public function getLinkRefuse()
    {

        return view('admin.linkrefuse')
            ;
    }
    public function postLinkRefuse($id)
    {
        $link = Link::find($id);
        $link->state = 2;
        if(!$link->save()){
            return Redirect::back()->withErrors('保存出错');
        }
        return Redirect::back();
    }

    public function getLinkNoTopic()
    {
        $count = Link::where('topic_id',0)->count();
        $links = Link::where('topic_id',0)->take(1)->get();
        $link = null;
        if(count($links) > 0){
            $link = $links[0];
        }
        $topics = Topic::all();

        return view('admin.linknotopic')
            ->with('topics',$topics)
            ->with('count',$count)
            ->with('link',$link)
            ;
    }


    public function postLinkNoTopic($id,Request $request)
    {
        $this->validate($request,[
            'name'=>'required',
        ]);

        $link = Link::find($id);
        $link->name = Input::get('name');
        $link->tags = Input::get('tags');
        $link->state = 1;

        $topic_id = Input::get('topic');
        if($topic_id == 0){
            $topic = new Topic();
            $topic->name = Input::get('topic_name');
            $topic->save();

            $topic_id = $topic->id;
        }

        $link->topic_id = $topic_id;

        if(!$link->save()){
            return Redirect::back()->withErrors('保存出错');
        }
        return Redirect::back();
    }

}
