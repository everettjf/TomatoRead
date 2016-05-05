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

target_json_dir = '/Users/everettjf/GitHub/everettjf.github.com/app/blogreader/'
target_markdown_dir = '/Users/everettjf/GitHub/iOSBlog/'

########################################################


# Util
def local_open(filename):
    return open(os.path.join(target_json_dir, filename), 'w+', encoding='utf-8')


def local_dump(obj, f):
    json.dump(obj, f, indent=4, ensure_ascii=False)


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
        local_dump(domains,f)
    print('domains exported')

    # Feeds
    for domain in Domain.objects.all():
        jsonfilename = '%d_feeds.json' % domain.id

        version = hashlib.md5()
        with local_open(jsonfilename) as f:
            feeds = []
            for link in Bookmark.objects.filter(~Q(feed_url='')).order_by('-created_at', '-zindex'):
                feeds.append({
                    'id': link.id,
                    'name': link.name,
                    'url': link.url,
                    'favicon': link.favicon,
                    'feed_url': link.feed_url,
                    'zindex': link.zindex,
                    'created_at': link.created_at.timestamp(),
                })

                version.update(link.feed_url.encode('utf-8'))
            local_dump(feeds,f)

        versionfilename = '%d_feeds.version' % domain.id
        with local_open(versionfilename) as f:
            f.write(version.hexdigest())

        print(jsonfilename, 'exported , version=',version.hexdigest())

    # Links
    for aspect in Aspect.objects.all():
        linkmodels = Bookmark.objects.filter(aspect_id=aspect.id).order_by('-created_at')
        p = Paginator(linkmodels,20)
        p.count
        p.num_pages
        for num in p.page_range:
            pagemodels = p.page(num).object_list

            filename = '%d_%d_link%d.json' % (aspect.domain_id, aspect.id, num)
            with local_open(filename) as f:
                pagelinks = []
                for link in pagemodels:
                    pagelinks.append({
                        'id': link.id,
                        'name': link.name,
                        'url': link.url,
                        'favicon': link.favicon,
                        'feed_url': link.feed_url,
                        'zindex': link.zindex,
                        'created_at': link.created_at.timestamp(),
                    })
                local_dump({
                    'count': p.count,
                    'num_pages': p.num_pages,
                    'cur_page': num,
                    'links' : pagelinks
                }, f)
            print(filename, ' exported')

########################################################
if __name__ == '__main__':
    export_json()

