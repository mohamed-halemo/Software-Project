from .models import *
from .models import commentss
from .serializer import *
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from django.http import Http404, response
from rest_framework import status
from django.core.paginator import Paginator
from rest_framework.pagination import PageNumberPagination
from django.shortcuts import render
from django import forms
from rest_framework import viewsets
from django.db.models import Count
from rest_framework.permissions import IsAuthenticated
from project.permissions import IsOwner
from django.contrib.auth.decorators import permission_required
from django.core.exceptions import ObjectDoesNotExist
from photo.models import *
from photo.serializers import *

class RespondPagination(PageNumberPagination):
    page_size = 1
    page_size_query_param = 'page_size'
    max_page_size = 1


@api_view(['GET'])
def set_lists(request):
    try:
   
        all_sets = sets.objects.all().get()
    except ObjectDoesNotExist:
        
        return Response(status=status.HTTP_404_NOT_FOUND)
    photosets = sets_serializer(all_sets, many=True).data 
    return Response({'photosets': photosets})

@api_view(['GET'])
#   getting the list of photosets of a given user
def get_lists(request, id):
    try:

        get_list = sets.objects.all().filter(owner_id=id).order_by('-date_create')
        
    except ObjectDoesNotExist:
        
        return Response(status=status.HTTP_404_NOT_FOUND)

    #  for pagination
    Paginator = RespondPagination()
    results = Paginator.paginate_queryset(get_list, request)
    photosets = sets_serializer(results, many=True).data
    return Paginator.get_paginated_response({'photosets': photosets})


@api_view(['GET'])  
#     get information about a given photoset
def get_information(request, id):
    try:

        get_list = sets.objects.get(id=id)
        
    except ObjectDoesNotExist:
        
        return Response(status=status.HTTP_404_NOT_FOUND)
    set = sets_serializer(get_list).data
    
      
    return Response({'photoset': set}, status=status.HTTP_200_OK)


@api_view(['POST'])   
@permission_classes((IsAuthenticated,))
#adding a photoset by a user and setting its primary photo
def create_set(request, photo_id):
    try:
        get_photo = Photo.objects.get(id=photo_id)       
    except :
        return Response(status=status.HTTP_404_NOT_FOUND)
    if request.method == 'POST':
        try:
            sets_obj=sets.objects.create(title=request.data['title'],
                                            description=request.data['description'],
                                            owner=request.user
                                    )
            
        except:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        serializer = sets_serializer_post(sets_obj, data=request.data)
        
        if serializer.is_valid():
            
            serializer.save(primary=photo_id)
              
            get_photo.sets_photos.add(sets_obj)
            
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
@permission_classes((IsAuthenticated,))
# deleting a given photoset
def delete_set(request, id):
    try:
        get_list = sets.objects.get(id=id)
        if (get_list.owner != request.user):
            return Response(
                 {'stat': 'fail',
                  'message': 'User does not have permission to delete'
                             '  this photoset'},
                 status=status.HTTP_403_FORBIDDEN)
        get_list.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    except:
        return Response(status=status.HTTP_404_NOT_FOUND)

@api_view(['PUT'])
@permission_classes((IsAuthenticated,))
#     edit metadata of a given photoset
def edit_meta(request, id):
    try:
        get_list = sets.objects.get(id=id)
        if (get_list.owner != request.user):
            return Response(
                 {'stat': 'fail',
                  'message': 'User does not have permission to delete'
                             '  this photoset'},
                 status=status.HTTP_403_FORBIDDEN)
        if request.method == 'PUT':
            serializer = sets_serializer_post(get_list, data=request.data)
            if serializer.is_valid():
                
                serializer.save()
            
                return Response(serializer.data, status=status.HTTP_200_OK)
            
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except:
        return Response(status=status.HTTP_404_NOT_FOUND)

@api_view(['POST'])
@permission_classes((IsAuthenticated,))
#   adding a comment to a given photoset
def create_comment(request, id):
    try:
        get_list = sets.objects.get(id=id)
        if (get_list.owner != request.user):
            return Response(
                 {'stat': 'fail',
                  'message': 'User does not have permission to add'
                             '  comment'},
                 status=status.HTTP_403_FORBIDDEN)
        if request.method == 'POST':
            serializer = comments_serializer_post(data=request.data)
            if serializer.is_valid():
                serializer.save(sets=get_list, owner=request.user)
                get_list.count_comments += 1
                get_list.save()
                return Response(serializer.data,
                                status=status.HTTP_201_CREATED)
            return Response(serializer.errors, 
                            status=status.HTTP_400_BAD_REQUEST)
    except:
        return Response(status=status.HTTP_404_NOT_FOUND)

