from wtforms import Form, StringField, validators, PasswordField


class LoginForm(Form):
    email = StringField(u'Email', validators=[validators.input_required()])
    password = PasswordField(u'Password', validators=[validators.input_required()])


class RegisterForm(Form):
    email = StringField(u'Email', validators=[validators.input_required()])
    password = PasswordField(u'Password', validators=[validators.input_required()])
