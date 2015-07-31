@extends('_layouts.user')

@section('subcontent')

    @if(count($errors) > 0)
        <div class="ui error message">
            <ul class="list">
                @foreach($errors->all() as $error)
                    <li>{{$error}}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <div class="ui pink segment">
        <form method="post" action="{{url('home/inkmind/topic')}}">
            {!! csrf_field() !!}
            <div class="ui fluid action input">
                <input type="text" placeholder="主题名称" name="name"/>
                <button type="submit" class="ui blue button">添加主题</button>
            </div>
        </form>

        <table class="ui table">
            <thead>
            <th>#</th>
            <th width="60%">主题</th>
            <th>链接数</th>
            <th>-</th>
            </thead>
            <tbody>
            @foreach($topics as $topic)
            <tr>
                <td>{{$topic->id}}</td>
                <td>{{$topic->name}}</td>
                <td>{{$topic->links->count()}}</td>
                <td>
                    <i class="remove icon"></i>
                    <i class="edit icon"></i>
                </td>
            </tr>
                @endforeach
            </tbody>

            <tfoot>
            <tr><th colspan="5">
                    <div class="ui right floated pagination menu">
                        <a class="item">共计 {{$topic_count}} 条主题</a>
                        <a class="item">第 {{$page}} 页 / 共 {{intval($topic_count / 40 + 1)}} 页</a>
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
    </div>

@endsection