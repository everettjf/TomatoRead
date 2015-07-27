@extends('_layouts.user')

@section('subcontent')

    <h4 class="ui header">个人信息</h4>
    <div class="ui info message">
        <p>
            账号：{{Auth::user()->email }} 积分：{{ Auth::user()->score }} 分。称号：分享小兵。
        </p>
    </div>

    <h4 class="ui header">链接信息</h4>
    <div class="ui info message">
        <ul class="list">
            <li>{{$count_all}} 条私有链接</li>
            <li>
                其中 {{$count_in_queue}} 条链接没有标签
                @if($count_in_queue > 0)
                    <a href="{{url('home/organiselink')}}">（进入添加标签向导）</a>
                @endif
            </li>
            <li>分享 N 条链接</li>
        </ul>
    </div>


@endsection

@section('endofbody')
<script>
    $('.ui.radio.checkbox')
            .checkbox()
    ;

    $(function(){
        $('p#commonTags a').click(function () {
            $('#tags').val( $('#tags').val()+ ' ' + $(this).text());
        });
    });
</script>

    @endsection