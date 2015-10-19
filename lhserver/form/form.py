from wtforms import Form, StringField, validators


class LoginForm(Form):
    email = StringField(u'Email', validators=[validators.input_required()])
    password = StringField(u'Password', validators=[validators.input_required()])
