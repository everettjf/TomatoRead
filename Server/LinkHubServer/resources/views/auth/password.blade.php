@extends('_layouts.app')

@section('endofhead')
    <style type="text/css">
        body > .grid {
            height: 100%;
        }
        .column {
            max-width: 450px;
        }
    </style>
@endsection


@section('content')


    <div class="ui middle aligned center aligned grid">
        <div class="column">
            <form class="ui large form" method="post" action="{{ url('/password/email') }}">
                {!! csrf_field() !!}

                <div class="ui stacked segment">
                    <div class="field">
                        <div class="ui left icon input">
                            <i class="user icon"></i>
                            <input type="email" name="email" placeholder="Email地址">
                        </div>
                    </div>

                    <button type="submit" class="ui fluid button red">发送密码重置链接</button>
                </div>
            </form>
            @if (count($errors) > 0)
                <div class="ui error message">
                    <ul class="list">
                        @foreach($errors->all() as $error)
                            <li>{{$error}}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

        </div>
    </div>
@endsection

@section('endofbody')

@endsection