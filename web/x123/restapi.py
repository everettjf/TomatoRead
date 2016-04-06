from django.http import HttpResponse
from .models import Domain, Aspect, Angle, Bookmark
from .serializers import DomainSerializer, AspectSerializer, AngleSerializer, BookmarkSerializer, UserSerializer
from rest_framework import generics
from django.contrib.auth.models import User
from .utils import JSONResponse, parse_request_json
from django.views.decorators.http import require_GET, require_POST
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.db.models import F, Q


class DomainList(generics.ListAPIView):
    queryset = Domain.objects.all()
    serializer_class = DomainSerializer


class AspectList(generics.ListAPIView):
    queryset = Aspect.objects.all()
    serializer_class = AspectSerializer


class AngleList(generics.ListAPIView):
    queryset = Angle.objects.all()
    serializer_class = AngleSerializer


class BookmarkList(generics.ListAPIView):
    queryset = Bookmark.objects.all().order_by('-created_at')
    serializer_class = BookmarkSerializer


class BookmarkListInAspect(generics.ListAPIView):
    serializer_class = BookmarkSerializer

    def get_queryset(self):
        # print('query params : ')
        # print(self.kwargs)
        return Bookmark.objects.filter(aspect_id=self.kwargs['aspect_id']).order_by('-created_at')


class FeedList(generics.ListAPIView):
    serializer_class = BookmarkSerializer

    def get_queryset(self):
        return Bookmark.objects.filter(~Q(feed_url='')).order_by('-created_at')


class BookmarkDetail(generics.RetrieveAPIView):
    queryset = Bookmark.objects.all()
    serializer_class = BookmarkSerializer


@require_GET
def auth_info(request):
    if not request.user.is_authenticated():
        return HttpResponse(status=403)

    user = request.user
    return JSONResponse({
        'id': user.id,
        'name': user.username
    })


@require_POST
@csrf_exempt
def bookmark_existed(request):
    body_data = parse_request_json(request)
    url = body_data['url']
    try:
        find = Bookmark.objects.get(url=url)
    except Bookmark.DoesNotExist:
        return JSONResponse({'existed': 0})

    return JSONResponse({
        'existed': 1,
        'id': find.id
    })


@require_POST
@csrf_exempt
def bookmark_save(request):
    if not request.user.is_authenticated():
        return JSONResponse({
            'result': 1,
            'reason': 'not authenticated'
        })

    body = parse_request_json(request)

    name = body['name']
    aspect_id = body['aspect_id']
    angle_id = body['angle_id']

    url = body['url']
    description = body['description']

    if 'feedurl' in body:
        feedurl = body['feedurl']
    else:
        feedurl = ''

    if 'favicon' in body:
        favicon = body['favicon']
    else:
        favicon = ''

    try:
        find = Bookmark.objects.get(url=url)

        # if find.creator_id != request.user.id:
        #     return JSONResponse({
        #         'result': 2,
        #         'reason': 'do not have permission'
        #     })

    except Bookmark.DoesNotExist:
        find = None

    if find is None:
        find = Bookmark()

    find.name = name
    find.aspect_id = aspect_id
    find.angle_id = angle_id
    find.url = url
    find.description = description

    find.favicon = favicon
    find.feed_url = feedurl
    find.creator_id = request.user.id

    find.save()

    return JSONResponse({
        'result': 0
    })


@require_POST
@csrf_exempt
def bookmark_remove(request):
    if not request.user.is_authenticated():
        return JSONResponse({
            'result': 1,
            'reason': 'not authenticated'
        })

    body = parse_request_json(request)
    url = body['url']

    try:
        find = Bookmark.objects.get(url=url)

        # if find.creator_id != request.user.id:
        #     return JSONResponse({
        #         'result': 2,
        #         'reason': 'do not have permission'
        #     })

        find.delete()
    except Bookmark.DoesNotExist:
        return JSONResponse({
            'result': 2,
            'reason': 'not existed'
        })

    return JSONResponse({
        'result': 0
    })


@require_POST
@csrf_exempt
def bookmark_click(request):
    body = parse_request_json(request)
    id = body['id']
    try:
        find = Bookmark.objects.filter(pk=id).update(clicks=F('clicks') + 1)
    except Bookmark.DoesNotExist:
        return JSONResponse({
            'result': 1,
            'reason': 'not existed'
        })
    return JSONResponse({
        'result': 0
    })



