<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\Link;
use Auth,Input,Redirect,Log;

class IndexController extends Controller
{
    private function newFilterLinks($keyword){
        if(!isset($keyword) || $keyword == ''){
            return Link::whereRaw('1=1');
        }

        return Link::where('name','like','%'.$keyword.'%')
            ->orWhere('url','like','%'.$keyword.'%')
            ->orWhere('tags','like','%'.$keyword.'%')
            ;
    }

    public function index()
    {
        $take_count = 20;
        $keyword = Input::get('keyword');

        $links_top_greet = $this->newFilterLinks($keyword)
            ->orderBy('greet','desc')
            ->take($take_count)
            ->get();

        $links_new_create = $this->newFilterLinks($keyword)
            ->orderBy('created_at','desc')
            ->take($take_count)
            ->get();

        $links_top_favo = $this->newFilterLinks($keyword)
            ->orderBy('favo','desc')
            ->take($take_count)
            ->get();

        $links_filter = $this->newFilterLinks($keyword);
        $links_count = $links_filter->count();
        $links = $links_filter->simplePaginate(40);

        $page = Input::get('page');
        if(!isset($page)) $page = 1;


        return view('index')
            ->with('links_top_greet',$links_top_greet)
            ->with('links_new_create',$links_new_create)
            ->with('links_top_favo',$links_top_favo)
            ->with('links',$links)
            ->with('links_count',$links_count)
            ->with('page',$page)
            ->with('keyword',$keyword)
            ;
    }

    public function linkDetail($id)
    {
        $link = Link::find($id);
        return view('linkdetail')
            ->with('link',$link)
            ;
    }
    public function about()
    {
        return view('about');
    }
    public function help()
    {
        return view('help');
    }

}
