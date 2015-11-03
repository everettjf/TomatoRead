# coding=utf-8
from flask import request,session,g,redirect,url_for,abort,render_template,flash, jsonify
from flask.ext.login import login_required, login_user, logout_user, current_user
from mongoengine import errors
from . import app, login_manager, oauth, github
import forms
import models
from .utils import password_hash


@app.route('/')
def index():
    # if current_user.is_authenticated:
    #     return redirect(url_for('user_index', blog_id=current_user.blog_id))

    return render_template('index.html')


@app.route('/login')
def login():
    return github.authorize(callback=url_for('authorized', _external=True))


@app.route('/logout')
def logout():
    session.pop('github_token', None)
    logout_user()
    return redirect(url_for('index'))


@app.route('/login/authorized')
def authorized():
    resp = github.authorized_response()
    if resp is None:
        return 'Access denied: reason=%s error=%s' % (
            request.args['error'],
            request.args['error_description']
        )
    session['github_token'] = (resp['access_token'], '')
    me = github.get('user')

    info = me.data
    email = info['email']

    user = models.User.objects(email=email).first()
    if user is None:
        user = models.User()
        user.email = email
        user.blog_id = info['login']
        user.github_url = info['html_url']
        user.github_name = info['name']
        user.github_login = info['login']
        user.github_avatar_url = info['avatar_url']

        try:
            user.save()
        except Exception, e:
            print 'user save error:', e.message
            return 'error save user'

    login_user(user)

    return redirect(url_for('index'))


@github.tokengetter
def get_github_oauth_token():
    return session.get('github_token')


# For Login
@login_manager.user_loader
def load_user(user_id):
    return models.User.objects(id=user_id).first()


@app.route('/u/<string:blog_id>', methods=['GET'])
def user_index(blog_id):
    user = models.User.objects(blog_id=blog_id).first()
    if user is None:
        return 'Blog not found'

    return render_template('user.html',
                           user_name=user.github_name,
                           blog_id=blog_id
                           )


