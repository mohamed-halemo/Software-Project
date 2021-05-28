from rest_framework import serializers
from .models import *
from profiles.serializers import UserSerializer



class setss_serializer(serializers.ModelSerializer):
    class Meta:
        model = sets
        fields = ['title, description']


class comments_serializer(serializers.ModelSerializer):
    owner=UserSerializer()
    class Meta:
        model = commentss
        fields = '__all__'
        extra_kwargs = {'sets': {'read_only': True},'owner': {'read_only': True}}
       # extra_kwargs = {'owner': {'read_only': True}}

class comments_serializer_post(serializers.ModelSerializer):
    
    class Meta:
        model = commentss
        fields = '__all__'
        extra_kwargs = {'sets': {'read_only': True},'owner': {'read_only': True}}
       # extra_kwargs = {'owner': {'read_only': True}}


class sets_serializer(serializers.ModelSerializer):
    # owner=UserSerializer()
    # comment=comments_serializer()
    class Meta:
        model = sets
        fields = ['id', 'title', 'description', 'date_create', 'date_update',
                  'count_videos',  'count_views', 'count_comments', 
                  'can_comment',
                  'visibility_can_see_set', 'owner', 'primary', 'secret',
                  'server',
                  'farm', 'photos', 'comment']
        #depth = 1
        extra_kwargs = {'owner': {'read_only': True}}
        #   extra_kwargs = {'comment': {'read_only': True}}

class sets_serializer_post(serializers.ModelSerializer):
    
    class Meta:
        model = sets
        fields = [ 'title', 'description', 'primary']
        #depth = 1
        extra_kwargs = {'owner': {'read_only': True}}
        #   extra_kwargs = {'comment': {'read_only': True}}