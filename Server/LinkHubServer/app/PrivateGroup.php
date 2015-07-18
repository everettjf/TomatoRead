<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PrivateGroup extends Model
{
    public function links(){
        return $this->hasMany('App\PrivateLink');
    }

    public function linksKeyword($keyword){
        if(!isset($keyword) || $keyword == ''){
            return $this->hasMany('App\PrivateLink')->get();
        }
        return $this->hasMany('App\PrivateLink')
            ->where(function($query) use($keyword){
                $query->where('name','like','%'.$keyword.'%')
                ->orWhere('url','like','%'.$keyword.'%')
                ->orWhere('tags','like','%'.$keyword.'%')
                    ;
            })->get();
    }
}
