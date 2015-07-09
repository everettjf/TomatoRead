<?php

namespace App\Http\Controllers\User;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\PrivateGroup;
use Input,DB,Redirect,Auth;

class GroupController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {
        $groups = DB::table('private_groups')
            ->orderBy('order','desc')
            ->orderBy('created_at','desc')
            ->get();
        return view('user.group.index')->with('groups',$groups);
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
    public function store(Request $request)
    {
        $this->validate($request,[
            'name'=>'required|max:20',
        ]);

        $group = new PrivateGroup();
        $group->name = Input::get('name');
        $group->user_id = Auth::user()->id;

        if(!$group->save()){
            return Redirect::back()->withInput()->withErrors('保存出错。');
        }
        return Redirect::back();    }

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
            'name'=>'required|max:20'
        ]);

        $group = PrivateGroup::find($id);
        $group->name = Input::get('name');
        if(!$group->save()){
            return Redirect::back()->withErrors('修改出错。');
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
        $group = PrivateGroup::find($id);
        $group->delete();
        return Redirect::back();
    }

    public function orderInc($id)
    {
        DB::table('private_groups')->where('id',$id)->increment('order',1);
        return Redirect::back();
    }
    public function orderDec($id)
    {
        DB::table('private_groups')->where('id',$id)->decrement('order',1);
        return Redirect::back();
    }
}
