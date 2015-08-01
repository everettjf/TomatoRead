@extends('_layouts.app')


@section('content')
    <div class="ui segments">
        <div class="ui segment">
            <div class="ui grid">
                @foreach($topics as $topic)
                    <div class="three wide column">
                        <i class="tasks icon"></i>
                        <a href="{{url('topic').'/'.$topic->id}}">{{$topic->name}}</a>
                        ({{$topic->links->count()}})
                    </div>
                @endforeach
            </div>
        </div>
        <div class="ui segment">
            <div class="ui right floated pagination menu">
                <a class="item">共计 {{$topic_count}} 条主题</a>
                <a class="item">第 {{$page}} 页 / 共 {{intval($topic_count / 100 + 1)}} 页</a>
                <a class="icon item" href="{{url('topic').'/?page='.($page - 1 < 1 ? 1 : ($page - 1))}}">
                    <i class="left chevron icon"></i>
                </a>
                <a class="icon item" href="{{url('topic').'/?page='.($page + 1)}}">
                    <i class="right chevron icon"></i>
                </a>
            </div>
        </div>

    </div>

@endsection