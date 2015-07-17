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
        @foreach($groups as $group)
        <div class="column">
            <table class="ui pink table">
                <tbody>
                <tr>
                    <td>
                        <h5 class="ui header">{{$group->name}}</h5>
                        <p>
                            <div class="ui list">
                            @foreach($group->links as $link)
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
                    <a class="item">第 {{$page}} 页</a>
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

    <div class="linkeditmodal ui modal">
        <i class="close icon"></i>
        <div class="header">
            编辑链接
        </div>
        <div class="content">
            edit
        </div>
        <div class="actions">
            <div class="ui black deny button">
                取消
            </div>
            <div class="ui positive right labeled icon button">
                确定
                <i class="checkmark icon"></i>
            </div>
        </div>
    </div>

    <div class="linksharemodal ui modal">
        <i class="close icon"></i>
        <div class="header">
            分享
        </div>
        <div class="content">
            share
        </div>
        <div class="actions">
            <div class="ui black deny button">
                取消
            </div>
            <div class="ui positive right labeled icon button">
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

            $.post('{{url('api/click')}}' + '/' + linkId,
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
            $('.linkeditmodal.ui.modal')
                    .modal('show')
            ;
        })
        $('.linkshare').click(function(){
            $('.linksharemodal.ui.modal')
                    .modal('show')
            ;
        })


    </script>
@endsection