@api_view(['DELETE'])
@permission_classes((IsAuthenticated,))
#   deleting a given comment
def delete_comment(request, comment_id, set_id):
    try:
        get_list = sets.objects.get(id=set_id)
    except:
        return Response(status=status.HTTP_404_NOT_FOUND)
    try:
        get_comment=get_list.comment.get(id=comment_id)

    except:
        return Response(status=status.HTTP_404_NOT_FOUND)
    if (get_list.owner != request.user):
        return Response(
                {'stat': 'fail',
                'message': 'User does not have permission to delete'
                            '  this comment'},
                status=status.HTTP_403_FORBIDDEN)
            
    get_comment.delete()
    get_list.count_comments -= 1
    get_list.save()   
    return Response(status=status.HTTP_204_NO_CONTENT)


@api_view(['PUT'])
#    editing a given comment
@permission_classes((IsAuthenticated,))
def edit_comment(request, set_id, comment_id):
    try:
        get_list = sets.objects.get(id=set_id)
    except:
        return Response(status=status.HTTP_404_NOT_FOUND)
    try:
        get_comment=get_list.comment.get(id=comment_id)

    except:
        return Response(status=status.HTTP_404_NOT_FOUND)
    if (get_list.owner != request.user):
        return Response(
                {'stat': 'fail',
                'message': 'User does not have permission to delete'
                            '  this comment'},
                status=status.HTTP_403_FORBIDDEN)
    if request.method == 'PUT':
        
        serializer = comments_serializer_post(get_comment, data=request.data)            
        
        if serializer.is_valid():
            
            serializer.save()
            
            return Response(serializer.data, status=status.HTTP_200_OK)
            
        return Response(serializer.errors, 
                        status=status.HTTP_400_BAD_REQUEST)
    
    

@api_view(['GET'])
#    get comments list on a given photoset
def get_comments_list(request, id):
    try:
        
        get_list = sets.objects.get(id=id)
        
    except:
    
        return Response(status=status.HTTP_404_NOT_FOUND)    
    set_list = get_list.comment.all()
    
    comments = comments_serializer(set_list, many=True).data
    if comments == []:
        return Response({'stat': 'fail',
                    'message': 'no comments'},status=status.HTTP_400_BAD_REQUEST)
      
    return Response({'comments': comments}, status=status.HTTP_200_OK)



@api_view(['POST','DELETE'])  
#     add and delete a given photo to a given photoset
@permission_classes((IsAuthenticated,))
def photo(request, set_id, photo_id):
    try:
        get_list = sets.objects.get(id=set_id)
        
        if (get_list.owner != request.user):
            return Response(
                 {'stat': 'fail',
                  'message': 'User does not have permission to add photo to '
                             '  this photoset'},
                 status=status.HTTP_403_FORBIDDEN)
    except :
        
        return Response(status=status.HTTP_404_NOT_FOUND)
        

    try:
        get_photo = Photo.objects.get(id=photo_id)
        

    except :
        
        return Response(status=status.HTTP_404_NOT_FOUND)
    if request.method == 'POST':
        photos= get_list.photos.all()
        if get_photo in photos:
            

            return Response(
                    {'stat': 'fail',
                    'message': 'photo already exists'},
                    status=status.HTTP_403_FORBIDDEN)
        
        
        else:
            get_photo.sets_photos.add(get_list)
           
            
            get_list.count_photos += 1
            
            
            get_list.save()
        return Response( status=status.HTTP_200_OK)

    if request.method == 'DELETE':
        try:
            deleted_photo=get_list.photos.get(id=photo_id)
        except ObjectDoesNotExist:
            return Response(
                    {'stat': 'fail',
                    'message': 'photo does not exist'},
                    status=status.HTTP_403_FORBIDDEN)
        
        get_photo.sets_photos.remove(get_list)
        
       
        get_list.count_photos -= 1
        
        get_list.save()
        return Response( status=status.HTTP_200_OK)

@api_view(['GET'])  
#     get photos in a given photoset
def get_photos(request, set_id):
    try:
        
        get_list = sets.objects.get(id=set_id)
        
    except:
    
        return Response(status=status.HTTP_404_NOT_FOUND)    
    set_list = get_list.photos.all().order_by('-date_posted')
    photos = PhotoMetaSerializer(set_list, many=True).data
    if photos == []:
        return Response({'stat': 'fail',
                    'message': 'no photos'},status=status.HTTP_400_BAD_REQUEST)
      
    return Response({'photos': photos}, status=status.HTTP_200_OK)

@api_view(['GET'])
def photo_sets(request, photo_id):
    #     get the photosets that a given photo belongs to
    try:
        photo_obj = Photo.objects.get(id=photo_id)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    # GET
    if request.method == 'GET':
        sets = photo_obj.sets_photos.all()
        serializer = sets_serializer(sets, many=True)
        return Response(serializer.data)


@api_view(['GET'])
def search(request):
    # search for a set by its title ordered from the oldest
    value = request.query_params.get("title")
    Sets = sets.objects.filter(title__icontains=value)\
        .order_by('-date_create')
    serializer = sets_serializer(Sets, many=True)
    return Response(serializer.data)
