from mongoengine import *
from flask.ext.login import UserMixin
import datetime


class User(Document, UserMixin):
    email = StringField(required=True, unique=True)
    blog_id = StringField(required=True, max_length=100, unique=True)
    password = StringField(required=True, max_length=100)


class Tag(Document):
    name = StringField(required=True, max_length=50)
    user = ReferenceField(User, required=True, unique_with=['name'])
    created_at = DateTimeField(default=datetime.datetime.now)


class ClickEvent(Document):
    user = ReferenceField(User, required=True)
    created_at = DateTimeField(default=datetime.datetime.now)


class Post(Document):
    meta = {'allow_inheritance': True}
    title = StringField(required=True, max_length=100)
    user = ReferenceField(User)
    tags = ListField(ReferenceField(Tag))
    created_at = DateTimeField(default=datetime.datetime.now)


class LinkPost(Post):
    url = StringField(unique_with=['user'])
    click_events = ListField(ReferenceField(ClickEvent))


class TextPost(Post):
    content = StringField(required=True, max_length=100, unique_with=['user'])


