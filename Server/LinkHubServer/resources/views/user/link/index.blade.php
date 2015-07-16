@extends('_layouts.user')

@section('subcontent')


    <div class="ui info message">
        <p>
            共计 {{$count}} 条链接
        </p>
    </div>

    <form id="filterForm" method="get" action="{{url('home/link')}}">
        <div class="ui fluid icon input">
            <input type="text" placeholder="过滤" name="filterKeyword">
            <i class="circular search link icon" id="filterLink"></i>
        </div>
    </form>


    @if(count($errors) > 0)
        <div class="ui error message">
            <ul class="list">
                @foreach($errors->all() as $err)
                    <li>{{$err}}</li>
                @endforeach
            </ul>
        </div>
    @endif


    <table class="ui pink table">
        <thead>
        <tr><th width="20px">#</th>
            <th width="60px">类型</th>
            <th width="65%">标题/地址/标签</th>
            <th>点击次数/最后点击时间</th>
            <th>-</th>
        </tr></thead><tbody>

        @foreach($links as $link)
        <tr>
            <td>{{$link->id}}</td>
            <td>{{$link->type}}</td>
            <td>
                <div class="ui fluid transparent input">
                    <input type="text" readonly value="{{$link->name}}">
                </div>
                <div class="ui fluid transparent input">
                    <input type="text" readonly value="{{$link->url}}">
                </div>
                <div class="ui fluid transparent input">
                    <input type="text" readonly value="{{$link->tags}}">
                </div>
            </td>
            <td>{{$link->click_count}}<br/>
            {{$link->last_click_time}}
            </td>
            <td>
                <button class="ui red button">删除</button>
            </td>
        </tr>
            @endforeach
        </tbody>
    </table>

    {!! $links->render() !!}

@endsection

@section('endofbody')
    <script>
        $('#filterLink').click(function () {
            $('#filterForm').submit();
        });

    </script>
    @endsection