@extends('_layouts.user')

@section('subcontent')

    <div class="ui info message">
        <p>
            N条私有链接，分享N条链接。积分：99999 分。称号：分享小兵。
        </p>
    </div>
    <h5>快速整理</h5>

    @if(count($errors) > 0)
        <div class="ui error message">
            <ul class="list">
                @foreach($errors->all() as $err)
                    <li>{{$err}}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <div class="ui info message">
        <p>
        快速整理表单，以及下一条。自动全部整理。
        </p>
        <p>
            还有{{$count}} 条链接等待您的整理（设置类型，添加标签，修改标题，分组，或删除）。点点滴滴整理，积累自己的宝库。<br/>
            建议标题 20 字以内，标签 3 个为宜。
        </p>
    </div>

    <h5>队列</h5>
    <table class="ui pink table">
        <thead>
        <tr><th>#</th>
            <th>类型</th>
            <th>标题</th>
            <th>地址</th>
            <th>标签</th>
            <th>操作</th>
        </tr></thead><tbody>

        @foreach($links as $link)
            <tr>
                <td>{{$link->id}}</td>
                <td>{{$link->type}}</td>
                <td>
                    <div class="ui input">
                        <input type="text" readonly value="{{$link->name}}">
                    </div>
                </td>
                <td>
                    <div class="ui input">
                        <input type='text' readonly value='{{$link->url}}'/>
                    </div>
                </td>
                <td>
                    <div class="ui input">
                        <input type='text' readonly value='{{$link->tags}}'/>
                    </div>
                </td>
                <td>
                    <button class="ui red button">删除</button>
                </td>
            </tr>
        @endforeach
        </tbody>
    </table>

    {!! $links->render() !!}

@endsection