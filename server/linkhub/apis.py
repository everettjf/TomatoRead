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
        return jsonify(succeed=False)

    user = users[0]

    link = models.LinkPost()
    link.title = title
    link.user = user
    link.tags = tags
    link.url = url
    link.clicks = []

    try:
        link.save()

        return jsonify(succeed=True)
    except errors.NotUniqueError, err:
        return jsonify(succeed=False)
    except errors.OperationError, err:
        return jsonify(succeed=False)


    return jsonify(succeed=False)


@csrf.exempt
@app.route('/api/link/exist', methods=['POST'])
@login_required
def api_is_exist_link():
    req = request.get_json()
    print req

    return jsonify(exist=False)




