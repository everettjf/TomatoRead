<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use Auth,Input,Redirect,DB,Log;

class AuthController extends Controller
{
    public function login()
    {
        Log::info('api.login='.Input::getContent());
        $req = json_decode(Input::getContent());

        Auth::logout();

        if (! Auth::attempt(['email' => $req->email, 'password' => $req->password], $req->remember)) {
            return response()->json(['result'=>'error','msg'=>'错误的账号或密码']);
        }
        return response()->json(['result'=>'ok']);
    }
    public function logout()
    {
        Auth::logout();
        return response()->json(['result'=>'ok']);
    }

    public function userInfo()
    {
        if(!Auth::check()){
            return response()->json(['result'=>'error','msg'=>'未登录']);
        }
        $user = Auth::user();
        if(! isset($user)){
            return response()->json(['result'=>'error','msg'=>'没有登录']);
        }
        return response()->json([
            'result'=>'ok',
            'email'=>$user->email
        ]);
    }

}
