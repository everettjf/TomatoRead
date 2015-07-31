@extends('_layouts.user')

@section('subcontent')
    <table class="ui table">
        <thead>
        <th>#</th>
        <th>类型</th>
        <th>Email</th>
        <th>积分</th>
        <th>链接数（分享/私有）</th>
        <th>注册时间</th>
        <th>-</th>
        </thead>
        <tbody>
        @foreach($users as $user)
            <tr>
                <td>{{$user->id}}</td>
                <td>{{$user->typeString()}}</td>
                <td>{{$user->email}}</td>
                <td>{{$user->score}}</td>
                <td>{{$user->links->count()}}/{{$user->privateLinks->count()}}</td>
                <td>{{$user->created_at}}</td>
                <td>
                    <a>指定可信用户</a>
                </td>
            </tr>
        @endforeach
        </tbody>

        <tfoot>
        <tr><th colspan="7">
                <div class="ui right floated pagination menu">
                    <a class="item">共计 {{$user_count}} 用户</a>
                    <a class="item">第 {{$page}} 页 / 共 {{intval($user_count / 40 + 1)}} 页</a>
                    <a class="icon item" href="{{url('home/inkmind/user').'/?page='.($page - 1 < 1 ? 1 : ($page - 1)) }}">
                        <i class="left chevron icon"></i>
                    </a>
                    <a class="icon item" href="{{url('home/inkmind/user').'/?page='.($page + 1)}}">
                        <i class="right chevron icon"></i>
                    </a>
                </div>
            </th>
        </tr></tfoot>
    </table>
@endsection