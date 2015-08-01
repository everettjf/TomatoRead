<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">

    <meta name="description" content="linkhub">
    <meta name="author" content="everettjf">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>LinkHub - 我最喜爱的收藏管理工具</title>
    <link rel="icon" href="/static/img/favicon.ico">
    <link href="/static/css/app.css" rel="stylesheet">
    <link href="/static/components/semantic/dist/semantic.min.css" rel="stylesheet">

    @yield('endofhead')

</head>
<body>

<div class="ui top attached tabular menu">
    <div class="item">
        <img src="/static/img/favicon.ico">LinkHub 链接宝库
    </div>
    <a href="{{url('')}}" class="item @if(isset($active) && $active=='') active @endif">广场</a>
    <a href="{{url('topic')}}" class="item @if(isset($active) && $active=='topic') active @endif">主题</a>
    <a href="{{url('lucky')}}" class="item @if(isset($active) && $active=='lucky') active @endif">运气</a>
    <a href="{{url('about')}}" class="item @if(isset($active) && $active=='about') active @endif">留言/帮助</a>
    <a href="https://github.com/everettjf/LinkHub" target="_blank" class="item">GitHub</a>

    <div class="right menu">
        <a href="{{url('home')}}" class="item @if(isset($active) && $active=='home') active @endif">我的链接</a>
        @if(Auth::guest())
            <a href="{{url('auth/register')}}" class="item">注册</a>
        @else
            <a href="{{url('home/dashboard')}}" class="item">个人中心</a>
        @endif
    </div>
</div>
<div class="ui bottom attached segment">

@yield('content')

    <div class="ui vertical footer segment">
        <div class="ui center aligned container">
            <div class="ui horizontal small divided link list">
                <a class="item" href="http://inkmind.xyz" target="_blank">联系我</a>
                <a href="https://github.com/everettjf/LinkHub" target="_blank" class="item">GitHub</a>
            </div>
        </div>
    </div>
</div>


<script src="/static/components/jquery/dist/jquery.min.js"></script>
<script src="/static/components/semantic/dist/semantic.min.js"></script>
<script src="/static/js/app.js"></script>

@yield('endofbody')


</body>

</html>
