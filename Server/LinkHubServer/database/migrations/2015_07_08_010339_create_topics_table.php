<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTopicsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('topics', function (Blueprint $table) {
            $table->increments('id');
            $table->timestamps();

            $table->integer('category_id'); // 分类
            $table->string('name');        // 主题名称
            $table->string('mark');         // 简介
            $table->tinyInteger('state')->default(0);   // 状态：0未审核，1审核
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('topics');
    }
}
