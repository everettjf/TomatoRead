# coding=utf-8
import hashlib
from . import app
from flask import Response
import json
import datetime
import random


def password_hash(password):
    return hashlib.sha1(hashlib.sha1(password + app.config['PASSWORD_SALT']).hexdigest()).hexdigest()


def json_response(dict_data):
    return Response(response=json.dumps(dict_data),
                    status=200,
                    mimetype='application/json')


def plaintext_response(string_data):
    return Response(response=string_data,
                    status=200,
                    mimetype='text/plain')


def totimestamp(dt, epoch=datetime.datetime(1970,1,1)):
    td = dt - epoch
    return td.total_seconds()


def random_color():
    return random.randint(0, 255)
