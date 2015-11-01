from . import app, login_manager, csrf
from flask import json,jsonify,json_available, request
from flask.ext.login import login_required, login_user, logout_user,current_user
from mongoengine import errors
import models
import utils


@csrf.exempt
@app.route('/api/blog/index', methods=['POST'])
def api_tags_all():
    req = request.get_json()
    print req
    blog_id = req['blog_id']

    user = models.User.objects(blog_id=blog_id).first()
    if user is None:
        return jsonify(succeed=False,
                       reason='User not exist')

    all_links = models.LinkPost.objects(user=user)
    all_links_list = [dict(
        id=str(link.id),
        title=link.title,
        url=link.url
    ) for link in all_links];

    all_tags = models.Tag.objects(user=user)
    all_tags_list = [dict(
        id=str(tag.id),
        name=tag.name
    ) for tag in all_tags]

    return utils.json_response({
        'succeed': True,
        'all_tags': all_tags_list,
        'all_links': all_links_list
    })
