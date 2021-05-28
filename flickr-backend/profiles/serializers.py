from rest_framework import serializers
from .models import *
from accounts.models import *

#User info serializer
class UserSerializer(serializers.ModelSerializer):
    # owner = serializers.CharField(read_only=True)
    class Meta:
        model = Account
        exclude=("password","date_joined", "updated_at",
    "last_login", "is_verified", "is_admin", "is_active", "is_staff",
    "is_superuser", "login_from", "groups","user_permissions")

#Profile serializer
class ProfileSerializer(serializers.ModelSerializer):
    owner= UserSerializer()
    class Meta:
        model = Profile
        fields='__all__'
        
#Photo user serializer
class PhotoUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['profile_pic']

#Cover photo serializer
class CoverUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['cover_photo']

#Following serializer
class FollowingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Contacts
        fields = ['followed']
        depth= 1

#Follower serializer
class FollowerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Contacts
        fields = ['user']   
        depth= 1