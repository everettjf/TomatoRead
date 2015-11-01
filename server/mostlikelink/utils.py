import hashlib
from . import app
from flask import Response
import json


def password_hash(password):
    return hashlib.sha1(hashlib.sha1(password + app.config['PASSWORD_SALT']).hexdigest()).hexdigest()


def json_response(dict_data):
    return Response(response=json.dumps(dict_data),
                    status=200,
                    mimetype='application/json')
