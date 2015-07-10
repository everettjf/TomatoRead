@extends('_layouts.app')

@section('content')
    <div class="ui main container">
        <div class="ui grid">
            @foreach($groups as $group)
            <div class="three wide column">
                <table class="ui red table">
                    <thead><th>{{$group->name}}</th></thead>
                    <tbody>
                    <tr><td>111111322322222222</td></tr>
                    <tr><td>111111322322222222</td></tr>
                    <tr><td>111111322322222222</td></tr>
                    <tr><td>111111322322222222</td></tr>
                    <tr><td>111111322322222222</td></tr>
                    <tr><td>111111322322222222</td></tr>
                    <tr><td>111111322322222222</td></tr>
                    </tbody>
                </table>
            </div>
                @endforeach
        </div>
    </div>
@endsection