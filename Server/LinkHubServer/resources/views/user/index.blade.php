@extends('_layouts.app')

@section('content')
    <div class="ui two column centered grid">
        <div class="column">
            <form id="filterForm" method="get" action="{{url('home')}}">
                <div class="ui fluid icon input">
                    <input type="text" name="keyword" placeholder="输入过滤条件" value="{{$keyword}}">
                    <i class="circular search link icon" id="filterLink"></i>
                </div>
            </form>
        </div>
    </div>

    @if(isset($shared_name))
        <div class="ui info segment">
            已分享 {{ $shared_name }}
        </div>
        @endif


    <div class="ui stackable four column grid">
        <div class="column">
            <table class="ui green table">
                <tbody>
                <tr>
                    <td>
                        <h5 class="ui header">点击次数最多</h5>
                        <p>
                            <div class="ui list">
                            @foreach($links_by_click_count as $link)
                                @include('_layouts.userlink')
                            @endforeach
                            </div>
                        </p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="column">
            <table class="ui green table">
                <tbody>
                <tr>
                    <td>
                        <h5 class="ui header">最近点击</h5>
                        <p>
                            <div class="ui list">
                            @foreach($links_by_last_click_time as $link)
                                @include('_layouts.userlink')
                            @endforeach
                            </div>
                        </p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="column">
            <table class="ui green table">
                <tbody>
                <tr>
                    <td>
                        <h5 class="ui header">最近添加</h5>
                        <p>
                            <div class="ui list">
                            @foreach($links_by_created_at as $link)
                                @include('_layouts.userlink')
                            @endforeach
                            </div>
                        </p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="column">
            <table class="ui green table">
                <tbody>
                <tr>
                    <td>
                        <h5 class="ui header">最不经常点击</h5>
                        <p>
                            <div class="ui list">
                            @foreach($links_not_offen_click as $link)
                                @include('_layouts.userlink')
                            @endforeach
                            </div>
                        </p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="ui stackable four column grid">
        @foreach($topics as $topic)
        <div class="column">
            <table class="ui pink table">
                <tbody>
                <tr>
                    <td>
                        <h5 class="ui header">{{$topic->name}}</h5>
                        <p>
                            <div class="ui list">
                            @foreach($topic->linksKeyword($keyword) as $link)
                                @include('_layouts.userlink')
                            @endforeach
                            </div>
                        </p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        @endforeach
    </div>

    <table class="ui yellow table">
        <tbody>
        <tr>
            <td width="25%">
                @foreach($links_column1 as $link)
                    @include('_layouts.userlink')
                @endforeach
            </td>
            <td width="25%">
                @foreach($links_column2 as $link)
                    @include('_layouts.userlink')
                @endforeach
            </td>
            <td width="25%">
                @foreach($links_column3 as $link)
                    @include('_layouts.userlink')
                @endforeach
            </td>
            <td width="25%">
                @foreach($links_column4 as $link)
                    @include('_layouts.userlink')
                @endforeach
            </td>
        </tr>
        </tbody>
        <tfoot>
        <tr><th colspan="4">
                <div class="ui right floated pagination menu">
                    <a class="item">共计 {{$links_count}} 条链接</a>
                    <a class="item">第 {{$page}} 页 / 共 {{intval($links_count / 40 + 1)}} 页</a>
                    <a class="icon item" href="{{url('home').'/?page='.($page - 1 < 1 ? 1 : ($page - 1)).($keyword == '' ? '' : ('&keyword='.$keyword)) }}">
                        <i class="left chevron icon"></i>
                    </a>
                    <a class="icon item" href="{{url('home').'/?page='.($page + 1).($keyword == '' ? '' : ('&keyword='.$keyword))}}">
                        <i class="right chevron icon"></i>
                    </a>
                </div>
            </th>
        </tr></tfoot>
    </table>


    <div class="ui info message">
        <center>
        @if($links_count == 0)
            还没有链接？
        @endif
        <a href="/static/LinkHubChrome.crx" target="_blank">点击这里下载Chrome扩展，通过Chrome扩展收藏链接。</a>
            <br/>
        <a href="http://jingyan.baidu.com/article/e5c39bf56286ae39d6603374.html" target="_blank">点击这里查看安装方法。</a>
        </center>
    </div>

    <div class="linkeditmodal ui modal">
        <i class="close icon"></i>
        <div class="header">
            编辑链接
        </div>
        <div class="content">
            <form id="linkeditform" class="ui form" method="post">
                {!! csrf_field() !!}
                <input type="hidden" name="_method" value="PUT">

                <div class="field">
                    <label>标题（简单）</label>
                    <input type="text" name="name" id="linkname">
                </div>
                <div class="field">
                    <label>地址（建议不修改）</label>
                    <input type="text" name="url" id="linkurl">
                </div>
                <div class="field">
                    <label>标签（空格分隔）</label>
                    <input type="text" name="tags" id="linktags">
                    <div class="ui segment">
                        <p id='commonTags'>
                            常用标签：<a>编程</a> <a>C++</a> <a>PHP</a> <a>微信开发</a> <a>Chrome</a><br/>
                            自动提取：<a>编程</a> <a>C++</a> <a>PHP</a> <a>微信开发</a> <a>Chrome</a>
                        </p>
                    </div>
                </div>
                <div class="field">
                    <label>类型</label>
                    <div class="inline fields">
                        <div class="field">
                            <div class="ui radio checkbox">
                                <input type="radio" name="type" tabindex="0" class="hidden linktype" value="0">
                                <label>链接</label>
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui radio checkbox">
                                <input type="radio" name="type" tabindex="0" class="hidden linktype" value="1">
                                <label>公众号</label>
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui radio checkbox">
                                <input type="radio" name="type" tabindex="0" class="hidden linktype" value="2">
                                <label>书籍</label>
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui radio checkbox">
                                <input type="radio" name="type" tabindex="0" class="hidden linktype" value="3">
                                <label>生活</label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field">
                    <label>主题</label>
                    <div class="inline fields">
                        <div class="field">
                            <div class="ui radio checkbox">
                                <input type="radio" name="topic" tabindex="0" class="hidden linktopic" value="0">
                                <label>无</label>
                            </div>
                        </div>

                        @foreach($topics as $topic)
                            <div class="field">
                                <div class="ui radio checkbox">
                                    <input type="radio" name="topic" tabindex="0" class="hidden linktopic" value="{{$topic->id}}">
                                    <label>{{$topic->name}}</label>
                                </div>
                            </div>
                        @endforeach
                    </div>
                </div>
            </form>
        </div>
        <div class="actions">
            <form method="post" id="deletelinkform">
                {!! csrf_field() !!}
                <input type="hidden" name="_method" value="DELETE"/>
            </form>
            <div class="ui red button" id="deletelinkbutton">
                删除
            </div>
            <div class="ui black deny button">
                取消
            </div>
            <div class="ui positive right labeled icon button" id="submitlinkeditform">
                确定
                <i class="checkmark icon" ></i>
            </div>
        </div>
    </div>

    <div class="linksharemodal ui modal">
        <i class="close icon"></i>
        <div class="header">
            分享
        </div>
        <div class="content">
            <form id="linkshareform" class="ui form" method="post">
                {!! csrf_field() !!}
                <div class="ui fluid transparent input">
                    <input type="text" name="name" id="linksharename">
                </div>
                <div class="ui fluid transparent input">
                    <input type="text" readonly id="linkshareurl">
                </div>
                <div class="ui fluid transparent input">
                    <input type="text" name="tags" id="linksharetags">
                </div>

            </form>
            <p>
                （分享的链接，通过平台审核后就可以在首页看到了。）
            </p>
        </div>
        <div class="actions">
            <div class="ui black deny button">
                取消
            </div>
            <div class="ui positive right labeled icon button" id="linksharebutton">
                分享
                <i class="checkmark icon"></i>
            </div>
        </div>
    </div>

