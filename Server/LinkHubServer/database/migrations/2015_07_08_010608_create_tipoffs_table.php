<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTipoffsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('tipoffs', function (Blueprint $table) {
            $table->increments('id');
            $table->timestamps();

            $table->integer('link_id'); // 链接ID
            $table->text('reason')->nullable();   // 举报原因
            $table->integer('user_id'); // 用户ID
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('tipoffs');
    }
}
