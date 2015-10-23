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
    if len(search_links) == 0:
        return jsonify(exist=False)

    return jsonify(exist=True)


@csrf.exempt
@app.route('/api/link/add', methods=['POST'])
@login_required
def api_add_link():
    req = request.get_json()
    print req
    title = req['title']
    url = req['url']

    print title
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
        return jsonify(succeed=False,
                       reason='URL exist'
                       )

    link = models.LinkPost()
    link.title = title
    link.user = user
    link.tags = []
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
        return jsonify(succeed=False,
                       reason='Link save failed')

    return jsonify(succeed=True)


@csrf.exempt
@app.route('/api/link/update', methods=['POST'])
@login_required
def api_update_link():
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

    # if exist , update
    search_links = models.LinkPost.objects(user=user, url=url)
    if len(search_links) == 0:
        return jsonify(succeed=False,
                       reason='URL not exist'
                       )
    link = search_links[0]

    error_occur = False
    link.title = title
    link.tags = tags
    try:
        link.save()
    except:
        error_occur = True

    if error_occur:
        return jsonify(succeed=False,
                       reason='Update link failed'
                       )

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
        except:
            error_occur = True
            pass

    if error_occur:
        return jsonify(succeed=False,
                       reason='Update tags failed'
                       )

    return jsonify(succeed=True)



@csrf.exempt
@app.route('/api/link/info', methods=['GET'])
@login_required
def api_get_link_info():
    req = request.get_json()
    print req
    url = req['url']

    tags = list(set(req['tags'].replace(',', ' ').split(' ')))
    tags = [tag.strip() for tag in tags if tag.strip()]

    print tags
    print url

    users = models.User.objects(id=current_user.id)
    if len(users) == 0:
        return jsonify(succeed=False,
                       reason='User not exist')
    user = users[0]

    # if exist , update
    search_links = models.LinkPost.objects(user=user, url=url)
    if len(search_links) == 0:
        return jsonify(succeed=False,
                       reason='URL not exist'
                       )
    link = search_links[0]

    tag_string = link.tags.join(' ')

    return jsonify(succeed=True,
                   title=link.title,
                   tags=tag_string
                   )


