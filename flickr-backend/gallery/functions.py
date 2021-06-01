from project.permissions import check_permission
from django.core.exceptions import ObjectDoesNotExist
from rest_framework import status
from .models import *
from photo.models import *
from accounts.models import *

def add_photo_to_gallery(user,photo_obj,gallery_obj,phopk):
    photo_owner,response =check_permission(user,photo_obj) 
    public_photo= check_photo_privacy(photo_obj)
    under_limit=check_gallery_photos_limits(gallery_obj)
    photos = gallery_obj.photos.all() 
    exist= check_existence_of_object_in_list(photo_obj,photos)
    if (photo_owner):
        response = {"photo_owner": ["Cant add your own photo."]}
        return response 

    elif not public_photo:
        response = {"privacy": ["photo must be public."]}
        return response 

    elif  exist:
        response = {"exist": ["photo already exists."]}
        return response 

    elif not under_limit:
        response = {"limit": ["max 500 photos in a gallery."]}
        return response 
    photo_obj.gallery_photos.add(gallery_obj)
    # check if the gallery is empty then put the id
    # of the item added as a primary photo id for this gallery
    set_primary_photo_id(gallery_obj,phopk)
    # increment the count of items in that gallery by 1
    increment_gallery_items(gallery_obj,'count_media')
    response= status.HTTP_201_CREATED
    return response 
    
def remove_photo_from_gallery(photo_obj,gallery_obj):
    photos = gallery_obj.photos.all() 
    exist= check_existence_of_object_in_list(photo_obj,photos)
    if exist:
        photo_obj.gallery_photos.remove(gallery_obj)
        # decrement the count of items in that gallery by 1
        decrement_gallery_items(gallery_obj,'count_media')

        # check if the gallery turned to be empty therefore
        #  set the primary photo id with null
        set_primary_photo_id(gallery_obj, None)
        response = status.HTTP_204_NO_CONTENT
    else:
        response= status.HTTP_400_BAD_REQUEST
    return response

def check_gallery_exists(galpk):
    response=''
    bool= False
    try:
        gallery_obj = Gallery.objects.get(id=galpk)
        bool= True
    except ObjectDoesNotExist:
        response = status.HTTP_404_NOT_FOUND
    return bool, response, gallery_obj  

def search_gallery(value):
    response=''
    bool= False
    try: 
        galleries = Gallery.objects.filter(title__icontains=value)\
        .order_by('-date_create')
        bool= True
    except:
       response = status.HTTP_404_NOT_FOUND
    return bool, response, galleries

def check_photo_exists(phopk):
    response=''
    bool= False
    try:
        photo_obj = Photo.objects.get(id=phopk)
        bool= True
    except ObjectDoesNotExist:
        response = status.HTTP_404_NOT_FOUND
    return bool, response, photo_obj  
    
def check_comment_exists(compk,gallery_obj):
    response=''
    bool= False
    try:
        comment_obj = gallery_obj.comments.get(id=compk)
        bool= True
    except ObjectDoesNotExist:
        response = status.HTTP_404_NOT_FOUND
    return bool, response, comment_obj  

def get_user_galleries(userpk):
    response=''
    bool= False
    try:
        gallery_list = Gallery.objects.all().filter(
            owner_id=userpk).order_by('-date_create')
        bool= True            
    except ObjectDoesNotExist:
        response =status.HTTP_404_NOT_FOUND
    return bool, response, gallery_list  

def create_gallery_with_primary_photo(title,description,owner,phopk,photo_obj):
    gallery_obj = Gallery.objects.create(
                title= title,
                description=description,owner=owner)
    set_primary_photo_id(gallery_obj,phopk)
    photo_obj.gallery_photos.add(gallery_obj)
    # increment the count of items in that gallery by 1
    increment_gallery_items(gallery_obj,'count_media')
    # increment the count of galleries in the profile of the user by 1
    increment_profile_items(owner,'galleries_count')

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