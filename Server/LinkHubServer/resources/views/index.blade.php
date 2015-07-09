@extends('_layouts.app')
@section('endofhead')

@endsection

@section('content')
    <div class="ui main text container">
        <div class="ui fluid icon input">
            <input type="text" placeholder="输入想知道的任何内容...">
            <i class="search icon"></i>
        </div>
    </div>
    <div class="ui vertical footer segment">
        <div class="ui center aligned container">

            <div class="ui horizontal small divided link list">
                <a class="item" href="#">联系我们</a>
            </div>
        </div>
    </div>

@endsection