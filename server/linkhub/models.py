from mongoengine import *
from flask.ext.login import UserMixin
import datetime


class User(Document, UserMixin):
    email = StringField(required=True, unique=True)
    blog_id = StringField(required=True, max_length=100, unique=True)
    password = StringField(required=True, max_length=100)


class Post(Document):
    meta = {'allow_inheritance': True}
    title = StringField(required=True, max_length=100)
    user = ReferenceField(User)
    tags = ListField(StringField(max_length=50))
    created_at = DateTimeField(default=datetime.datetime.now)


class LinkPost(Post):
    link_url = StringField(unique_with=['user', 'title'])
    click_events = ListField(DateTimeField(default=datetime.datetime.now))


class TextPost(Post):
    content = StringField(max_length=100, unique_with=['user', 'title'])


class Tag(Document):
    name = StringField(required=True, max_length=50)
    user = ReferenceField(User, required=True, unique_with=['name'])
    posts = ListField(ReferenceField(User))
    created_at = DateTimeField(default=datetime.datetime.now)


