#-*- coding:utf-8 -*-

import os
import django
from envconfig import target_json_dir,target_markdown_dir
import feedparser
import time
import math
import datetime

###########################################################

os.environ['DJANGO_SETTINGS_MODULE'] = 'iosblog.settings'
django.setup()

# from .x123.models import Domain, Bookmark, Aspect
from x123.models import Domain, Bookmark, Aspect

import json
from django.db.models import F, Q
from django.core.paginator import Paginator
import hashlib
import datetime

# Util
def local_markdown_open(filename):
    return open(os.path.join(target_markdown_dir, filename), 'w+', encoding='utf-8')

# def time_as_date(gmt_time_string):
#     # t = datetime.datetime.strptime('Sun, 08 May 2016 14:11:16 GMT','%a, %d %b %Y %H:%M:%S GMT')
#     # t = datetime.datetime.strptime(gmt_time_string,'%a, %d %b %Y %H:%M:%S GMT')
#     t = datetime.datetime.strptime(gmt_time_string,'%a, %d %b %Y %H:%M:%S GMT')
#     return t.strftime('%Y-%m-%d')


def time_as_string(struct_time):
    return time.strftime('%Y-%m-%d', struct_time)

# Helper
def all_feeds():
    return Bookmark.objects.filter(~Q(feed_url='') | ~Q(spider='') ).order_by('-zindex', 'created_at')


def get_update_time_string(spider, oid):
    jsonfilepath = os.path.join(target_json_dir,'spider', spider, '%d.json'%oid)
    print(jsonfilepath)

    dates = []
    try:
        f = open(jsonfilepath,encoding='utf-8')

        d = json.load(f)
        for one in d['posts']:
            dates.append(one['createtime'])

        if len(dates) == 0:
            return ''

        dates.sort(reverse=True)
    except:
        return ''

    return dates[0][0:10]


def export_markdown():
    f = local_markdown_open('README.md')

    f.write('# 番茄阅读 - 专注于精选 iOS/OS X 开发者博客\n\n')
    f.write('QQ交流群 : 157422249 (欢迎交流不限于番茄阅读的任何问题)\n\n')
    f.write('[相关介绍](http://everettjf.github.io/2016/02/24/iosblog-cc-dev-memory)\n\n')
    f.write('感谢 https://github.com/tangqiaoboy/iOSBlogCN 提供基础数据,我在此基础上进行了较多的增删.\n\n')

    f.write('---\n\n')

    f.write('Blog | Feed | Update Time\n')
    f.write('-----|------|-----\n')

    items = []
    for link in all_feeds():
        name = link.name.replace('|', ' ')
        spider = link.feed_url
        if spider == '':
            spider = link.spider

        update_time = ''
        if link.feed_url == '':
            start = time.time()
            if link.spider != '':
                update_time = get_update_time_string(link.spider,link.id)
            end = time.time()
        else:
            start = time.time()
            feed = feedparser.parse(link.feed_url)
            end = time.time()

            if 'updated_parsed' in feed:
                update_time = time_as_string(feed.updated_parsed)
            else:
                if len(feed.entries) > 0:
                    one = feed.entries[0]
                    if 'published_parsed' in one:
                        update_time = time_as_string(feed.entries[0].published_parsed)
                    elif 'updated_parsed' in one:
                        update_time = time_as_string(feed.entries[0].updated_parsed)

        print('(%d)%s[%s](%s) | %s ' % (math.ceil(end-start),update_time,name, link.url, spider ))

        # f.write('[%s](%s) | %s | %s \n' % (name, link.url, spider, update_time))
        items.append({
            'name': name,
            'url': link.url,
            'spider': spider,
            'update_time': update_time,
        })
    items = sorted(items, key=lambda item: item['update_time'], reverse=True)
    for item in items:
        f.write('[%s](%s) | %s | %s \n' % (
            item['name'],
            item['url'],
            item['spider'],
            item['update_time'],
        ))

    print('finished')
    f.write('\n\n')
    f.write('Updated at %s'% datetime.datetime.now().isoformat())
    f.write('\n\n')

    f.close()



########################################################
if __name__ == '__main__':
    export_markdown()

