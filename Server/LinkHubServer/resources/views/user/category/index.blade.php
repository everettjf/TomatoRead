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

    <form method="post" action="{{ url('home/category') }}">
    <div class="ui fluid action input">
        {!! csrf_field() !!}
        <input type="text" name="name" placeholder="要添加的类别名称">
        <button type="submit" class="ui button">添加</button>
    </div>
    </form>


    <table class="ui green table">
        <thead>
        <tr><th>名称</th>
            <th>排序</th>
            <th>-</th>
        </tr>
        </thead>

        <tbody>
        @foreach($categories as $cate)
        <tr>
            <td>{{$cate->name}}</td>
            <td>{{$cate->order}}
                <button class="ui primary button">+</button>
                @if($cate->order > 0)
                <button class="ui primary button">-</button>
                    @endif
            </td>
            <td>
                <button class="ui primary button">修改</button>
                <button class="ui danger button">删除</button>
            </td>
        </tr>
        @endforeach
        </tbody>
    </table>


@endsection