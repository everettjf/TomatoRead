# coding=utf-8
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
    invite_code = StringField()
    role = IntField(default=0)

    # Blog is private, means anyone except me can view
    private = IntField(default=0)
    # 0 Enable , 1 Disable
    state = IntField(default=0)
    # Star value
    star = IntField(default=0)


class Tag(Document):
    name = StringField(required=True, max_length=100)
    user = ReferenceField(User, required=True, unique_with=['name'])
    created_at = DateTimeField(default=datetime.datetime.now)
    color = IntField(default=0)
    is_topic = BooleanField(default=False)


class Post(Document):
    meta = {'allow_inheritance': True}
    title = StringField(required=True, max_length=100)
    user = ReferenceField(User)
    tags = ListField(ReferenceField(Tag))
    created_at = DateTimeField(default=datetime.datetime.now)
    color = IntField(default=0)
    is_private = BooleanField(default=False)


class LinkPost(Post):
    url = StringField(unique_with=['user'])
    click_count = IntField(default=1)
    clicked_at = DateTimeField(default=datetime.datetime.now)
    description = StringField(max_length=200, default='')
    favicon = StringField(default='')

    @queryset_manager
    def objects(doc_cls, queryset):
        return queryset.order_by('-created_at')

    @queryset_manager
    def most_click_links(doc_cls, queryset):
        return queryset.order_by('-click_count')[:5]

    @queryset_manager
    def latest_click_links(doc_cls, queryset):
        return queryset.order_by('-clicked_at')[:5]

    @queryset_manager
    def never_click_links(doc_cls, queryset):
        return queryset.order_by('clicked_at')[:5]


class ClickEvent(Document):
    user = ReferenceField(User, required=True)
    link = ReferenceField(LinkPost, unique_with=['user'])
    created_at = DateTimeField(default=datetime.datetime.now)


