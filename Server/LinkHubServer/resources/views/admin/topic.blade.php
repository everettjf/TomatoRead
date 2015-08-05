@extends('_layouts.user')
@section('endofbody')

    <script language="javascript">
        function confirmDelete(){
            if(!confirm('确认删除吗？')){
                return false;
            }
            return true;
        }
        function showModify(id,name){
            var url = '{{ url('home/inkmind/topic') }}';
            $('#modifyForm').attr('action', url + '/' + id);
            $('#modifyName').val(name);
            $('.ui.modal')
                    .modal('show')
            ;
        }
    </script>

    @endsection
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

    <div class="ui modal">
        <div class="header">修改</div>
        <div class="content">
            <form id="modifyForm" method="post" style="display: inline;">
                {!! csrf_field() !!}
                <input name="_method" type="hidden" value="PUT">

                <div class="ui fluid action input">
                    <input id="modifyName" type="text" name="name" placeholder="名称">
                    <button type="submit" class="ui orange button">确认</button>
                </div>
            </form>
        </div>
    </div>


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
                    <button class="mini ui orange button" onclick="showModify({{$topic->id}},'{{$topic->name}}');">修改</button>

                    <form method="post" action="{{ url('home/inkmind/topic/'.$topic->id) }}" style="display: inline;">
                        {!! csrf_field() !!}
                        <input name="_method" type="hidden" value="DELETE">
                        <button type="submit" class="mini ui danger button" onclick="return confirmDelete();">删除</button>
                    </form>
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