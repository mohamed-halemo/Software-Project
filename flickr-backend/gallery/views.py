from django.core import paginator
from django.db.models import fields
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from .models import *
from photo.models import *
from profiles.models import *
from .serializers import *
from photo.serializers import *
from project.permissions import check_permission
from django.core.exceptions import ObjectDoesNotExist
from rest_framework.pagination import PageNumberPagination
from django.core.paginator import Paginator
from rest_framework.permissions import IsAuthenticated

def increment_gallery_items(obj, field):
    if field=='count_comments':
        obj.count_comments += 1 
    elif field=='count_media':
        obj.count_media += 1 
    obj.save()

def increment_profile_items(obj,field):
    if field=='galleries_count':
        obj.galleries_count += 1 
    obj.save()  

def decrement_gallery_items(obj,field):
    if field=='count_comments':
        obj.count_comments -= 1 
    elif field=='count_media':
        obj.count_media -= 1 
    obj.save()

def decrement_profile_items(obj,field):
    if field=='galleries_count':
        obj.galleries_count -= 1 
    obj.save()   

def check_photo_privacy(obj):
    return obj.is_public

def check_gallery_photos_limits(obj):
    return obj.count_media < 500  

def check_existence_of_object_in_list(obj,list):
    return obj in list
    
def set_primary_photo_id(obj , phopk):
    if obj.count_media == 0:
        obj.primary_photo_id = phopk
    obj.save()

