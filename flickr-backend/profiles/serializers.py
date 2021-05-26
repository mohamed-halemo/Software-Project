from rest_framework import serializers
from .models import *
from accounts.models import *

# class OwnerSerializer(serializers.ModelSerializer):
#     # owner = serializers.CharField(read_only=True)
#     class Meta:
#         model = Account
#         exclude=('email',"id","password", "age","date_joined", "updated_at",
#     "last_login", "is_verified", "is_admin", "is_active", "is_staff","is_superuser",
#     "is_pro", "auth_provider", "groups","user_permissions")

class ProfileSerializer(serializers.ModelSerializer):
    # owner= OwnerSerializer()
    class Meta:
        model = Profile
        fields='__all__'
        # depth = 1
        # exclude=('owner',)


class PhotoUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['profile_pic']


class CoverUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['cover_photo']

class FollowingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Contacts
        fields = ['followed']
        depth= 1

class FollowerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Contacts
        fields = ['user']   
        depth= 1