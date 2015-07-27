<?php

namespace App\Http\Controllers\User;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\PrivateTopic;
use Input,DB,Redirect,Auth;
use Mockery\CountValidator\Exception;

class TopicController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {
        $topics = DB::table('private_topics')
            ->orderBy('order','desc')
            ->orderBy('created_at','desc')
            ->get();
        return view('user.topic')->with('topics',$topics);
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

        try{
            $topic = new PrivateTopic();
            $topic->name = Input::get('name');
            $topic->user_id = Auth::user()->id;

            if(!$topic->save()){
                return Redirect::back()->withInput()->withErrors('保存出错。');
            }
        }catch(Exception $e){
            Log::info($e->getMessage());
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

        $topic = PrivateTopic::find($id);
        $topic->name = Input::get('name');
        if(!$topic->save()){
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
        $topic = PrivateTopic::find($id);
        $topic->delete();
        return Redirect::back();
    }

    public function orderInc($id)
    {
        DB::table('private_topics')->where('id',$id)->increment('order',1);
        return Redirect::back();
    }
    public function orderDec($id)
    {
        DB::table('private_topics')->where('id',$id)->decrement('order',1);
        return Redirect::back();
    }
    public function hideToggle($id)
    {
        $topic = PrivateTopic::find($id);
        if($topic->hide == 0) $topic->hide = 1;
        else $topic->hide = 0;

        $topic->save();
        return Redirect::back();
    }
}
