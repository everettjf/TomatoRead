@extends('_layouts.app')

@section('endofhead')
    <style type="text/css">
        body > .grid {
            height: 100%;
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
                    <div class="ui fluid large teal submit button">登录</div>
                </div>

                <div class="ui error message"></div>

            </form>

            <div class="ui message">
                没有账号？ <a href="{{ url('my/register') }}">注册</a>
            </div>
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
                                  }
                              }
                          })
                  ;
              })
      ;
  </script>

    @endsection