@extends('_layouts.app')
@section('endofhead')

@endsection

@section('content')
    <div class="ui main container">

    @if(! isset($link))
        no such link
    @else
    <div class="ui header">{{$link->name}}</div>

    <div class="ui info message">
        <p>
            <a class="ui red button" href="{{$link->url}}" target="_blank">访问</a>
            <a class="ui yellow button">收藏</a>
            <a class="ui green button">点赞</a>
            <a class="ui gray button">反对</a>
            <a class="ui gray button">举报</a>
        </p>

        <ul class="list">
            <li>
                <i class="empty star icon"></i>{{$link->favo}}
                <i class="thumbs outline up icon"></i>{{$link->greet}}
                <i class="thumbs outline down icon"></i>{{$link->disgreet}}
            </li>
            <li>标签：{{$link->tags}}</li>
            <li>简介：{{$link->mark}}</li>
        </ul>
    </div>

    <!-- 多说评论框 start -->
    <div class="ds-thread" data-thread-key="{{ 'link'.$link->id }}" data-title="{{$link->name}}" data-url="{{url('link').'/'.$link->id}}"></div>
    <!-- 多说评论框 end -->
    <!-- 多说公共JS代码 start (一个网页只需插入一次) -->
    <script type="text/javascript">
        var duoshuoQuery = {short_name:"linkhub"};
        (function() {
            var ds = document.createElement('script');
            ds.type = 'text/javascript';ds.async = true;
            ds.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') + '//static.duoshuo.com/embed.js';
            ds.charset = 'UTF-8';
            (document.getElementsByTagName('head')[0]
            || document.getElementsByTagName('body')[0]).appendChild(ds);
        })();
    </script>
    <!-- 多说公共JS代码 end -->

    @endif

    </div>

@endsection