@extends('_layouts.app')

@section('content')
    <div class="ui two column centered grid">
        <div class="column">

            <div class="ui fluid icon input">
                <input type="text" placeholder="在我的私有链接中查找">
                <i class="circular search link icon"></i>
            </div>

        </div>
    </div>


    <div class="ui stackable four column grid">
        <div class="column">
            <table class="ui green table">
                <tbody>
                <tr>
                    <td>
                        <h5 class="ui header">点击次数最多</h5>
                        <p>
                            @for($i = 0; $i < 20; $i++)
                                <a href="#">链接项目</a>
                            @endfor
                        </p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="column">
            <table class="ui green table">
                <tbody>
                <tr>
                    <td>
                        <h5 class="ui header">最近点击</h5>
                        <p>
                            @for($i = 0; $i < 20; $i++)
                                <a href="#">链接项目</a>
                            @endfor
                        </p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="column">
            <table class="ui green table">
                <tbody>
                <tr>
                    <td>
                        <h5 class="ui header">最近添加</h5>
                        <p>
                            @for($i = 0; $i < 20; $i++)
                                <a href="#">链接项目</a>
                            @endfor
                        </p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="column">
            <table class="ui green table">
                <tbody>
                <tr>
                    <td>
                        <h5 class="ui header">最不经常点击</h5>
                        <p>
                            @for($i = 0; $i < 20; $i++)
                                <a href="#">链接项目</a>
                            @endfor
                        </p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="ui stackable four column grid">
        @foreach($groups as $group)
        <div class="column">
            <table class="ui pink table">
                <tbody>
                <tr>
                    <td>
                        <h5 class="ui header">{{$group->name}}</h5>
                        <p>
                            @for($i = 0; $i < 20; $i++)
                                <a href="#">链接项目</a>
                            @endfor
                        </p>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        @endforeach
    </div>

@endsection