from django.conf.urls import url

from . import views
from . import restapi

app_name = 'x123'
urlpatterns = [
    # ex: /
    url(r'^$', views.index, name='index'),
    # ex: /d/1/
    url(r'^d/(?P<domain_id>[0-9]+)/$', views.domain, name='domain'),
    # ex: /a/1/
    url(r'^a/(?P<aspect_id>[0-9]+)/$', views.aspect, name='aspect'),

    # ex: /bookmark/5/
    url(r'^b/(?P<bookmark_id>[0-9]+)/$', views.bookmark, name='bookmark'),

    url(r'^api/domains/$', restapi.DomainList.as_view()),
    url(r'^api/angles/$', restapi.AngleList.as_view()),
    url(r'^api/bookmarks/$', restapi.BookmarkList.as_view()),
    url(r'^api/bookmarks/(?P<pk>[0-9]+)/$', restapi.BookmarkDetail.as_view()),

    url(r'^api/auth_info/$', restapi.auth_info),
    url(r'^api/bookmark_existed/$', restapi.bookmark_existed),
    url(r'^api/bookmark_save/$', restapi.bookmark_save),
    url(r'^api/bookmark_remove/$', restapi.bookmark_remove),
    url(r'^api/bookmark_click/$', restapi.bookmark_click),

    url(r'^api/bookmarks_in_aspect/(?P<aspect_id>[0-9]+)/$', restapi.BookmarkListInAspect.as_view()),
    url(r'^api/feeds/$', restapi.FeedList.as_view()),
]

