@extends('user._layouts.base')

@section('subcontent')
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
        <tr><th>#</th>
            <th>类型</th>
            <th>标题</th>
            <th>地址</th>
            <th>标签</th>
            <th>点击次数</th>
            <th>最后点击时间</th>
            <th>操作</th>
        </tr></thead><tbody>

        @foreach($links as $link)
        <tr>
            <td>{{$link->id}}</td>
            <td>{{$link->type}}</td>
            <td>{{$link->name}}</td>
            <td><input type='text' value='{{$link->url}}'/></td>
            <td>{{$link->tags}}</td>
            <td>{{$link->click_count}}</td>
            <td>{{$link->last_click_time}}</td>
            <td>
                <button class="ui red button">删除</button>
            </td>
        </tr>
            @endforeach
        </tbody>
    </table>

    {!! $links->render() !!}

@endsection