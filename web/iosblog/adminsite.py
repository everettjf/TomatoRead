from django.contrib.admin import AdminSite


class MyAdminSite(AdminSite):
    site_header = 'iOSBlog Management'
    site_title = 'iOSBlog Management'


admin_site = MyAdminSite(name='iosblog')
