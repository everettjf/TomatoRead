from django.db import models
from django.conf import settings


class Domain(models.Model):
    name = models.CharField('名称', max_length=100, unique=True)
    tag = models.CharField('Tag', max_length=10, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    zindex = models.IntegerField('排序参考值', default=0)
    description = models.TextField('描述', default='', blank=True, null=True)
    iconfont = models.CharField('IconFont', max_length=20, default='', blank=True)

    class Meta:
        verbose_name = '一级分类'
        verbose_name_plural = '一级分类'
        ordering = ['zindex']

    def aspects(self):
        return Aspect.objects.filter(domain_id=self.id).order_by('-zindex','id')

    def __str__(self):
        return self.name


class Aspect(models.Model):
    name = models.CharField('名称', max_length=100, unique=True)
    tag = models.CharField('Tag', max_length=10, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    domain = models.ForeignKey(Domain, verbose_name='一级分类', on_delete=models.CASCADE)
    zindex = models.IntegerField('排序参考值', default=0)
    description = models.TextField('描述', default='', blank=True, null=True)
    iconfont = models.CharField('IconFont', max_length=20, default='', blank=True)

    class Meta:
        verbose_name = '二级分类'
        verbose_name_plural = '二级分类'
        ordering = ['zindex']

    def __str__(self):
        return self.name


class Angle(models.Model):
    name = models.CharField('名称', max_length=100)
    tag = models.CharField('Tag', max_length=10, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    zindex = models.IntegerField('排序参考值', default=0)
    description = models.TextField('描述', default='', blank=True, null=True)
    iconfont = models.CharField('IconFont', max_length=20, default='', blank=True)

    class Meta:
        verbose_name = '视角'
        verbose_name_plural = '视角'
        ordering = ['zindex']

    def __str__(self):
        return self.name


# bookmark (the core data)
class Bookmark(models.Model):
    name = models.CharField('名称', max_length=200)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    aspect = models.ForeignKey(Aspect, verbose_name='二级分类', on_delete=models.CASCADE)
    angle = models.ForeignKey(Angle, verbose_name='视角', on_delete=models.CASCADE, null=True, blank=True)

    url = models.TextField('网址', max_length=1000)
    description = models.TextField('描述', max_length=2000, blank=True, null=True, default='')
    favicon = models.TextField(max_length=1000, blank=True, null=True)
    image = models.ImageField('截图', upload_to='screenshots', max_length=1000, blank=True, null=True)

    feed_url = models.TextField(max_length=1000, blank=True, null=True)
    feed_type = models.SmallIntegerField(default=0)

    clicks = models.BigIntegerField('点击次数', default=0)
    zindex = models.IntegerField('排序参考值', default=0)
    region = models.IntegerField('区域', default=0)

    creator = models.ForeignKey('auth.User', related_name='bookmarks')

    # 0 site , 1 article
    content_type = models.IntegerField(default=0)

    large_icon = models.ImageField('图标', upload_to='siteicons', null=True, blank=True)

    # parser name, default blank
    spider = models.TextField('爬虫', max_length=20, blank=True, default='')


    class Meta:
        verbose_name = '网址'
        verbose_name_plural = '网址'

    def __str__(self):
        return self.name

    def display_icon(self):
        if self.large_icon is not None and str(self.large_icon) != '':
            return settings.MEDIA_URL + str(self.large_icon)
        return str(self.favicon)


