@extends('_layouts.app')


@section('content')
    <div class="ui grid">
        <div class="two wide column">
            <div class="ui vertical fluid tabular menu">
                <a href="{{ url('home/dashboard') }}" class="item">概览</a>
                <a href="{{ url('home/topic') }}" class="item">主题</a>
                <a href="{{ url('home/share') }}" class="item">分享</a>

                @if(Auth::user()->type == 9)
                <div class="ui divider"></div>
                <a href="{{ url('home/inkmind/dashboard') }}" class="item">系统概览</a>
                <a href="{{ url('home/inkmind/linkapprove') }}" class="item">审核链接</a>
                <a href="{{ url('home/inkmind/topic') }}" class="item">主题管理</a>
                <a href="{{ url('home/inkmind/user') }}" class="item">用户管理</a>
                <a href="{{ url('home/inkmind/tipoff') }}" class="item">举报管理</a>
                    @endif

                <div class="ui divider"></div>

                <a href="{{ url('auth/logout') }}" class="item">退出</a>

            </div>
        </div>
        <div class="fourteen wide stretched column">
            <div class="ui segment">
                @yield('subcontent')
            </div>
        </div>
    </div>
    @endsection