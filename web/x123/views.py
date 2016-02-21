from django.shortcuts import render
from django.http import HttpResponse
from .models import Domain, Aspect, Bookmark, Angle
from django.shortcuts import get_object_or_404
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger


def fetch_paginator_bookmarks(request, bookmark_list):
    paginator = Paginator(bookmark_list, 56)
    page = request.GET.get('page')
    try:
        bookmarks = paginator.page(page)
    except PageNotAnInteger:
        bookmarks = paginator.page(1)
    except EmptyPage:
        bookmarks = paginator.page(paginator.num_pages)

    return bookmarks


def index(request):
    domains = Domain.objects.order_by('-zindex')
    angles = Angle.objects.order_by('-zindex')

    angle_id = request.GET.get('angle')
    if angle_id is None:
        bookmark_list = Bookmark.objects.order_by('-created_at')
    else:
        bookmark_list = Bookmark.objects.filter(angle_id=angle_id).order_by('-created_at')

    bookmarks = fetch_paginator_bookmarks(request, bookmark_list)

    return render(request, 'x123/index.html', {
        'domains': domains,
        'angles': angles,
        'bookmarks': bookmarks
    })


def domain(request, domain_id):
    domain = get_object_or_404(Domain, pk=domain_id)

    domains = Domain.objects.order_by('-zindex')
    angles = Angle.objects.order_by('-zindex')

    angle_id = request.GET.get('angle')
    if angle_id is None:
        bookmark_list = Bookmark.objects.filter(aspect__domain=domain_id).order_by('-created_at')
    else:
        bookmark_list = Bookmark.objects.filter(aspect__domain=domain_id, angle_id=angle_id).order_by('-created_at')

    bookmarks = fetch_paginator_bookmarks(request, bookmark_list)
    return render(request, 'x123/index.html', {
        'domain': domain,
        'domains': domains,
        'angles': angles,
        'bookmarks': bookmarks
    })


def aspect(request, aspect_id):
    aspect = get_object_or_404(Aspect, pk=aspect_id)

    domains = Domain.objects.order_by('-zindex')
    angles = Angle.objects.order_by('-zindex')

    angle_id = request.GET.get('angle')
    if angle_id is None:
        bookmark_list = Bookmark.objects.filter(aspect=aspect_id).order_by('-created_at')
    else:
        bookmark_list = Bookmark.objects.filter(aspect=aspect_id, angle_id=angle_id).order_by('-created_at')

    bookmarks = fetch_paginator_bookmarks(request, bookmark_list)

    return render(request, 'x123/index.html', {
        'aspect': aspect,
        'domains': domains,
        'angles': angles,
        'bookmarks': bookmarks
    })


def angle(request, angle_id):
    angle = get_object_or_404(Angle, pk=angle_id)

    domains = Domain.objects.order_by('-zindex')
    angles = Angle.objects.order_by('-zindex')
    bookmark_list = Bookmark.objects.filter(angle=angle_id).order_by('-created_at')
    bookmarks = fetch_paginator_bookmarks(request, bookmark_list)

    return render(request, 'x123/index.html', {
        'angle': angle,
        'domains': domains,
        'angles': angles,
        'bookmarks': bookmarks
    })


def bookmark(request, bookmark_id):
    bookmark = get_object_or_404(Bookmark, pk=bookmark_id)

    return render(request, 'x123/bookmark.html', {
        'bookmark': bookmark
    })


