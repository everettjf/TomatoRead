import scrapy
from jianspider.items import JianshuItem


class JianshuSpider(scrapy.Spider):
    name = "jianshu"
    allowed_domains = ['jianshu.com']
    start_urls = [
        "http://www.jianshu.com/users/b82d2721ba07/latest_articles"
    ]

    def parse(self, response):
        for post in response.xpath('//div[@id="list-container"]/ul/li'):
            item = JianshuItem()
            item['title'] = post.xpath('div/h4[@class="title"]/a/text()').extract_first()
            item['link'] = post.xpath('div/h4[@class="title"]/a/@href').extract_first()
            item['createtime'] = post.xpath('div/p[@class="list-top"]/span[@class="time"]/@data-shared-at').extract_first()
            item['image'] = post.xpath('a[@class="wrap-img"]/img/@src').extract_first()
            yield item

