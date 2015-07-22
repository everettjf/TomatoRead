<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Topic extends Model
{
    public function category()
    {
        return $this->belongsTo('App\Category');
    }
    public function links()
    {
        return $this->hasMany('App\Link');
    }
}
