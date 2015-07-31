<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Topic extends Model
{
    public function links()
    {
        return $this->hasMany('App\Link');
    }
}
