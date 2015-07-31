@extends('_layouts.user')

@section('subcontent')
    <table class="ui table">
        <thead>
        <th>#</th>
        <th>时间</th>
        <th>链接</th>
        </thead>
        <tbody>
        @foreach($shares as $share)
            <tr>
                <td>{{$share->id}}</td>
                <td>{{$share->created_at}}</td>
                <td><a href="{{$share->privateLink->url}}" target="_blank">{{$share->privateLink->name}}</a></td>
            </tr>
        @endforeach
        </tbody>

        <tfoot>
        <tr><th colspan="3">
                <div class="ui right floated pagination menu">
                    <a class="item">共计 {{$share_count}} </a>
                    <a class="item">第 {{$page}} 页 / 共 {{intval($share_count / 40 + 1)}} 页</a>
                    <a class="icon item" href="{{url('home/share').'/?page='.($page - 1 < 1 ? 1 : ($page - 1)) }}">
                        <i class="left chevron icon"></i>
                    </a>
                    <a class="icon item" href="{{url('home/share').'/?page='.($page + 1)}}">
                        <i class="right chevron icon"></i>
                    </a>
                </div>
            </th>
        </tr></tfoot>
    </table>
@endsection