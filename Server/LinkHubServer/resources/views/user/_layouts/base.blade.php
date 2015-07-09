@extends('_layouts.app')


@section('content')
    <div class="ui grid">
        <div class="two wide column">
            <div class="ui vertical fluid tabular menu">
                <a href="{{ url('home/link') }}" class="item active">链接</a>
                <a href="{{ url('home/category') }}" class="item">分类</a>
                <a href="{{ url('home/group') }}" class="item">分组</a>
                <a href="{{ url('home/setting') }}" class="item">设置</a>
                <a href="#" class="item">分享</a>
                <a href="#" class="item">统计</a>
            </div>
        </div>
        <div class="fourteen wide stretched column">
            <div class="ui segment">
                @yield('subcontent')
            </div>
        </div>
    </div>
    @endsection