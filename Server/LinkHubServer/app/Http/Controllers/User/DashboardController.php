<?php

namespace App\Http\Controllers\User;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use DB,Input,Auth,Redirect;
use App\PrivateGroup;


class DashboardController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {
        $count_all = DB::table('private_links')->count();
        $count_in_queue = DB::table('private_links')->where('confirmed',0)->count();
        $links_in_queue = DB::table('private_links')->where('confirmed',0)->take(5)->orderBy('id','asc')->get();
        $groups = PrivateGroup::all();

        $link_first = null;
        if($count_in_queue > 0){
            $link_first = $links_in_queue[0];
        }

        return view('user.dashboard.index')
            ->with('count_all',$count_all)
            ->with('count_in_queue',$count_in_queue)
            ->with('links_in_queue',$links_in_queue)
            ->with('groups',$groups)
            ->with('link_first',$link_first)
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
