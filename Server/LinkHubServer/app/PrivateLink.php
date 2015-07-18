<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PrivateLink extends Model
{
    public function typeString(){
        switch($this->type){
            case 0: return '链接';
            case 1: return '公众号';
            case 2: return '书籍';
            case 3: return '生活';
            default: return '?';
        }
    }
}
