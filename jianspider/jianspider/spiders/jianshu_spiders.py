import scrapy
from jianspider.items import JianshuItem
import json
import codecs
import datetime

import os

def is_in_production():
    if 'IOSBLOGRUNMODE' in os.environ:
        RUNMODE = os.environ['IOSBLOGRUNMODE']
    else:
        RUNMODE = 'develop'

    return RUNMODE == 'production'

if is_in_production():
    target_json_dir = '/root/everettjf.github.com/app/blogreader/'
    target_markdown_dir = '/root/iOSBlog/'
else:
    target_json_dir = '/Users/everettjf/GitHub/everettjf.github.com/app/blogreader/'
    target_markdown_dir = '/Users/everettjf/GitHub/iOSBlog/'


def feeds_json_path():
    return os.path.join(target_json_dir ,'1_feeds.json')


def local_dump(obj, f):
    json.dump(obj, f, indent=4, ensure_ascii=False, sort_keys=True)

class JianshuSpider(scrapy.Spider):
    name = "jianshu"
    allowed_domains = ['jianshu.com']
    start_urls = []
    url_to_oid = {}

    def __init__(self):
        f = codecs.open(feeds_json_path(),'r',encoding='utf-8')
        feeds = json.load(f)['feeds']
        f.close()

        self.start_urls = []
        for link in feeds:
            if link['spider'] == 'jianshu':
                self.start_urls.append(link['url'])
                self.url_to_oid[link['url']] = link['id']

        print self.start_urls

    def parse(self, response):
        print response.url
        oid = self.url_to_oid[response.url]
        filepath = os.path.join(target_json_dir,'spider', 'jianshu', '%d.json'%oid)
        print filepath

        items = []
        for post in response.xpath('//div[@id="list-container"]/ul/li'):
            url = post.xpath('div/h4[@class="title"]/a/@href').extract_first()
            url = response.urljoin(url)

            title = post.xpath('div/h4[@class="title"]/a/text()').extract_first()
            title = title.strip()

            item = {}
            item['title'] = title
            item['link'] = url
            item['createtime'] = post.xpath('div/p[@class="list-top"]/span[@class="time"]/@data-shared-at').extract_first()
            item['image'] = post.xpath('a[@class="wrap-img"]/img/@src').extract_first()
            items.append(item)

        f = codecs.open(filepath,'w+',encoding='utf-8')
        local_dump({
            'posts': items,
            'updated_at': datetime.datetime.now().isoformat()
        }, f)





