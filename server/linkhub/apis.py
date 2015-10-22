from . import app, login_manager, csrf
from flask import json,jsonify,json_available, request
from flask.ext.login import login_required, login_user, logout_user,current_user


@csrf.exempt
@app.route('/api/user/current_user', methods=['POST'])
@login_required
def api_get_current_user():
    req = request.json
    print req

    return jsonify(email=current_user.email,
                   blog_id=current_user.blog_id
                   )




