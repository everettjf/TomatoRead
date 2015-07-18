<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PrivateGroup extends Model
{
    public function links(){
        return $this->hasMany('App\PrivateLink');
    }

    public function linksKeyword($keyword){
        $data = null;
        if(!isset($keyword) || $keyword == ''){
            $data = $this->hasMany('App\PrivateLink');
        }else {
            $data = $this->hasMany('App\PrivateLink')
                ->where(function ($query) use ($keyword) {
                    $query->where('name', 'like', '%' . $keyword . '%')
                        ->orWhere('url', 'like', '%' . $keyword . '%')
                        ->orWhere('tags', 'like', '%' . $keyword . '%')
                    ;
                });
        }
        return $data
            ->orderBy('click_count', 'desc')
            ->orderBy('last_click_time', 'desc')
            ->get();
    }
}
