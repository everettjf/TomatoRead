# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class DomzItem(scrapy.Item):
    # define the fields for your item here like:
    title = scrapy.Field()
    link = scrapy.Field()
    desc = scrapy.Field()


class JianshuItem(scrapy.Item):
    title = scrapy.Field()
    link = scrapy.Field()
    image = scrapy.Field()
    createtime = scrapy.Field()
