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

Route::group(['prefix'=>'home','namespace'=>'User','middleware'=>'auth'],function(){
    Route::get('','IndexController@index');
    Route::get('dashboard','DashboardController@index');

    Route::resource('group','GroupController');
    Route::post('group/{id}/order/inc','GroupController@orderInc');
    Route::post('group/{id}/order/dec','GroupController@orderDec');
    Route::post('group/{id}/hide','GroupController@hideToggle');

    Route::resource('link','LinkController');


    Route::get('setting','SettingController@index');
});

Route::controllers([
    'auth'=>'Auth\AuthController',
    'password'=>'Auth\PasswordController'
]);

Route::group(['prefix'=>'api','namespace'=>'Api'],function(){
    // user
    Route::post('login','AuthController@login');
    Route::post('logout','AuthController@logout');
    Route::post('userinfo','AuthController@userInfo');

    // link
    Route::group(['prefix'=>'private'],function(){
        Route::post('savelink','LinkController@saveLink');
        Route::post('savelinkbatch','LinkController@saveLinkBatch');
        Route::post('click/{id}','LinkController@clickLink');
        Route::get('linkinfo/{id}','LinkController@linkInfo');
    });

    Route::group(['prefix'=>'public'],function(){

    });
});

Route::group(['prefix'=>'test'],function(){
    Route::get('ssdb',"TestController@ssdb");
});