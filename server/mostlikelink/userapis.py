# coding=utf-8
from . import app, login_manager, csrf
from flask import json,jsonify,json_available, request
from flask.ext.login import login_required, login_user, logout_user,current_user, user_logged_in
from mongoengine import errors
import models
import utils
import datetime
from . import controllers


@csrf.exempt
@app.route('/api/blog/link/click', methods=['POST'])
def api_blog_link_click():
    req = request.get_json()
    print req
    blog_id = req['blog_id']
    link_id = req['link_id']

    if not (current_user.is_authenticated and current_user.blog_id == blog_id):
        return jsonify(succeed=True,
                       reason='')

    user = models.User.objects(blog_id=blog_id).first()
    if user is None:
        return jsonify(succeed=False,
                       reason='User not exist')

    link = models.LinkPost.objects(id=link_id).first()
    if link is None:
        return jsonify(succeed=False,
                       reason='Link not exist'
                       )
    link.click_count += 1
    link.clicked_at = datetime.datetime.now()
    try:
        link.save()
    except Exception, ex:
        return jsonify(succeed=False,
                       reason='Update link failed'
                       )

    event = models.ClickEvent()
    event.user = user
    event.link = link
    try:
        event.save()
    except Exception, e:
        print 'warning:click event save error : ', e.message

    return jsonify(succeed=True)


@csrf.exempt
@app.route('/api/blog/index', methods=['POST'])
def api_blog_index():
    req = request.get_json()
    print req
    blog_id = req['blog_id']
    filter_tags = req['filter_tags']

    ctl = controllers.UserController()
    if not ctl.init_user(blog_id):
        return jsonify(succeed=False,
                       reason='User not exist')

    ctl.init_filter_tags(filter_tags)

    return utils.json_response({
        'succeed': True,
        'top_links': ctl.fetch_top_links(),
        'all_tags': ctl.fetch_all_tags(),
        'all_links': ctl.fetch_all_links(),
        'most_click_links': ctl.fetch_most_click_links(),
        'latest_click_links': ctl.fetch_latest_click_links(),
        'never_click_links': ctl.fetch_never_click_links(),
    })


