from mongoengine import *
from flask.ext.login import UserMixin
import datetime


class User(Document, UserMixin):
    email = StringField(required=True, unique=True)
    blog_id = StringField(required=True, max_length=100, unique=True)
    github_url = StringField()
    github_name = StringField()
    github_login = StringField()
    github_avatar_url = StringField()


class Tag(Document):
    name = StringField(required=True, max_length=100)
    user = ReferenceField(User, required=True, unique_with=['name'])
    created_at = DateTimeField(default=datetime.datetime.now)


class Post(Document):
    meta = {'allow_inheritance': True}
    title = StringField(required=True, max_length=100)
    user = ReferenceField(User)
    tags = ListField(ReferenceField(Tag))
    created_at = DateTimeField(default=datetime.datetime.now)


class LinkPost(Post):
    url = StringField(unique_with=['user'])
    click_count = IntField(default=1)
    clicked_at = DateTimeField(default=datetime.datetime.now)


class TextPost(Post):
    content = StringField(required=True, max_length=100, unique_with=['user'])


class ClickEvent(Document):
    user = ReferenceField(User, required=True)
    link = ReferenceField(LinkPost, unique_with=['user'])
    created_at = DateTimeField(default=datetime.datetime.now)