@endsection


@section('endofbody')
    <script>
        $('#filterLink').click(function () {
            $('#filterForm').submit();
        })

        $('.userlink').click(function () {
            var linkId = $(this).attr('link_id');
            console.log('click:'+ linkId);

            $.post('{{url('api/private/click')}}' + '/' + linkId,
                    function(data,status){
                console.log(data);
            });
        })

        $('.linkpoint').mouseenter(function(){
            $(this).find('.linkmore').show();

        })
        $('.linkpoint').mouseleave(function(){
            $(this).find('.linkmore').hide();

        })
        $('.linkedit').click(function(){
            var linkId = $(this).attr('link_id');
            $('#linkeditform').attr('action','{{url('home/link')}}' + '/' + linkId);

            // delete form
            $('#deletelinkform').attr('action','{{url('home/link')}}' + '/' + linkId);

            $.get('/api/private/linkinfo/' + linkId,function(data,status){
                if(data.result == 'ok'){
                    var l = data.data;
                    $('#linkname').val(l.name);
                    $('#linkurl').val(l.url);
                    $('#linktags').val(l.tags);

                    $('.linktype').each(function(index,element){
                        if($(this).val() == l.type){
                            $(this).attr('checked','');
                        }else{
                            $(this).removeAttr('checked');
                        }
                    });
                    $('.linktopic').each(function(index,element){
                        console.log('topic this val = ' + $(this).val() + ' |vs| topic id = ' + l.private_topic_id);
                        if($(this).val() == l.private_topic_id){
                            $(this).attr('checked','');
                        }else{
                            $(this).removeAttr('checked');
                        }
                    });

                    $('.linkeditmodal.ui.modal')
                            .modal('show')
                    ;
                }else{
                    alert('获取链接信息出错了。');
                }
            })
        })
        $('.linkshare').click(function(){
            var linkId = $(this).attr('link_id');
            $('#linkshareform').attr('action','{{url('home/linkshare')}}' + '/' + linkId);
            $.get('/api/private/linkinfo/' + linkId,function(data,status){
                if(data.result == 'ok'){
                    var l = data.data;
                    $('#linksharename').val(l.name);
                    $('#linkshareurl').val(l.url);
                    $('#linksharetags').val(l.tags);

                    $('.linksharemodal.ui.modal')
                            .modal('show')
                    ;
                }else{
                    alert('获取链接信息出错了。');
                }
            })
        })

        $('#submitlinkeditform').click(function () {
            $('#linkeditform').submit();
        })

        $('#deletelinkbutton').click(function(){
            $('#deletelinkform').submit();
        })

        $('#linksharebutton').click(function(){
            $('#linkshareform').submit();
        })


        $(function(){
            $('p#commonTags a').click(function () {
                $('#linktags').val( $('#linktags').val()+ ' ' + $(this).text());
            });
        });


        $('.ui.radio.checkbox')
                .checkbox()
        ;

        $('.linkinfo')
                .popup({
                    setFluidWidth:true
                })
        ;
    </script>
@endsection