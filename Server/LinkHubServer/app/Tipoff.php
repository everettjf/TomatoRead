<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Tipoff extends Model
{
    public function link(){
        return $this->belongsTo('App\Link');
    }
    public function user(){
        return $this->belongsTo('App\User');
    }
}
