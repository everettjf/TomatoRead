@extends('_layouts.app')

@section('content')
    <table class="ui green table">
        <thead>
            <th width="150px">统计</th>
            <th>链接</th>
        </thead>
        <tbody>
            <tr>
                <td>点击次数最多</td>
                <td>
                    @for($i = 0; $i < 20; $i++)
                        <a href="#">链接项目</a>
                    @endfor
                </td>
            </tr>

            <tr>
                <td>最近点击</td>
                <td>
                    @for($i = 0; $i < 20; $i++)
                        <a href="#">链接项目</a>
                    @endfor
                </td>
            </tr>


            <tr>
                <td>最不经常点击</td>
                <td>
                    @for($i = 0; $i < 20; $i++)
                        <a href="#">链接项目</a>
                    @endfor
                </td>
            </tr>
        </tbody>
    </table>

    <table class="ui pink table">
        <thead>
            <th width="150px">分组</th>
            <th>链接</th>
        </thead>
        <tbody>
        @foreach($groups as $group)
            <tr>
                <td>
                    <strong>{{$group->name}}</strong>
                </td>
                <td>
                    @for($i = 0; $i < 20; $i++)
                    <a href="#">链接项目</a>
                    @endfor
                </td>
            </tr>
        @endforeach
        </tbody>
    </table>

@endsection