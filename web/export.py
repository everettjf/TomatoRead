#-*- coding:utf-8 -*-

import os
import django

os.environ['DJANGO_SETTINGS_MODULE'] = 'iosblog.settings'
django.setup()

# from .x123.models import Domain, Bookmark, Aspect
from x123.models import Domain, Bookmark, Aspect

import json
from django.db.models import F, Q
from django.core.paginator import Paginator
import hashlib
import datetime

target_json_dir = '/Users/everettjf/GitHub/everettjf.github.com/app/blogreader/'
target_markdown_dir = '/Users/everettjf/GitHub/iOSBlog/'

########################################################


# Util
def local_open(filename):
    return open(os.path.join(target_json_dir, filename), 'w+', encoding='utf-8')


def local_markdown_open(filename):
    return open(os.path.join(target_markdown_dir, filename), 'w+', encoding='utf-8')


def local_dump(obj, f):
    json.dump(obj, f, indent=4, ensure_ascii=False, sort_keys=True)


# Helper
def all_feeds():
    return Bookmark.objects.filter(~Q(feed_url='') | ~Q(spider='')).order_by('-created_at', '-zindex', 'feed_url','spider')


def all_links(aspect_id):
    return Bookmark.objects.filter(aspect_id=aspect_id).order_by('-created_at')


def link_to_dict(link):
    return {
        'id': link.id,
        'name': link.name,
        'url': link.url,
        'favicon': link.favicon,
        'feed_url': link.feed_url,
        'zindex': link.zindex,
        'created_at': link.created_at.timestamp(),
        'spider': link.spider,
        'domain_id': link.aspect.domain_id,
        'aspect_id': link.aspect_id,
    }


# Json export
def export_json():
    # Domains
    with local_open('domains.json') as f:
        domains = []
        for domain in Domain.objects.all():
            aspects = []
            for aspect in domain.aspect_set.all():
                aspects.append({
                    'id': aspect.id,
                    'name': aspect.name,
                    'zindex': aspect.zindex,
                })

            domains.append({
                'id': domain.id,
                'name': domain.name,
                'zindex': domain.zindex,
                'aspects': aspects,
            })
        local_dump({
            'domains': domains
        }, f)
    print('domains exported')

    # Feeds
    for domain in Domain.objects.all():
        jsonfilename = '%d_feeds.json' % domain.id

        version = hashlib.md5()
        with local_open(jsonfilename) as f:
            feeds = []
            for link in all_feeds():
                feeds.append(link_to_dict(link))

                version.update(link.feed_url.encode('utf-8'))
            local_dump({
                'feeds': feeds
            }, f)

        versionfilename = '%d_feeds.version' % domain.id
        with local_open(versionfilename) as f:
            f.write(version.hexdigest())

        print(jsonfilename, 'exported , version=',version.hexdigest())

    # Links
    for aspect in Aspect.objects.all():
        linkmodels = all_links(aspect.id)
        p = Paginator(linkmodels,20)
        for num in p.page_range:
            pagemodels = p.page(num).object_list

            filename = '%d_%d_link%d.json' % (aspect.domain_id, aspect.id, num)
            with local_open(filename) as f:
                pagelinks = []
                for link in pagemodels:
                    pagelinks.append(link_to_dict(link))

                local_dump({
                    'count': p.count,
                    'num_pages': p.num_pages,
                    'cur_page': num,
                    'links' : pagelinks
                }, f)
            print(filename, ' exported')


def export_markdown():
    f = local_markdown_open('README.md')

    f.write('# iOS 博客精选 \n\n')

    f.write('[http://iosblog.cc](http://iosblog.cc)\n')
    f.write('[这里查看介绍](http://everettjf.github.io/2016/02/24/iosblog-cc-dev-memory)\n\n')

    f.write('Blog | URL | Feed | Last Update Time\n')
    f.write('-----|-----|------|-----\n')

    for domain in Domain.objects.all():
        for link in all_feeds():
            name = link.name.replace('|',' ')
            f.write('%s | [%s](%s) | %s | %s \n' % (name, link.url,link.url, link.feed_url, ''))

    f.write('\n\n')
    f.write('Updated at %s'% datetime.datetime.now().isoformat())

    f.close()


########################################################
if __name__ == '__main__':
    export_json()
    export_markdown()

