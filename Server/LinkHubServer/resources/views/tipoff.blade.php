@extends('_layouts.app')

@section('content')
    <div class="ui main container">

        <div class="ui red segment">
            <div class="ui header">
                {{$link->name}}
            </div>
            <ul class="list">
                <li>地址：{{$link->url}}</li>
                <li>标签：{{$link->tags}}</li>
            </ul>
        </div>
        <form class="ui form" method="post" action="{{url('link/tipoff').'/'.$link->id}}">
            {!! csrf_field() !!}
            <div class="field">
                <label>请输入举报原因：</label>
                <textarea rows="3" name="reason"></textarea>
            </div>
            <button type="submit" class="ui red button">确认举报</button>
        </form>
    </div>
@endsection