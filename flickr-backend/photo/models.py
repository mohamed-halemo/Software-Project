from django.db import models
from accounts.models import *
from django.utils import timezone
import os

# Can be removed until upload() is implemented

def upload_to(instance, filename):
    now = timezone.now()
    base, extension = os.path.splitext(filename.lower())
    milliseconds = now.microsecond // 1000
    return f"{now:%Y%m%d%H%M%S}{milliseconds}{extension}"


# Create your models here.
class Photo(models.Model):
    
    # Owner (relation)
    owner = models.ForeignKey(Account, on_delete=models.CASCADE,
                              related_name='user_photos')

    # Meta Data
    title = models.CharField(max_length=300, blank=True)
    description = models.TextField(max_length=2000, blank=True)

    # Visibility & Privacy
    is_public = models.BooleanField(default=True)

    # Permissions
    PERMISSIONS = (
     ('Only The Owner', 'Only The Owner'),
     ('People You Follow', 'People You Follow'),
     ('Any Flickr Member', 'Any Flickr Member'),
    )
    can_comment = models.CharField(max_length=25, choices=PERMISSIONS, default='Any Flickr Member')
    can_addmeta = models.CharField(max_length=25, choices=PERMISSIONS, default='Any Flickr Member')

    # Comments & Notes
    count_comments = models.PositiveIntegerField(default=0)
    count_notes = models.PositiveIntegerField(default=0)

    # Tags & People Tagged Info
    count_tags = models.PositiveIntegerField(default=0)
    count_people_tagged = models.PositiveIntegerField(default=0)

    # Faves Fields
    count_favourites = models.PositiveIntegerField(default=0)
    is_faved = models.BooleanField(default=False)
    favourites = models.ManyToManyField(
        Account, related_name='post_favourite', blank=True)

    # Dates
    date_posted = models.DateTimeField(auto_now_add=True)
    date_taken = models.DateTimeField(blank=True)
    last_update = models.DateTimeField(auto_now=True)

    # Media
    media_file = models.ImageField(upload_to=upload_to)

    # Photo Size
    photo_height = models.PositiveSmallIntegerField(blank=True)
    photo_width = models.PositiveSmallIntegerField(blank=True)
    photo_displaypx = models.PositiveSmallIntegerField()

    # Orientation
    rotated_by = models.PositiveSmallIntegerField(default=0)

    # groups
    group_count = models.PositiveIntegerField(default=0, blank=True)



class PeopleTagging(models.Model):

    # Foreign Keys
    photo = models.ForeignKey(Photo, on_delete=models.CASCADE, related_name='people_tagged')
    person_tagged = models.ForeignKey(Account, on_delete=models.CASCADE)

    # Added By
    added_by = models.ForeignKey(Account, on_delete=models.CASCADE,
                                 related_name="tagging_people_actions")



class Comment(models.Model):

    # Unique Identifier
    comment_id = models.BigAutoField(primary_key=True)

    # Author (relation)
    author = models.ForeignKey(Account, on_delete=models.CASCADE,
                               related_name='user_comments')

    # Date
    date_created = models.DateTimeField(auto_now=True)

    # Body: required
    comment_text = models.TextField(max_length=1000)

    # Photo Data (relation)
    photo = models.ForeignKey(Photo, on_delete=models.CASCADE,
                              related_name='photo_comments')


class Note(models.Model):

    # Unique Identifier
    note_id = models.BigAutoField(primary_key=True)

    # Author (relation)
    author = models.ForeignKey(Account, on_delete=models.CASCADE,
                               related_name='user_notes')

    # Dimensions: required
    left_coord = models.PositiveSmallIntegerField()
    top_coord = models.PositiveSmallIntegerField()
    note_width = models.PositiveSmallIntegerField()
    note_height = models.PositiveSmallIntegerField()

    # Body: required
    note_text = models.TextField(max_length=1000)

    # Photo Data (relation)
    photo = models.ForeignKey(Photo, on_delete=models.CASCADE,
                              related_name='photo_notes')


class Tag(models.Model):

    # Unique Identifier
    tag_id = models.BigAutoField(primary_key=True)

    # User (relation)
    author = models.ForeignKey(Account, on_delete=models.CASCADE,
                             related_name='user_tags')

    # Photo Data (relation)
    photo = models.ForeignKey(Photo, on_delete=models.CASCADE,
                              related_name='photo_tags')

    # Body: required
    tag_text = models.CharField(max_length=200)
