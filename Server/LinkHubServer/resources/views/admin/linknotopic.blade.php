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
            还有无主题链接 {{ $count }} 条（无主题，且已经审核的链接）
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
    @if(isset($link))
        <div class="ui pink segment">
            <form class="ui form" method="post" action="{{url('home/inkmind/linknotopic').'/'.$link->id}}">
                {!! csrf_field() !!}

                <div class="field">
                    <label>标题（<a href="{{$link->url}}" target="_blank">点此访问</a>） </label>
                    <input type="text" name="name" value="{{$link->name}}">
                </div>
                <div class="field">
                    <label>标签</label>
                    <input type="text" name="tags" value="{{$link->tags}}">
                </div>

                <div class="field">
                    <label>类型</label>
                    <div class="inline fields">
                        <div class="field">
                            <div class="ui radio checkbox">
                                <input type="radio" name="type" @if($link->type == 0)checked=""@endif tabindex="0" class="hidden" value="0">
                                <label>链接</label>
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui radio checkbox">
                                <input type="radio" name="type" @if($link->type == 1)checked=""@endif tabindex="0" class="hidden" value="1">
                                <label>公众号</label>
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui radio checkbox">
                                <input type="radio" name="type" @if($link->type == 2)checked=""@endif tabindex="0" class="hidden" value="2">
                                <label>书籍</label>
                            </div>
                        </div>
                        <div class="field">
                            <div class="ui radio checkbox">
                                <input type="radio" name="type" @if($link->type == 3)checked=""@endif tabindex="0" class="hidden" value="3">
                                <label>生活</label>
                            </div>
                        </div>
                    </div>
                </div>


                <div class="field">
                    <label>主题</label>
                    <div class="inline fields">
                        @foreach($topics as $topic)
                        <div class="field">
                            <div class="ui radio checkbox">
                                <input type="radio" name="topic"  tabindex="0" class="hidden" value="{{$topic->id}}">
                                <label>{{$topic->name}}</label>
                            </div>
                        </div>
                            @endforeach

                        <div class="field">
                            <div class="ui radio checkbox">
                                <input type="radio" name="topic" checked="" tabindex="0" class="hidden" value="0">
                                <label>没有，创建一个</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="field">
                    <label>创建新的主题</label>
                    <input type="text" name="topic_name">
                </div>

                <button class="ui fluid button green" type="submit">确认，进入下一个</button>
            </form>
        </div>
    @endif
@endsection