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
import re

# 2016/5/15 21:33:46
_my_date_pattern = re.compile(r'(\d{4})/(\d{,2})/(\d{,2}) (\d{,2}):(\d{,2}):(\d{,2})')
def myDateHandler(aDateString):
    res = _my_date_pattern.search(aDateString)
    if res is None:
        return None
    year, month, day, hour, minute, second = res.groups()
    return (int(year), int(month), int(day), int(hour), int(minute), int(second), 0, 0, 0)

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


def get_update_time_from_feed(feed_url):
    feedparser.registerDateHandler(myDateHandler)
    feed = feedparser.parse(feed_url)

    update_time = ''
    if len(feed.entries) > 0:
        one = feed.entries[0]
        if 'published_parsed' in one:
            update_time = time_as_string(feed.entries[0].published_parsed)
        elif 'updated_parsed' in one:
            update_time = time_as_string(feed.entries[0].updated_parsed)
    return update_time


def all_feeds():
    return Bookmark.objects.filter(aspect__tag='blog', aspect__domain__tag='ios').order_by('-zindex', 'created_at')
    # return Bookmark.objects.filter( ~Q(feed_url='') | ~Q(spider='') ).order_by('-zindex', 'created_at')


def export_markdown():
    f = local_markdown_open('README.md')

    f.write('# 番茄阅读 - 专注于精选 iOS/OS X 开发者博客\n\n')
    f.write('[AppStore地址](https://itunes.apple.com/us/app/id1111654149)\n\n')
    f.write('[开发总结](https://everettjf.github.io/2016/05/13/how-to-write-a-simple-feed-reader)\n\n')

    f.write('\n\n')
    f.write('- 感谢 [tangqiaoboy](https://github.com/tangqiaoboy/iOSBlogCN) 提供基础数据,我在此基础上进行了较多的增删.'
            ' 且不同之处在于,我会主动收集选择博客,并根据博客文章的质量随时增减.\n')
    f.write('- 此列表大约每天更新一次\n')
    f.write('- 按最后更新时间倒序排列\n')
    f.write('- Feed列说明: `feed` 支持RSS/Atom ; `jianshu` 简书 ; `空白` 不支持RSS/Atom且暂不支持爬取.\n')

    f.write('\n\n---\n\n')
    feeds = all_feeds()

    f.write('Blog (%d) | Feed | Update Time\n' % len(feeds))
    f.write('-----|------|-----\n')

    items = []
    for link in feeds:
        update_time = ''

        name = link.name.replace('|', ' ')

        start = time.time()
        if link.feed_url != '':
            # Feed
            spider = 'feed'
            spider_url = link.feed_url
            update_time = get_update_time_from_feed(spider_url)
        elif link.spider != '':
            # Spider
            spider = link.spider
            spider_url = 'https://everettjf.github.io/app/blogreader/spider/%s/%d.json' %(spider, link.id)
            update_time = get_update_time_string(spider, link.id)
        else:
            # No spider and no feed
            spider = ''
            spider_url = ''
        end = time.time()

        print('(%d)%s[%s](%s) | %s ' % (math.ceil(end-start),update_time,name, spider_url, spider))

        # f.write('[%s](%s) | %s | %s \n' % (name, link.url, spider, update_time))
        items.append({
            'name': name,
            'url': link.url,
            'spider': spider,
            'spider_url': spider_url,
            'update_time': update_time,
        })
    items = sorted(items, key=lambda item: item['update_time'], reverse=True)
    for item in items:
        f.write('[%s](%s) | [%s](%s) | %s \n' % (
            item['name'],
            item['url'],
            item['spider'],
            item['spider_url'],
            item['update_time'],
        ))

    print('finished')
    f.write('---\n\n')
    f.write('Updated at %s'% datetime.datetime.now().isoformat())
    f.write('\n\n')

    f.close()



########################################################
if __name__ == '__main__':
    export_markdown()

