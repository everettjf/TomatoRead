<?php

namespace App;

use Illuminate\Auth\Authenticatable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Auth\Passwords\CanResetPassword;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Contracts\Auth\CanResetPassword as CanResetPasswordContract;

class User extends Model implements AuthenticatableContract, CanResetPasswordContract
{
    use Authenticatable, CanResetPassword;

    /**
     * The database table used by the model.
     *
     * @var string
     */
    protected $table = 'users';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = ['email', 'password','type'];

    /**
     * The attributes excluded from the model's JSON form.
     *
     * @var array
     */
    protected $hidden = ['password', 'remember_token'];


    public function privateLinks(){
        return $this->hasMany('App\PrivateLink');
    }
    public function privateTopics(){
        return $this->hasMany('App\PrivateTopic');
    }

    public function links(){
        return $this->hasMany('App\Link');
    }
    public function typeString(){
        if($this->type == 0) return '普通用户';
        else if($this->type == 2) return '可信用户';
        else if($this->type == 9) return '管理员';
        else return 'ERROR';
    }
}
