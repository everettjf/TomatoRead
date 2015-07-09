<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

Route::get('','IndexController@index');
Route::get('topic','TopicController@index');

Route::group(['prefix'=>'my','namespace'=>'User'],function(){
    Route::resource('','IndexController');
    Route::get('login','IndexController@getLogin');
    Route::get('register','IndexController@getRegister');
});