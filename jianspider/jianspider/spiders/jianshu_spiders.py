import scrapy
from jianspider.items import JianshuItem


class JianshuSpider(scrapy.Spider):
    name = "jianshu"
    allowed_domains = ['jianshu.com']
    start_urls = [
        "http://www.jianshu.com/users/b82d2721ba07/latest_articles"
    ]

    def parse(self, response):
        pass
