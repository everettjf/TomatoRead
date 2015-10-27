from flask import request,session,g,redirect,url_for,abort,render_template,flash
from flask.ext.login import login_required, login_user, logout_user
from mongoengine import errors
from . import app, login_manager
import forms
import models
import hashlib


# For Login
@login_manager.user_loader
def load_user(user_id):
    users = models.User.objects(id=user_id)
    if len(users) == 0:
        return None
    return users[0]


# Util
def password_hash(password):
    return hashlib.sha1(hashlib.sha1(password + app.config['PASSWORD_SALT']).hexdigest()).hexdigest()


# Routes
@app.route('/')
def index():
    return render_template('index.html')


@app.route('/u')
@login_required
def user_list():
    return 'Hi,you should visit /u/your_blog_id'


@app.route('/u/<string:blog_id>' , methods=['GET'])
@login_required
def user_index(blog_id):
    user = models.User.objects(blog_id=blog_id).first()
    if user is None:
        return 'Blog not found'

    posts = models.LinkPost.objects(user=user)
    if len(posts) == 0:
        return 'No links'

    posts_data = [dict(
        title=post.title,
        url=post.url,
    ) for post in posts]

    return render_template('user_index.html', posts=posts_data)


@app.route('/register', methods=['GET', 'POST'])
def register():
    register_form = forms.RegisterForm(request.form)
    if request.method == 'POST' and register_form.validate():
        user = models.User()
        user.email = request.form['email']
        user.password = password_hash(request.form['password'])
        user.blog_id = hashlib.md5(user.email).hexdigest()

        try:
            user.save()
            flash('Register succeed')
            return redirect(url_for('login'))
        except errors.NotUniqueError, err:
            flash('Email existed')
        except errors.OperationError, err:
            flash('Save Error')

    return render_template('register.html', form=register_form)


@app.route('/login', methods=['GET', 'POST'])
def login():
    login_form = forms.LoginForm(request.form)
    if request.method == 'POST' and login_form.validate():
        password = password_hash(login_form.password.data)
        users = models.User.objects(email=login_form.email.data, password=password)
        if len(users) > 0:
            user = users[0]
            login_user(user)

            flash('Logged in successfully.')
            return redirect(url_for('user_index', blog_id=user.blog_id))
        else:
            flash('Password or email incorrect')

    return render_template('login.html', form=login_form)


@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

# AddLink
# ClickLink
# UpdateLink
#


