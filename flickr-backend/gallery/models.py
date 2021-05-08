#   from django.db import models
#   from djangotoolbox.fields import ListField, EmbeddedModelField
from djongo import models
from accounts.models import Account
'''
class Photo(models.Model):
    title = models.CharField(max_length=255, blank=True)
    file = models.FileField(upload_to='photos/')
    uploaded_at = models.DateTimeField(auto_now_add=True)
'''
# Create your models here.


class gallery(models.Model):
    owner = models.ForeignKey(
        Account, on_delete=models.CASCADE, related_name='user_galleries')

    #   photos=ManyToMany(Photo, related_name='gallery_photos')
    title = models.CharField(max_length=100,)
    description = models.TextField(max_length=1000, blank=True)
    date_create = models.DateTimeField(auto_now=True)
    date_update = models.DateTimeField(auto_now_add=True)
    count_photos = models.IntegerField(default=0)
    count_videos = models.IntegerField(default=0)
    count_total = models.IntegerField(default=0)
    count_views = models.IntegerField(default=0)
    count_comments = models.IntegerField(default=0)
    primary_photo_id = models.IntegerField(blank=True)

    ''''
    comments = ListField(EmbeddedModelField('Comment'))
    comments = models.ListField(EmbeddedDocumentField(Comment))
    comments = models.ListField(Comments, blank=True, null=True, default=[])
    '''
    @property
    def count_total(self):
        return self.count_photos + self.count_videos

    def __str__(self):
        return self.title


class Comments(models.Model):
    owner = models.ForeignKey(
        Account, on_delete=models.CASCADE, related_name='user_gallery_comments')

    content = models.TextField(max_length=1000)
    date_create = models.DateTimeField(auto_now=True)
    date_update = models.DateTimeField(auto_now_add=True)
    gallery = models.ForeignKey(
        gallery, related_name='comments', on_delete=models.CASCADE)

    def __str__(self):
        return self.content


'''
from mongoengine import Document, EmbeddedDocument, fields


class Comments(EmbeddedDocument):
    #   user
    content = fields.StringField(max_length=1000)
    date_create = fields.DateTimeField(auto_now=True)


  #  class Meta:
   #     abstract = True


class gallery(Document):
    pass
    #   user
    title = fields.StringField(max_length=100, required=True)
    description = fields.StringField(max_length=1000, blank=True)
    url = fields.URLField(blank=True)
    date_create = fields.DateTimeField(auto_now=True)
    date_update = fields.DateTimeField(auto_now_add=True)
    count_photos = fields.IntField(default=0)
    count_videos = fields.IntField(default=0)
    count_total = fields.IntField(default=0)
    count_views = fields.IntField(default=0)
    count_comments = fields.IntField(default=0)
    comment = fields.EmbeddedDocumentField(Comments)
#   photos

   # def _str_(self):
    #    return self.title

'''
