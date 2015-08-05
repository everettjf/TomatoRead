<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\PrivateTopic;

class TopicController extends Controller
{
    public function getTopics(){
        $topics = PrivateTopic::where('user_id',Auth::user()->id)->get();

        return response()->json([
            'topics'=>$topics,
        ]);
    }
}
