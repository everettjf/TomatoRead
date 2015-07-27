<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->increments('id');
            $table->timestamps();

            $table->string('email')->unique();
            $table->string('password', 60);
            $table->rememberToken();

            $table->string('name')->unique()->nullable();       // 昵称
            $table->tinyInteger('sex')->default(0);             // 性别：0未设置，1男，2女
            $table->text('mark')->nullable();                   // 简介
            $table->string('image')->nullable();                // 头像

            $table->integer('score')->default(0);               // 积分（分享得积分）

            $table->string('wechat_bind')->nullable();
            $table->string('weibo_bind')->nullable();
            $table->string('qq_bind')->nullable();

            $table->tinyInteger('admin')->default(0);           // 0普通用户，1管理员
            $table->tinyInteger('email_verified')->default(0);  // email是否验证
            $table->string('invite_code')->nullable();           // 邀请码
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('users');
    }
}
