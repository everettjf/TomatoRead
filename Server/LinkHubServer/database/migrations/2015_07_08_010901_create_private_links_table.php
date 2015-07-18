<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePrivateLinksTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('private_links', function (Blueprint $table) {
            $table->increments('id');
            $table->timestamps();
            $table->integer('user_id');

            $table->tinyInteger('type');                // 0链接，1公众号，2书籍，3生活，4经验（坑）
            $table->string('name');                     // 标题
            $table->text('url');                      // 地址
            $table->text('mark')->nullable();         // 简介
            $table->string('image')->nullable();        // 图标、二维码、书面、图片
            $table->string('tags')->nullable();         // 标签（逗号分隔）

            $table->integer('click_count')->default(0);       // 点击次数
            $table->timestamp('last_click_time'); // 最后点击时间

            $table->integer('private_group_id')->default(0);

            $table->string('bgcolor')->nullable(); // 背景色
            $table->integer('fontsize')->default(0); // 字体大小
            $table->tinyInteger('bold')->default(0); // 加粗
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('private_links');
    }
}
