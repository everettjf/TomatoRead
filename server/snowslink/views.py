# coding=utf-8
from flask import request,session,g,redirect,url_for,abort,render_template,flash, jsonify
from flask.ext.login import login_required, login_user, logout_user, current_user
from . import app, login_manager, oauth, github
import models
from . import utils
import os
from . import controllers


@app.route('/')
def index():
    ctl = controllers.IndexController()

    return render_template('index.html',
                           total_link_count_string=ctl.get_total_link_count_string(),
                           star_users=ctl.get_star_users(),
                           latest_add_links=ctl.get_latest_add_links(),
                           )


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

        if user.github_url == 'https://github.com/everettjf':
            user.role = 1

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

    if user.private != 0 and current_user.blog_id != blog_id:
        return 'Blog is private'

    base_url = 'http://0.0.0.0:5000/'
    if os.environ.get('SNOWSLINK_PRODUCTION') is not None:
        base_url = 'http://snows.link/'

    return render_template('user.html',
                           user_name=user.github_name,
                           blog_id=blog_id,
                           base_url=base_url
                           )


@app.route('/link/export', methods=['GET'])
@login_required
def links_export():
    user = models.User.objects(id=current_user.id).first()
    if user is None:
        return 'User not exist'

    all_links = models.LinkPost.objects(user=user)

    result = "Snows.Link\n0.3\n"
    result += "--ExportFormatVersion:0.1\n\n"
    result += "Links:%d\n" % len(all_links)

    for link in all_links:
        result += "\n"
        result += "  Title:%s\n" % link.title
        result += "  URL:%s\n" % link.url
        result += "  ClickCount:%s\n" % link.click_count
        result += "  CreatedAt:%s\n" % str(link.created_at)
        result += "  Tags:%s\n" % " ".join([tag.name for tag in link.tags if hasattr(tag, 'name')])
        result += "  Favicon:%s\n" % link.favicon
        result += "  Description:%s\n" % link.description

    return utils.plaintext_response(result)


@app.route('/user/manage/tags', methods=['GET'])
@login_required
def user_manage_tags():
    user = models.User.objects(id=current_user.id).first()
    if user is None:
        return 'User not exist'

    topics = models.Tag.objects(user=user, is_topic=True)
    tags = models.Tag.objects(user=user, is_topic=False)

    return render_template('user_manage_tags.html',
                           blog_id=current_user.blog_id,
                           topics=topics,
                           tags=tags
                           )


@app.route('/user/manage/tags/remove', methods=['POST'])
@login_required
def remove_tag():
    user = models.User.objects(id=current_user.id).first()
    if user is None:
        return 'User not exist'

    tagfind = models.Tag.objects(user=user, name=request.form['tag_name']).first()

    links = models.LinkPost.objects(user=user, tags__in=[tagfind])
    for link in links:
        link.tags = [tag for tag in link.tags if tag.id != tagfind.id]
        link.save()

    tag.delete()

    return redirect(url_for('user_manage_tags'))


@app.route('/user/manage/tags/update', methods=['POST'])
@login_required
def update_tag():
    user = models.User.objects(id=current_user.id).first()
    if user is None:
        return 'User not exist'

    tag = models.Tag.objects(user=user, name=request.form['tag_name']).first()
    if tag is None:
        return 'Tag not exist'

    new_name = request.form['new_name']
    if new_name == '' or new_name is None:
        return 'new name can not be empty'

    tag.name = new_name
    tag.is_topic = tag.name.startswith('#')
    tag.save()

    return redirect(url_for('user_manage_tags'))


@app.route('/user/manage/profile', methods=['GET','POST'])
@login_required
def user_manage_profile():
    if request.method == 'POST':
        user = models.User.objects(email=current_user.email).first()
        if user is None:
            return 'User not exist'

        isprivate = request.form.get('private')
        if isprivate == 'on':
            user.private = 1
        else:
            user.private = 0

        user.save()
        current_user.private = user.private

    return render_template('user_manage_profile.html')
