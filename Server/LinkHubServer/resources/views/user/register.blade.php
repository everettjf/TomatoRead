@extends('_layouts.app')

@section('endofhead')
    <style type="text/css">
        body > .grid {
            height: 100%;
        }
        .image {
            margin-top: -100px;
        }
        .column {
            max-width: 450px;
        }
    </style>
@endsection


@section('content')


    <div class="ui middle aligned center aligned grid">
        <div class="column">
            <form class="ui large form">
                <div class="ui stacked segment">
                    <div class="field">
                        <div class="ui left icon input">
                            <i class="user icon"></i>
                            <input type="text" name="email" placeholder="E-mail address">
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui left icon input">
                            <i class="lock icon"></i>
                            <input type="password" name="password" placeholder="Password">
                        </div>
                    </div>
                    <div class="field">
                        <div class="ui left icon input">
                            <i class="lock icon"></i>
                            <input type="password" name="passwordConfirm" placeholder="Password Confirm">
                        </div>
                    </div>
                    <div class="ui fluid large teal submit button">注册</div>
                </div>

                <div class="ui error message"></div>

            </form>
        </div>
    </div>
@endsection

@section('endofbody')

    <script>
        $(document)
                .ready(function() {
                    $('.ui.form')
                            .form({
                                fields: {
                                    email: {
                                        identifier  : 'email',
                                        rules: [
                                            {
                                                type   : 'empty',
                                                prompt : 'Please enter your e-mail'
                                            },
                                            {
                                                type   : 'email',
                                                prompt : 'Please enter a valid e-mail'
                                            }
                                        ]
                                    },
                                    password: {
                                        identifier  : 'password',
                                        rules: [
                                            {
                                                type   : 'empty',
                                                prompt : 'Please enter your password'
                                            },
                                            {
                                                type   : 'length[6]',
                                                prompt : 'Your password must be at least 6 characters'
                                            }
                                        ]
                                    },
                                    passwordConfirm: {
                                        identifier  : 'passwordConfirm',
                                        rules: [
                                            {
                                                type   : 'match[password]',
                                                prompt : 'Password confirm not match'
                                            }
                                        ]
                                    }
                                }
                            })
                    ;
                })
        ;
    </script>

@endsection