<?php

namespace App\Http\Controllers\User;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\PrivateCategory;
use Input,Redirect;
use DB;

class CategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index()
    {
        $cates = DB::table('private_categories')
            ->orderBy('order','desc')
            ->orderBy('created_at','desc')
            ->get();
        return view('user.category.index')->with('categories',$cates);
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
     * @param Request $request
     * @return Response
     */
    public function store(Request $request)
    {
        $this->validate($request,[
            'name'=>'required|max:20',
        ]);

        $cate = new PrivateCategory();
        $cate->name = Input::get('name');

        if(!$cate->save()){
            return Redirect::back()->withInput()->withErrors('保存出错。');
        }
        return Redirect::back();
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
            'name'=>'required|max:20'
        ]);

        $cate = PrivateCategory::find($id);
        $cate->name = Input::get('name');
        if(!$cate->save()){
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
        $cate = PrivateCategory::find($id);
        $cate->delete();
        return Redirect::back();
    }

    public function orderInc($id)
    {
        DB::table('private_categories')->where('id',$id)->increment('order',1);
        return Redirect::back();
    }
    public function orderDec($id)
    {
        DB::table('private_categories')->where('id',$id)->decrement('order',1);
        return Redirect::back();
    }
}
