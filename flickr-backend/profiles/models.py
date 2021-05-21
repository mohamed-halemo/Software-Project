from django.db import models
from accounts.models import Account
# Create your models here.


class Profile(models.Model):
    owner = models.OneToOneField(Account, on_delete=models.CASCADE)
    fav_count = models.IntegerField(default=0)
    group_count = models.IntegerField(default=0)
    tag_count = models.IntegerField(default=0)
    galleries_count = models.IntegerField(default=0)
    photosets_count = models.IntegerField(default=0)
    #photoset count

    def __str__(self):
        return self.owner.email
