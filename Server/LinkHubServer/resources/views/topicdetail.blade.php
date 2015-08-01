@extends('_layouts.app')


@section('content')
    <div class="ui segments">
        <div class="ui segment">
            {{$topic->name}}
        </div>
        <div class="ui red segment">
            @foreach($topic->links as $link)
                @include('_layouts.publiclink')
            @endforeach
        </div>

    </div>

@endsection