@extends('_layouts.app')


@section('content')
    <div class="ui main container">
        <div class="ui segments">
            <div class="ui segment">
                <div class="ui header">
                    <center>一不小心遇到：</center>
                </div>
            </div>

            <div class="ui green segment">
                <div class="ui header">
                    <center><a href="{{$lucky_url}}" target="_blank">{{$lucky_name}}</a> </center>
                    </div>
            </div>
        </div>
    </div>

@endsection