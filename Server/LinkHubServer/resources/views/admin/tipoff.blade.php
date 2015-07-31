@extends('_layouts.user')

@section('subcontent')
    <table class="ui table">
        <thead>
        <th>#</th>
        <th>链接</th>
        <th>原因</th>
        <th>举报人</th>
        <th>举报时间</th>
        </thead>
        <tbody>
        @foreach($tipoffs as $tip)
            <tr>
                <td>{{$tip->id}}</td>
                <td><a href="{{$tip->link->url}}" target="_blank">{{str_limit($tip->link->name,30)}}</a></td>
                <td>{{$tip->reason}}</td>
                <td>{{$tip->user->email}}</td>
                <td>{{$tip->created_at}}</td>
            </tr>
        @endforeach
        </tbody>

        <tfoot>
        <tr><th colspan="7">
                <div class="ui right floated pagination menu">
                    <a class="item">共计 {{$tip_count}} 信息</a>
                    <a class="item">第 {{$page}} 页 / 共 {{intval($tip_count / 40 + 1)}} 页</a>
                    <a class="icon item" href="{{url('home/inkmind/tipoff').'/?page='.($page - 1 < 1 ? 1 : ($page - 1)) }}">
                        <i class="left chevron icon"></i>
                    </a>
                    <a class="icon item" href="{{url('home/inkmind/tipoff').'/?page='.($page + 1)}}">
                        <i class="right chevron icon"></i>
                    </a>
                </div>
            </th>
        </tr></tfoot>
    </table>
@endsection