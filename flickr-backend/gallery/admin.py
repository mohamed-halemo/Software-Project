from django.contrib import admin
#   from django_mongoengine import mongo_admin as admin

# Register your models here.
from .models import gallery, Comments
#   , Photo

#   admin.site.register(Photo)

admin.site.register(gallery)
admin.site.register(Comments)

'''
from django_mongoengine import mongo_admin as admin
from .models import gallery, Comments

 #Register your models here.


class gallery_admin(admin.DocumentAdmin):
    model = gallery
    fields = ('title', 'description')


admin.site.register(gallery, gallery_admin)
admin.site.register(Comments)
'''
