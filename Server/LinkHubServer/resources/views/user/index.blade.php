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
                            @foreach($links_by_click_count as $link)
                                @include('_layouts.userlink')
                            @endforeach
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
                            @foreach($links_by_last_click_time as $link)
                                @include('_layouts.userlink')
                            @endforeach
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
                            @foreach($links_by_created_at as $link)
                                @include('_layouts.userlink')
                            @endforeach
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
                            @foreach($links_not_offen_click as $link)
                                @include('_layouts.userlink')
                            @endforeach
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
                            @foreach($group->links as $link)
                                @include('_layouts.userlink')
                            @endforeach
                        </p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        @endforeach
    </div>


    <div class="ui yellow segment">
        <h5 class="ui header">共计 {{$links_count}} 条链接</h5>
        <p>
            @foreach($links as $link)
                @include('_layouts.userlink')
            @endforeach
        </p>
    </div>
    {!! $links->render() !!}

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

        $('.userlink').mouseenter(function(){
            $(this).find('.linkmore').show();

        })
        $('.userlink').mouseleave(function(){
            $(this).find('.linkmore').hide();

        })


    </script>
@endsection