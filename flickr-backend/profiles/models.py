from django.db import models
from accounts.models import Account
# Create your models here.


class Profile(models.Model):
    owner = models.OneToOneField(Account, on_delete=models.CASCADE)
    total_media= models.IntegerField(default=0)
    fav_count = models.IntegerField(default=0)
    group_count = models.IntegerField(default=0)
    tag_count = models.IntegerField(default=0)
    galleries_count = models.IntegerField(default=0)
    photosets_count = models.IntegerField(default=0)
    profile_pic = models.ImageField(upload_to="images/",null=True , blank=True)
    cover_photo= models.ImageField(upload_to="images/",null=True , blank=True)
    followers_count = models.IntegerField(default=0, null=True)
    following_count = models.IntegerField(default=0, null=True)
    
    def __str__(self):
        return self.owner.email

class Contacts(models.Model):
    user = models.ForeignKey(Account, related_name='follow_follower', on_delete=models.CASCADE, editable=False)
    followed = models.ForeignKey(Account, related_name='follow_followed', on_delete=models.CASCADE)
    date_create = models.DateTimeField(auto_now_add=True)