@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes((IsAuthenticated,))
def gallery_info(request, galpk):
    # get , edit and delete a specific gallery by its id
    try:
        gallery_obj = Gallery.objects.get(id=galpk)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    #   GET
    if request.method == 'GET':
        serializer = GallerySerializer(gallery_obj)
        return Response(serializer.data)
    #   PUT
    elif request.method == 'PUT':
        bool=check_permission(request,gallery_obj)        
        if not bool :
            return Response(status=status.HTTP_403_FORBIDDEN)
        serializer = CreateGallerySerializer(gallery_obj, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    #   DELETE
    elif request.method == 'DELETE':
        bool=check_permission(request,gallery_obj)        
        if not bool :
            return Response(status=status.HTTP_403_FORBIDDEN)
        gallery_obj.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


@api_view(['GET'])
def user_galleries(request, userpk):
    # get a list of galleries of a specific user given its id
    Paginator = PageNumberPagination()
    Paginator.page_size = 20
    try:
        gallery_list = Gallery.objects.all().filter(
            owner_id=userpk).order_by('-date_create')
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    #   GET
    if request.method == 'GET':
        results = Paginator.paginate_queryset(gallery_list, request)
        galleries = GallerySerializer(results, many=True)
        return Paginator.get_paginated_response(
            galleries.data)


@api_view(['GET', 'POST'])
@permission_classes((IsAuthenticated,))
def gallery_list(request):
    # get list of galleries or create a new one
    Paginator = PageNumberPagination()
    Paginator.page_size = 20
    # GET
    if request.method == 'GET':
        gallery_list = Gallery.objects.all()
        results = Paginator.paginate_queryset(gallery_list, request)
        galleries = GallerySerializer(results, many=True)
        return Paginator.get_paginated_response(
            galleries.data)
    # POST
    elif request.method == 'POST':
        serializer = CreateGallerySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(owner=request.user)
            profile_obj = Profile.objects.get(owner=request.user)
            # increment the count of galleries in the profile of the user by 1
            increment_profile_items(profile_obj,'galleries_count')
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def find_gallery(request):
    # search for a gallery by its title ordered from the oldest
    value = request.query_params.get("title")
    try: 
        galleries = Gallery.objects.filter(title__icontains=value)\
        .order_by('-date_create')
    except:
       return Response(status=status.HTTP_404_NOT_FOUND)
            
    serializer = GallerySerializer(galleries, many=True)
    return Response(serializer.data)



@api_view(['GET', 'POST'])
def gallery_comments_list(request, galpk):
    # get list of comments or create a new one
    #  to a specific gallery given its id
    try:
        gallery_obj = Gallery.objects.get(id=galpk)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    # GET
    if request.method == 'GET':
        comments = gallery_obj.comments.all()
        serializer = CommentSerializer(comments, many=True)
        return Response(serializer.data)
    # POST
    elif request.method == 'POST':
        serializer = CommentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(
                gallery=gallery_obj, owner=request.user)
            # increment the count of comments in that gallery by 1
            # gallery_obj.count_comments += 1
            # gallery_obj.save()
            increment_gallery_items(gallery_obj, 'count_comments')

            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.data, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes((IsAuthenticated,))
def gallery_comment(request, galpk, compk):
    # get ,edit and delete a specific comment on a gallery given their ids
    try:
        gallery_obj = Gallery.objects.get(id=galpk)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    try:
        comment_obj = gallery_obj.comments.get(id=compk)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    # GET
    if request.method == 'GET':
        serializer = CommentSerializer(comment_obj)
        return Response(serializer.data)
    # PUT
    elif request.method == 'PUT':
        bool=check_permission(request,comment_obj)        
        if not bool :
            return Response(status=status.HTTP_403_FORBIDDEN)
        serializer = CommentSerializer(comment_obj, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    #   DELETE
    elif request.method == 'DELETE':
        bool=check_permission(request,comment_obj)        
        if not bool :
            return Response(status=status.HTTP_403_FORBIDDEN)
        comment_obj.delete()
        # decrement the count of comments in that gallery by 1
        # gallery_obj.count_comments -= 1
        # gallery_obj.save()
        decrement_gallery_items(comment_obj,'count_comments')
        return Response(status=status.HTTP_204_NO_CONTENT)


@api_view(['GET'])
def gallery_photos(request, galpk):
    # get the photos list in a specific gallery given the gallery id
    try:
        gallery_obj = Gallery.objects.get(id=galpk)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    # GET
    if request.method == 'GET':
        photos = gallery_obj.photos.all()
        serializer = PhotoMetaSerializer(photos, many=True)
        return Response(serializer.data)


@api_view(['GET','POST'])
@permission_classes((IsAuthenticated,))
def photo_galleries(request, phopk):
    # get the list of galleries in which
    # a specific photo is added given the photo id
    try:
        photo_obj = Photo.objects.get(id=phopk)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    # GET
    if request.method == 'GET':
        galleries = photo_obj.gallery_photos.all()
        serializer = GallerySerializer(galleries, many=True)
        return Response(serializer.data)
    # POST    
    # create gallery with primary photo
    if request.method == 'POST':
        bool=check_permission(request,photo_obj)        
        if not bool :
            gallery_obj = Gallery.objects.create(
                title=request.data['title'],
                description=request.data['description'],owner=request.user)
            set_primary_photo_id(gallery_obj,phopk)
            photo_obj.gallery_photos.add(gallery_obj)
            # gallery_obj.primary_photo_id = phopk
            # increment the count of items in that gallery by 1
            # gallery_obj.count_media += 1
            # gallery_obj.save()
            increment_gallery_items(gallery_obj,'count_media')

            profile_obj = Profile.objects.get(owner=request.user)
            # increment the count of galleries in the profile of the user by 1
            increment_profile_items(profile_obj,'galleries_count')
            return Response(status=status.HTTP_201_CREATED)
        return Response(status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST', 'DELETE'])
@permission_classes((IsAuthenticated,))
def gallery_photo(request, galpk, phopk):
    # add or remove a specific photo in a specific gallery given their ids
    try:
        gallery_obj = Gallery.objects.get(id=galpk)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    try:
        photo_obj = Photo.objects.get(id=phopk)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    photos = gallery_obj.photos.all() 
    # put a flag to see whether the photo is already in the gallery or not
    exist= check_existence_of_object_in_list(photo_obj,photos)

    # if photo_obj in photos:
    #     exist = True
    # else:
    #     exist = False
    if request.method == 'POST':
        bool=check_permission(request,gallery_obj)        
        if not bool :
            return Response(status=status.HTTP_403_FORBIDDEN)
        # can't add his own photos , the photo must be public,
        # does not exist in the gallery and
        #  there is limitation to 500 items in the gallery
        photo_owner =check_permission(request,photo_obj) 

        public_photo= check_photo_privacy(photo_obj)

        under_limit=check_gallery_photos_limits(gallery_obj)

        if ((not photo_owner) and public_photo and (not exist) and under_limit):

            photo_obj.gallery_photos.add(gallery_obj)
            # check if the gallery is empty then put the id
            # of the item added as a primary photo id for this gallery
            # if gallery_obj.count_media == 0:
            #     gallery_obj.primary_photo_id = phopk
            set_primary_photo_id(gallery_obj,phopk)
            # increment the count of items in that gallery by 1
            increment_gallery_items(gallery_obj,'count_media')
            return Response(status=status.HTTP_201_CREATED)
        return Response(status=status.HTTP_400_BAD_REQUEST)
    #   DELETE
    elif request.method == 'DELETE':
        bool=check_permission(request,gallery_obj)        
        if not bool :
            return Response(status=status.HTTP_403_FORBIDDEN)
        if exist:
            photo_obj.gallery_photos.remove(gallery_obj)
            # decrement the count of items in that gallery by 1
            decrement_gallery_items(gallery_obj,'count_media')

            # check if the gallery turned to be empty therefore
            #  set the primary photo id with null
            set_primary_photo_id(gallery_obj, None)
            # if gallery_obj.count_media == 0:
            #     gallery_obj.primary_photo_id = None
            # gallery_obj.save()
            return Response(status=status.HTTP_204_NO_CONTENT)
        return Response(status=status.HTTP_400_BAD_REQUEST)
