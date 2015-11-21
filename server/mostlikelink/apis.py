# coding=utf-8

from . import app, login_manager, csrf
from flask import json,jsonify,json_available, request
from flask.ext.login import login_required, login_user, logout_user,current_user
from mongoengine import errors
import models
import utils


@csrf.exempt
@app.route('/api/user/current_user', methods=['POST'])
@login_required
def api_get_current_user():
    req = request.json
    print req

    return jsonify(email=current_user.email,
                   blog_id=current_user.blog_id
                   )


@csrf.exempt
@app.route('/api/link/add', methods=['POST'])
@login_required
def api_add_link():
    req = request.get_json()
    print req
    title = req['title']
    url = req['url']
    favicon = ''
    if 'favicon' in req:
        favicon = req['favicon']

    user = models.User.objects(id=current_user.id).first()
    if user is None:
        print 'user not exist : ' + str(current_user.id)
        return jsonify(succeed=False,
                       reason='User not exist')

    search_links = models.LinkPost.objects(user=user, url=url)
    if len(search_links) > 0:
        print 'url exist'
        return jsonify(succeed=False,
                       reason='URL exist'
                       )

    link = models.LinkPost()
    link.title = title
    link.user = user
    link.tags = []
    link.url = url
    link.color = utils.random_color()
    link.favicon = favicon

    try:
        link.save()
    except Exception, err:
        print 'link save error : '+ err.message
        return jsonify(succeed=False,
                       reason='Link save failed')

    click_event = models.ClickEvent()
    click_event.user = user
    click_event.link = link
    try:
        click_event.save()
    except Exception, ex:
        print 'click event save : ' + ex.message

    return jsonify(succeed=True)


@csrf.exempt
@app.route('/api/link/update', methods=['POST'])
@login_required
def api_update_link():
    req = request.get_json()
    print req
    url = req['url']

    title = req['title']
    tags = list(set(req['tags'].replace(',', ' ').split(' ')))
    tags = [tag.strip() for tag in tags if tag.strip()]
    description = req['description']
    favicon = req['favicon']

    user = models.User.objects(id=current_user.id).first()
    if user is None:
        return jsonify(succeed=False,
                       reason='User not exist')

    link = models.LinkPost.objects(user=user, url=url).first()
    if link is None:
        return jsonify(succeed=False,
                       reason='URL not exist'
                       )
    tags_data = []
    for tag in tags:
        try:
            cur_tag = models.Tag.objects(user=user, name=tag).first()
            if cur_tag is None:
                cur_tag = models.Tag()
                cur_tag.name = tag
                cur_tag.user = user
                cur_tag.color = utils.random_color()
                cur_tag.is_topic = tag.startswith('#')
                cur_tag.save()

            tags_data.append(cur_tag)
        except Exception, e:
            print 'update tag error :', e.message
            return jsonify(succeed=False,
                           reason='Update tags failed'
                           )

    link.title = title
    link.tags = tags_data
    link.description = description
    link.favicon = favicon
    try:
        link.save()
    except Exception, e:
        print 'link save error : ', e.message
        return jsonify(succeed=False,
                       reason='Update link failed'
                       )

    return jsonify(succeed=True)


@csrf.exempt
@app.route('/api/link/info', methods=['POST'])
@login_required
def api_link_info():
    req = request.get_json()
    print req
    url = req['url']

    user = models.User.objects(id=current_user.id).first()
    if user is None:
        return jsonify(succeed=False,
                       reason='User not exist')

    # if exist , update
    link = models.LinkPost.objects(user=user, url=url).first()
    if link is None:
        return jsonify(succeed=False,
                       reason='URL not exist'
                       )
    tag_names = [tag.name for tag in link.tags if hasattr(tag, 'name')]
    tag_string = " ".join(tag_names)

    return jsonify(succeed=True,
                   title=link.title,
                   tags=tag_string,
                   description=link.description,
                   favicon=link.favicon
                   )


@csrf.exempt
@app.route('/api/link/remove', methods=['POST'])
@login_required
def api_remove_link():
    req = request.get_json()
    print req
    url = req['url']

    user = models.User.objects(id=current_user.id).first()
    if user is None:
        return jsonify(succeed=False,
                       reason='User not exist')

    link = models.LinkPost.objects(url=url).first()
    if link is None:
        return jsonify(succeed=True,
                       reason='Link not exist')

    try:
        link.delete()
        return jsonify(succeed=True)
    except:
        return jsonify(succeed=False,
                       reason='Delete error')


@csrf.exempt
@app.route('/api/tags/recommend', methods=['GET'])
@login_required
def api_tags_recommend():
    user = models.User.objects(id=current_user.id).first()
    if user is None:
        return jsonify(succeed=False,
                       reason='User not exist')
    tags = models.Tag.objects(user=user)

    predefined_tags=[
        u':TOP',
        u':PRIVATE',
    ]

    tags_list = [tag.name for tag in tags if (not tag.is_topic) and (tag.name not in predefined_tags)]
    topics_list = [tag.name for tag in tags if tag.is_topic]

    return utils.json_response({
        'succeed': True,
        'tags': predefined_tags + list(set(tags_list)),
        'topics': list(set(topics_list))
    })


