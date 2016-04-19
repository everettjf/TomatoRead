from .models import Domain, Aspect, Angle, Bookmark
from django.contrib.admin import ModelAdmin
from iosblog.adminsite import admin_site


class DomainAdmin(ModelAdmin):
    list_display = ('name', 'description', 'zindex')


class AspectAdmin(ModelAdmin):
    list_display = ('name', 'description', 'zindex')


class AngleAdmin(ModelAdmin):
    list_display = ('name', 'description', 'zindex')


class BookmarkAdmin(ModelAdmin):
    list_display = ('name', 'url', 'feed_url')


admin_site.register(Domain, DomainAdmin)
admin_site.register(Aspect, AspectAdmin)
admin_site.register(Angle, AngleAdmin)
admin_site.register(Bookmark, BookmarkAdmin)

