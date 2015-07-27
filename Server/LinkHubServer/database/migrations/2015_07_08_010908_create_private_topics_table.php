<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePrivateTopicsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('private_topics', function (Blueprint $table) {
            $table->increments('id');
            $table->timestamps();
            $table->integer('user_id');

            $table->string('name')->unique();
            $table->integer('order')->default(0);
            $table->tinyInteger('hide')->default(0); // 0显示，1隐藏（首页不显示）
            $table->text('mark')->nullable(); // 简介
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('private_topics');
    }
}
