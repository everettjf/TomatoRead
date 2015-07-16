<?php

namespace App\Http\Controllers\User;

use App\PrivateGroup;
use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\PrivateLink;
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
        $keyword = Input::get('filterKeyword');

        if(isset($keyword)){
            $obj = DB::table('private_links')
                ->where('name','like','%'.$keyword.'%')
                ->orWhere('url','like','%'.$keyword.'%')
                ->orWhere('tags','like','%'.$keyword.'%')
                ;
            $count = $obj->count();
            $links = $obj->simplePaginate(50)
            ;

        }else{
            $count = DB::table('private_links')->count();
            $links = DB::table('private_links')
                ->simplePaginate(50)
            ;
        }
        return view('user.link.index')
            ->with('count',$count)
            ->with('links',$links)
            ;
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
                'tags'=>'required',
                'type'=>'required',
                'group'=>'required'
            ]
        );

        $tagArray = array_unique(explode(' ',trim(Input::get('tags'))));

        $link = PrivateLink::find($id);
        $link->name = Input::get('name');
        $link->url = Input::get('url');
        $link->tags = implode(' ',$tagArray);
        $link->type = Input::get('type');
        $link->group_id = Input::get('group');

        $link->confirmed = 1;

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
        //
    }
}
