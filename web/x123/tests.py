import feedparser,time
import re

def time_as_string(struct_time):
    return time.strftime('%Y-%m-%d', struct_time)


# 2016/5/15 21:33:46
_my_date_pattern = re.compile(r'(\d{4})/(\d{,2})/(\d{,2}) (\d{,2}):(\d{,2}):(\d{,2})')
def myDateHandler(aDateString):
    res = _my_date_pattern.search(aDateString)
    if res is None:
        return None
    year, month, day, hour, minute, second = res.groups()
    return (int(year), int(month), int(day), int(hour), int(minute), int(second), 0, 0, 0)

def get_update_time_from_feed(feed_url):
    feedparser.registerDateHandler(myDateHandler)
    feed = feedparser.parse(feed_url)

    for item in feed.entries:
        print('published=',item.published)
        print('published=',time_as_string(item.published_parsed))

        print('updated=',item.updated)
        print('updated=',time_as_string(item.updated_parsed))

    update_time = ''
    if len(feed.entries) > 0:
        one = feed.entries[0]
        if 'published_parsed' in one:
            update_time = time_as_string(feed.entries[0].published_parsed)
        elif 'updated_parsed' in one:
            update_time = time_as_string(feed.entries[0].updated_parsed)
    return update_time

print(get_update_time_from_feed('http://blog.csdn.net/yiyaaixuexi/rss/list'))



# d = feedparser.parse('https://everettjf.github.io/feed.xml')
#
#
# print(d)
# print(d.updated_parsed)
# print(type(d.updated_parsed))
#
# for k in d.keys():
#     print('k=',k)
#
# for post in d.entries:
#     # print('post=',post)
#     print(post.published_parsed)
#
#     # for k in post.keys():
#     #     if k =='summary':
#     #         continue
#     #     print ('    %s=%s'%(k, post[k]))
