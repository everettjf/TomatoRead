<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PrivateShareLog extends Model
{
    public function user(){
        return $this->belongsTo('App\User');
    }
    public function privateLink(){
        return $this->belongsTo('App\PrivateLink');
    }
    public function link(){
        return $this->belongsTo('App\Link');
    }
}
