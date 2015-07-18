<?php

namespace App\Http\Controllers\User;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use Input,DB,Redirect,Auth;
use App\PrivateLink;
use App\PrivateGroup;

class IndexController extends Controller
{
    private function newFilterPrivateLinks($keyword){
        if(!isset($keyword) || $keyword==''){
            return PrivateLink::whereRaw('1=1');
        }

        return PrivateLink::where('name','like','%'.$keyword.'%')
            ->orWhere('url','like','%'.$keyword.'%')
            ->orWhere('tags','like','%'.$keyword.'%')
            ;
    }
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {
        $take_count = 10;
        $keyword = Input::get('keyword');

        $table_filter_links = $this->newFilterPrivateLinks($keyword);
        $links_count = $table_filter_links->count();
        $links = $table_filter_links->simplePaginate(40);

        $links_by_click_count = $this->newFilterPrivateLinks($keyword)
            ->orderBy('click_count','desc')
            ->take($take_count)
            ->get();
        $links_by_last_click_time = $this->newFilterPrivateLinks($keyword)
            ->orderBy('last_click_time','desc')
            ->take($take_count)
            ->get();
        $links_by_created_at = $this->newFilterPrivateLinks($keyword)
            ->orderBy('created_at','desc')
            ->take($take_count)
            ->get();
        $links_not_offen_click = $this->newFilterPrivateLinks($keyword)
            ->orderBy('last_click_time','asc')
            ->take($take_count)
            ->get();

        $groups = PrivateGroup::where('hide',0)
            ->orderBy('order','desc')
            ->get();

        $page = Input::get('page');
        if(!isset($page)) $page = 1;

        return view('user.index')
            ->with('groups',$groups)
            ->with('links_count',$links_count)
            ->with('keyword',$keyword)
            ->with('links_by_click_count',$links_by_click_count)
            ->with('links_by_last_click_time',$links_by_last_click_time)
            ->with('links_by_created_at',$links_by_created_at)
            ->with('links_not_offen_click',$links_not_offen_click)
            ->with('keyword',$keyword)
            ->with('links',$links)
            ->with('links_column1',$links->slice(0,10))
            ->with('links_column2',$links->slice(10,10))
            ->with('links_column3',$links->slice(20,10))
            ->with('links_column4',$links->slice(30,10))
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
