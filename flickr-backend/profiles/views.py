from django.shortcuts import render
from rest_framework.generics import RetrieveUpdateAPIView,RetrieveAPIView
from .serializers import *
from .models import Profile
from .models import Contacts
from rest_framework import permissions
from project.permissions import IsOwner
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.response import Response
from django.core.exceptions import ObjectDoesNotExist

# Create your views here.


class ProfileList(RetrieveUpdateAPIView):
    serializer_class = ProfileSerializer
    permission_classes = (permissions.IsAuthenticated,)
    queryset = Profile.objects.all()

    def perform_create(self, serializer):
        return serializer.save(owner=self.request.user)
    
    def get_object(self):
        queryset = self.filter_queryset(self.get_queryset())
        obj = queryset.get(owner=self.request.user)
        return obj
    


class ProfileDetailList(RetrieveAPIView):
    serializer_class = ProfileSerializer
    permission_classes = (permissions.IsAuthenticated,)
    queryset = Profile.objects.all()
    lookup_field = 'id'

@api_view(['PUT'])
@permission_classes((IsAuthenticated,))
def upload_profile(request):
    try:
        profile_obj=Profile.objects.get(owner=request.user)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    # print(profile_obj)
    if request.method == 'PUT':
        parser_classes = (MultiPartParser, FormParser)
        serializer = PhotoUserSerializer(profile_obj, data=request.data)
        # print(serializer)
        if serializer.is_valid():
            serializer.save(owner=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        else:
            return Response(
                serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
@permission_classes((IsAuthenticated,))
def upload_cover(request):
    try:
        profile_obj=Profile.objects.get(owner=request.user)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    # profile_obj=Profile.objects.get(owner=request.user)
    if request.method == 'PUT':
        parser_classes = (MultiPartParser, FormParser)
        serializer = CoverUserSerializer(profile_obj, data=request.data)
        if serializer.is_valid():
            serializer.save(owner=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        else:
            return Response(
                serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST', 'DELETE'])
@permission_classes((IsAuthenticated,))
def follow_unfollow(request, userpk):

    try:
        followed_user_obj = Account.objects.get(id=userpk)
        contact = Contacts.objects.filter(
            user=request.user, followed=followed_user_obj)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    # POST
    if request.method == 'POST':
        if contact or followed_user_obj == request.user:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        Contacts.objects.create(user=request.user, followed=followed_user_obj)
        user_profile = Profile.objects.get(owner=request.user)
        # print(user_profile)
        followed_user_profile = Profile.objects.get(owner=followed_user_obj)
        # increment the count of following for the calling user
        # and the count of followers for the given user by 1
        user_profile.following_count += 1
        user_profile.save()
        followed_user_profile.followers_count += 1
        followed_user_profile.save()
        return Response(status=status.HTTP_200_OK)
    # DELETE
    if request.method == 'DELETE':
        if not contact:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        user_profile = Profile.objects.get(owner=request.user)
        followed_user_profile = Profile.objects.get(owner=followed_user_obj)
        # decrement the count of following for the calling user
        # and the count of followers for the given user by 1
        user_profile.following_count -= 1
        user_profile.save()
        followed_user_profile.followers_count -= 1
        followed_user_profile.save()
        contact.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)        


@api_view(['GET'])
@permission_classes((IsAuthenticated,))
def followers_list(request):
    try:
        user = request.user
        followers_list = user.follow_followed.all().order_by('-date_create')
    except:
        return Response(status=status.HTTP_404_NOT_FOUND)
    serializer = FollowerSerializer(
        followers_list, many=True)
        
    return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes((IsAuthenticated,))
def following_list(request):
    try:
        user = request.user
        following_list = user.follow_follower.all().order_by('-date_create')
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    serializer = FollowingSerializer(
        following_list, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes((IsAuthenticated,))
def user_following(request, userpk):
    try:
        user = Account.objects.get(id=userpk)
        following_list = user.follow_follower.all().order_by('-date_create')
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    serializer = FollowingSerializer(
        following_list, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)               