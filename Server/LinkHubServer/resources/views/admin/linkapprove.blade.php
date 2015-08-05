@extends('_layouts.user')

@section('endofbody')
    <script>
        $('.ui.radio.checkbox')
                .checkbox()
        ;
    </script>
    @endsection

@section('subcontent')


    <div class="ui info message">
        <p>
            待审核链接 {{ $link_count }} 条，已经审核 {{ $link_approve_count }} 条，已经拒绝 {{$link_refuse_count}} 条。
            &nbsp;&nbsp;
            <a href="{{url('home/inkmind/linkrefuse')}}">查看已拒绝链接</a>
        </p>
    </div>

    @if(count($errors) > 0)
        <div class="ui error message">
            <ul class="list">
                @foreach($errors->all() as $error)
                    <li>{{$error}}</li>
                @endforeach
            </ul>
        </div>
    @endif
    @if(isset($link_first))
    <div class="ui pink segment">
        <form class="ui form" method="post" action="{{url('home/inkmind/linkapprove').'/'.$link_first->id}}">
            {!! csrf_field() !!}

            <div class="field">
                <label>标题（<a href="{{$link_first->url}}" target="_blank">点此访问</a>） </label>
                <input type="text" name="name" value="{{$link_first->name}}">
            </div>
            <div class="field">
                <label>地址</label>
                <input type="text" name="url" value="{{$link_first->url}}">
            </div>
            <div class="field">
                <label>标签</label>
                <input type="text" name="tags" value="{{$link_first->tags}}">
            </div>

            <div class="field">
                <label>类型</label>
                <div class="inline fields">
                    <div class="field">
                        <div class="ui radio checkbox">
                            <input type="radio" name="type" @if($link_first->type == 0)checked=""@endif tabindex="0" class="hidden" value="0">
                            <label>链接</label>
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui radio checkbox">
                            <input type="radio" name="type" @if($link_first->type == 1)checked=""@endif tabindex="0" class="hidden" value="1">
                            <label>公众号</label>
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui radio checkbox">
                            <input type="radio" name="type" @if($link_first->type == 2)checked=""@endif tabindex="0" class="hidden" value="2">
                            <label>书籍</label>
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui radio checkbox">
                            <input type="radio" name="type" @if($link_first->type == 3)checked=""@endif tabindex="0" class="hidden" value="3">
                            <label>生活</label>
                        </div>
                    </div>
                </div>
            </div>
            <button class="ui fluid button green" type="submit">审核通过，进入下一条</button>
        </form>
        <form method="post" action="{{url('home/inkmind/linkrefuse').'/'.$link_first->id}}">
            {!! csrf_field() !!}
            <button class="ui fluid button red" type="submit">拒绝，进入下一条</button>
        </form>
    </div>
    @endif

@endsection