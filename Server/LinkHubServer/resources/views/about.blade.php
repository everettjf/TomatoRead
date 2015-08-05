@extends('_layouts.app')


@section('content')
    <div class="ui main container">

        <div class="ui segments">
            <div class="ui segment">
                <div class="ui header">
                    如何添加链接
                </div>
                只能通过Chrome浏览器扩展添加收藏。可以添加当前活动页面，所有活动的标签页，或批量导入Chrome收藏夹。

            </div>
            <div class="ui red segment">
                <div class="ui header">Chrome扩展</div>
                <a href="/static/LinkHubChrome.crx" target="_blank">点击这里下载Chrome扩展，通过Chrome扩展收藏链接。</a>
                <br/>
                <a href="http://jingyan.baidu.com/article/e5c39bf56286ae39d6603374.html" target="_blank">点击这里查看安装方法。</a>
            </div>
            <div class="ui yellow segment">
                <div class="ui header">分享</div>
                    个人链接可以分享到广场。分享的链接需要管理员审核后，才可以显示在“广场”。
            </div>
            <div class="ui pink segment">
                <div class="ui header">主题</div>
                “主题”是一类链接的集合，目前是由管理员根据广场链接的类型，人为指定的一种类别。
            </div>
            <div class="ui green segment">
                <div class="ui header">运气</div>
                “运气”是随机在“广场”中抽取的一条链接。
            </div>
            <div class="ui blue segment">
                <div class="ui header">开源</div>
                网站是开源的，您可以在这里找到源码。<a href="https://github.com/everettjf/LinkHub" target="_blank">GitHub</a>
            </div>
        </div>



        <!-- 多说评论框 start -->
        <div class="ds-thread" data-thread-key="about" data-title="留言" data-url="{{url('about')}}"></div>
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


    </div>

@endsection