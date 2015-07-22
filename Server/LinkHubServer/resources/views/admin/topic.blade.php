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

    <div class="ui green segment">
        <p>
            <div class="ui action input">
                <form method="post" action="{{url('home/inkmind/category')}}">
                    {!! csrf_field() !!}
                    <input type="text" name="name" placeholder="分类名称">
                    <button type="submit" class="ui green button">添加分类</button>
                </form>
            </div>
        </p>
        <p>
            @foreach($categories as $cate)
            <span>
                <a>{{$cate->name}}</a>
                <i class="remove icon"></i>
                <i class="edit icon"></i>
                |
            </span>
            @endforeach
        </p>
    </div>

    <div class="ui pink segment">
        <div class="ui action input">
        <form method="post" action="{{url('home/inkmind/topic')}}">
            {!! csrf_field() !!}
            <select class="ui dropdown" name="category">
                <option value="0">分类</option>
                @foreach($categories as $cate)
                <option value="{{$cate->id}}">{{$cate->name}}</option>
                    @endforeach
            </select>
            <input type="text" placeholder="主题名称" name="name"/>
            <button type="submit" class="ui blue button">添加主题</button>
        </form>
            </div>

        <table class="ui table">
            <thead>
            <th>#</th>
            <th>分类</th>
            <th width="60%">主题</th>
            <th>链接数</th>
            <th>-</th>
            </thead>
            <tbody>
            @foreach($topics as $topic)
            <tr>
                <td>{{$topic->id}}</td>
                <td>
                    @if(isset($topic->category->name))
                    {{$topic->category->name}}
                        @else
                        -
                    @endif
                </td>
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