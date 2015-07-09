<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateLinksTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('links', function (Blueprint $table) {
            $table->increments('id');
            $table->timestamps();

            $table->tinyInteger('type');                // 0链接，1公众号，2书籍，3生活
            $table->integer('topic_id');                // 所属主题，一个链接有且只属于一个主题。

            $table->string('name');                     // 标题
            $table->string('url');                      // 地址
            $table->string('mark')->nullable();         // 简介
            $table->string('image')->nullable();        // 图标、二维码、书面、图片
            $table->string('tags')->nullable();         // 标签（逗号分隔）

            $table->integer('greet')->default(0);       // 点赞数
            $table->integer('disgreet')->default(0);    // 反对数

            $table->tinyInteger('state')->default(0);   // 状态：0未审核，1审核

            $table->integer('share_user_id');           // 首次分享的用户ID
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('links');
    }
}
