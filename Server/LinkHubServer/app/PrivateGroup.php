<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PrivateGroup extends Model
{
    public function links(){
        return $this->hasMany('App\PrivateLink')
            ;
    }
}
