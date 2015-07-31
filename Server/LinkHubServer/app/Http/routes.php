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
Route::get('lucky','LuckyController@index');

Route::get('about','IndexController@about');
Route::get('help','IndexController@help');


Route::group(['prefix'=>'link','middleware'=>'auth'],function() {
    Route::get('{id}','IndexController@linkDetail');

    Route::post('favorite/{id}','LinkController@favorite');
    Route::post('greet/{id}','LinkController@greet');
    Route::post('disgreet/{id}','LinkController@disgreet');

    Route::get('tipoff/{id}','LinkController@getTipoff');
    Route::post('tipoff/{id}','LinkController@postTipOff');
});


// home
Route::group(['prefix'=>'home','middleware'=>'auth'],function(){

    // User
    Route::group(['namespace'=>'User'],function(){
        Route::get('','IndexController@index');
        Route::get('dashboard','DashboardController@index');
        Route::get('organiselink','DashboardController@organiseLink');

        Route::resource('topic','TopicController');
        Route::post('topic/{id}/order/inc','TopicController@orderInc');
        Route::post('topic/{id}/order/dec','TopicController@orderDec');
        Route::post('topic/{id}/hide','TopicController@hideToggle');

        Route::resource('link','LinkController');
        Route::resource('lucky','LuckyController');
        Route::resource('config','ConfigController');
        Route::resource('share','ShareController');
        Route::resource('report','ReportController');

        Route::post('linkshare/{id}','LinkController@share');

    });

    // Admin User
    Route::group(['prefix'=>'inkmind','namespace'=>'Admin'],function(){
        Route::resource('dashboard','DashboardController');

        Route::resource('category','CategoryController');
        Route::resource('link','LinkController');
        Route::get('linkapprove','LinkController@getLinkApprove');
        Route::post('linkapprove/{id}','LinkController@postLinkApprove');
        Route::get('linkrefuse','LinkController@getLinkRefuse');
        Route::post('linkrefuse/{id}','LinkController@postLinkRefuse');

        Route::resource('log','LogController');
        Route::resource('topic','TopicController');
        Route::resource('user','UserController');
        Route::resource('tipoff','TipoffController');
        Route::resource('report','ReportController');
        Route::resource('config','ConfigController');
    });
});


// auth
Route::controllers([
    'auth'=>'Auth\AuthController',
    'password'=>'Auth\PasswordController'
]);

// api
Route::group(['prefix'=>'api','namespace'=>'Api'],function(){
    // user
    Route::post('login','AuthController@login');
    Route::post('logout','AuthController@logout');
    Route::post('userinfo','AuthController@userInfo');

    // private link
    Route::group(['prefix'=>'private'],function(){
        Route::post('savelink','LinkController@saveLink');
        Route::post('savelinkbatch','LinkController@saveLinkBatch');
        Route::post('click/{id}','LinkController@clickLink');
        Route::get('linkinfo/{id}','LinkController@linkInfo');
    });

    // public link
    Route::group(['prefix'=>'public'],function(){
        // is shared


    });
});

// test
Route::group(['prefix'=>'test'],function(){
    Route::get('ssdb',"TestController@ssdb");
});