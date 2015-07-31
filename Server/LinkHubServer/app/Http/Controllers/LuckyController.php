<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\PrivateLucky;
use Input,Redirect,Log;
use App\PrivateLink;
use App\Link;

class LuckyController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {
        $count = Link::count();
        $value = rand(1,$count);
        $link = Link::find($value);

        $lucky_name = '黑洞，可以穿越星球';
        $lucky_url = '';
        if(isset($link)){
            $lucky_name = $link->name;
            $lucky_url = $link->url;
        }

        return view('lucky')
            ->with('lucky_name',$lucky_name)
            ->with('lucky_url',$lucky_url)
            ->with('active','lucky')
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
