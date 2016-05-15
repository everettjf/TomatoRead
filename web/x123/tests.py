import feedparser

d = feedparser.parse('https://everettjf.github.io/feed.xml')


print(d)
print(d.updated_parsed)
print(type(d.updated_parsed))

for k in d.keys():
    print('k=',k)

for post in d.entries:
    # print('post=',post)
    print(post.published_parsed)

    # for k in post.keys():
    #     if k =='summary':
    #         continue
    #     print ('    %s=%s'%(k, post[k]))
