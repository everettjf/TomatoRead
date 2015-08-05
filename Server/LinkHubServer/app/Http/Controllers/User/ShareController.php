<?php

namespace App\Http\Controllers\User;

use App\PrivateShareLog;
use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use Input,Redirect,Log;
use Auth;

class ShareController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {
        $shares = PrivateShareLog::where('user_id',Auth::user()->id)
            ->orderBy('created_at','desc')
            ->simplePaginate(20);
        $share_count = PrivateShareLog::count();

        $page = Input::get('page');
        if(!isset($page)) $page = 1;

        return view('user.share')
            ->with('shares',$shares)
            ->with('share_count',$share_count)
            ->with('page',$page)
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
}
