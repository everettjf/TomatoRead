# coding=utf-8
from flask import request,session,g,redirect,url_for,abort,render_template,flash, jsonify
from flask.ext.login import login_required, login_user, logout_user, current_user
from mongoengine import errors
from . import app, login_manager, oauth, github
import forms
import models
from .utils import password_hash


@app.route('/everettjf/users', methods=['GET'])
@login_required
def admin_users():
    users = models.User.objects()
    users_list = [dict(
        blog_id=user.blog_id,
        github_url=user.github_url,
        github_name=user.github_name,
        email=user.email,
        role=user.role,
    ) for user in users]

    return render_template('admin_users.html',
                           users=users_list
                           )
