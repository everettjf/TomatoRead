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
            <form class="ui large form" method="post" action="{{ url('/auth/login') }}">
                {!! csrf_field() !!}

                <div class="ui stacked segment">
                    <div class="field">
                        <div class="ui left icon input">
                            <i class="user icon"></i>
                            <input type="email" name="email" placeholder="Email地址" value="{{old('email')}}">
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui left icon input">
                            <i class="lock icon"></i>
                            <input type="password" name="password" placeholder="密码">
                        </div>
                    </div>

                    <div class="field">

                    <div class="ui slider checkbox">
                        <input type="checkbox" name="remember">
                        <label>记住我</label>
                    </div>
                    </div>

                    <button type="submit" class="ui fluid button green">登录</button>
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

            <div class="ui message">
                没有账号？ <a href="{{ url('auth/register') }}">注册</a> &nbsp;&nbsp;
                <a class="btn btn-link" href="{{ url('/password/email') }}">忘记密码？</a>
            </div>
        </div>
    </div>
@endsection

@section('endofbody')

    @endsection