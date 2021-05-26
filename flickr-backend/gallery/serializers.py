from rest_framework import serializers
from .models import *

# Serializers define the API representation.


class GallerySerializer(serializers.ModelSerializer):
    class Meta:
        model = Gallery
        # total info for a gallery
        fields = [
            'id', 'title', 'description', 'date_create', 'date_update',
            'count_media','count_comments', 'comments',
            'owner', 'photos', 'primary_photo_id']
        extra_kwargs = {'owner': {'read_only': True}}
        depth=1

class CreateGallerySerializer(serializers.ModelSerializer):
    class Meta:
        model = Gallery
        # specific info for a gallery needed to create and edit the gallery
        fields = [
            'id', 'title', 'description', 'owner',
            'photos', 'primary_photo_id']
        extra_kwargs = {'owner': {'read_only': True}}
        depth =1

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comments
        # total info for a comment on a gallery
        fields = '__all__'
        extra_kwargs = {
            'gallery': {'read_only': True}, 'owner': {'read_only': True}}
        depth = 1