# coding=utf-8
from . import app, login_manager, csrf, red
from flask import json,jsonify,json_available, request
from flask.ext.login import login_required, login_user, logout_user,current_user, user_logged_in
from mongoengine import errors
import models
import utils
import datetime


@csrf.exempt
@app.route('/api/blog/link/click', methods=['POST'])
def api_blog_link_click():
    req = request.get_json()
    print req
    blog_id = req['blog_id']
    link_id = req['link_id']

    if red.exists(blog_id + link_id):
        return jsonify(succeed=True)

    red.setex(blog_id+link_id, 1, 60)

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

    user = models.User.objects(blog_id=blog_id).first()
    if user is None:
        return jsonify(succeed=False,
                       reason='User not exist')

    top_links_list = []
    tag_top = models.Tag.objects(name=':TOP').first()
    if tag_top is not None:
        print 'tag top is = %s'% tag_top.name
        top_links = models.LinkPost.objects(tags__in=[tag_top])
        print 'top links len = %d' % len(top_links)
        top_links_list = [dict(
            id=str(link.id),
            title=link.title,
            url=link.url
        ) for link in top_links]

    filter_tags_ids = [tag['id'] for tag in filter_tags]
    filter_tags_entities = models.Tag.objects(id__in=filter_tags_ids)
    print 'filter tags entities len = %d'% len(filter_tags_entities)

    all_tags = models.Tag.objects(user=user)
    all_tags_list = [dict(
        id=str(tag.id),
        name=tag.name
    ) for tag in all_tags]

    all_links = []
    if len(filter_tags_entities) == 0:
        all_links = models.LinkPost.objects(user=user)[0:100]
    else:
        all_links = models.LinkPost.objects(user=user, tags__all=filter_tags_entities)

    all_links_list = [dict(
        id=str(link.id),
        title=link.title,
        url=link.url
    ) for link in all_links]

    # Only for yourself
    most_click_links_list = []
    latest_click_links_list = []
    never_click_links_list = []
    if current_user.is_authenticated and current_user.id == user.id:
        print 'same user'
        if len(filter_tags_entities) == 0:
            most_click_links = models.LinkPost.most_click_links(user=user)
            latest_click_links = models.LinkPost.latest_click_links(user=user)
            never_click_links = models.LinkPost.never_click_links(user=user)
        else:
            most_click_links = models.LinkPost.most_click_links(user=user, tags__in=filter_tags_entities)
            latest_click_links = models.LinkPost.latest_click_links(user=user, tags__in=filter_tags_entities)
            never_click_links = models.LinkPost.never_click_links(user=user, tags__in=filter_tags_entities)

        most_click_links_list = [dict(
            id=str(link.id),
            title=link.title,
            url=link.url,
            click_count=link.click_count
        ) for link in most_click_links]

        latest_click_links_list = [dict(
            id=str(link.id),
            title=link.title,
            url=link.url,
            clicked_at=utils.totimestamp(link.clicked_at)
        ) for link in latest_click_links]

        never_click_links_list = [dict(
            id=str(link.id),
            title=link.title,
            url=link.url,
            clicked_at=utils.totimestamp(link.clicked_at)
        ) for link in never_click_links]

    return utils.json_response({
        'succeed': True,
        'top_links': top_links_list,
        'all_tags': all_tags_list,
        'all_links': all_links_list,
        'most_click_links': most_click_links_list,
        'latest_click_links': latest_click_links_list,
        'never_click_links': never_click_links_list,
    })


