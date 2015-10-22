from . import app, login_manager, csrf
from flask import json,jsonify,json_available, request
from flask.ext.login import login_required, login_user, logout_user,current_user
from mongoengine import errors
import models


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
@app.route('/api/link/exist', methods=['POST'])
@login_required
def api_is_exist_link():
    req = request.get_json()
    print req
    url = req['url']

    users = models.User.objects(id=current_user.id)
    if len(users) == 0:
        return jsonify(succeed=False)
    user = users[0]

    search_links = models.LinkPost.objects(user=user, url=url)
    if len(search_links) > 0:
        return jsonify(exist=True)

    return jsonify(exist=False)


@csrf.exempt
@app.route('/api/link/add', methods=['POST'])
@login_required
def api_add_link():
    req = request.get_json()
    print req
    title = req['title']
    url = req['url']

    tags = list(set(req['tags'].replace(',', ' ').split(' ')))
    tags = [tag.strip() for tag in tags if tag.strip()]

    print title
    print tags
    print url

    users = models.User.objects(id=current_user.id)
    if len(users) == 0:
        return jsonify(succeed=False,
                       reason='User not exist')
    user = users[0]

    clicks = []
    # if exist , update
    search_links = models.LinkPost.objects(user=user, url=url)
    if len(search_links) > 0:
        old_link = search_links[0]
        tags += old_link.tags
        tags = list(set(tags))

        clicks += old_link.clicks

    link = models.LinkPost()
    link.title = title
    link.user = user
    link.tags = tags
    link.url = url
    link.clicks = clicks

    link_save_succeed = False
    try:
        link.save()
    except errors.NotUniqueError, err:
        pass
    except errors.OperationError, err:
        pass

    if not link_save_succeed:
        return jsonify(succeed=False)

    for tag in tags:
        try:
            search_tags = models.Tag.objects(user=user, name=tag)
            if len(search_tags) > 0:
                # Update
                tag_model = search_tags[0]
                tag_model.posts.append(link)
                tag_model.save()
            else:
                # Add
                tag_model = models.Tag()
                tag_model.name = tag
                tag_model.user = user
                tag_model.posts = [link]
                tag_model.save()
        except errors.NotUniqueError, err:
            pass
        except errors.OperationError, err:
            pass

    return jsonify(succeed=True)


@csrf.exempt
@app.route('/api/link/edit', methods=['POST'])
@login_required
def api_edit_link():
    pass

