@extends('_layouts.app')


@section('content')
    <div class="ui grid">
        <div class="two wide column">
            <div class="ui vertical fluid tabular menu">
                <a href="{{ url('home/link') }}" class="item active">链接</a>
                <a href="{{ url('home/group') }}" class="item">分组</a>
                <a href="{{ url('home/setting') }}" class="item">设置</a>
                <a href="#" class="item">分享</a>
                <a href="#" class="item">统计</a>

{{--                @if(Auth::user()->admin == 1)--}}
                <div class="ui divider"></div>
                <a href="#" class="item">审核链接</a>
                <a href="#" class="item">广场链接</a>
                <a href="#" class="item">用户管理</a>
                <a href="#" class="item">主题分类</a>
                <a href="#" class="item">主题管理</a>
                <a href="#" class="item">标签管理</a>
                <a href="#" class="item">系统统计</a>
                <a href="#" class="item">举报管理</a>
                <a href="#" class="item">系统日志</a>
                    {{--@endif--}}
            </div>
        </div>
        <div class="fourteen wide stretched column">
            <div class="ui segment">
                @yield('subcontent')
            </div>
        </div>
    </div>
    @endsection