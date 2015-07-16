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
                                <i class="send outline icon"></i>
                                <a class="userlink" link_id="{{$link->id}}" href="{{$link->url}}" target="_blank">
                                {{$link->name}}
                                </a>
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
                                <i class="send outline icon"></i>
                                <a class="userlink" link_id="{{$link->id}}" href="{{$link->url}}" target="_blank">
                                    {{$link->name}}
                                </a>
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
                                <i class="send outline icon"></i>
                                <a class="userlink" link_id="{{$link->id}}" href="{{$link->url}}" target="_blank">
                                    {{$link->name}}
                                </a>
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
                                <i class="send outline icon"></i>
                                <a class="userlink" link_id="{{$link->id}}" href="{{$link->url}}" target="_blank">
                                    {{$link->name}}
                                </a>
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
                            @for($i = 0; $i < 20; $i++)
                                <i class="send outline icon"></i>
                                <a href="#">链接项目</a>
                            @endfor
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
            <i class="send outline icon"></i>
            <a class="userlink" href="{{$link->url}}" target="_blank">
                {{$link->name}}
            </a>
            @endforeach
        </p>
    </div>
    {!! $links->render() !!}

@endsection


@section('endofbody')
    <script>
        $('#filterLink').click(function () {
            $('#filterForm').submit();
        });

    </script>
@endsection