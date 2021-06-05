import json

from django.urls import reverse
from rest_framework.reverse import reverse as api_reverse
from django.test import TestCase, Client

from rest_framework import status
from rest_framework.test import APITestCase
from accounts.models import *
from .models import *
from .serializers import *
from .views import *
from .urls import *
from django.core.files import File

import datetime

# Create your tests here.


def create_test_user(email):
    #prepare user
    first_name = 'test2'
    last_name = 'name'
    age = '50'
    password = 'Kamel1234567'
    email = email
    Account.objects.create_user(email,first_name,last_name,age,password)
    user=Account.objects.get(email = email)
    verifying_user(user)
    return user 

class PhotoFunctionsTests(TestCase):   

    def test_get_photos_of_the_followed_people(self):    
        user=create_test_user('user@gmail.com')
        owner=create_test_user('owner@gmail.com')
        Contacts.objects.create(user=user,followed=owner)
        Photo.objects.create(media_file='api/media/123.png',photo_height=123,photo_width=22,owner=user)
        photo_obj=Photo.objects.all().first()
        following_photos,following_list_ids =get_photos_of_the_followed_people(user)
        self.assertEqual(following_photos.first(),photo_obj )    
        self.assertEqual(following_list_ids[0],1)
    
    def test_get_photos_of_the_followed_people_failure(self):    
        user=create_test_user('user2@gmail.com')
        owner=create_test_user('owner2@gmail.com')
        Contacts.objects.create(user=user,followed=owner)
        Photo.objects.create(media_file='api/media/123.png',photo_height=123,photo_width=22,owner=owner)
        following_photos,_ =get_photos_of_the_followed_people(user)
        self.assertEqual(following_photos.first(),None )    

    def test_get_photos_of_the_public_people_success(self):    
        user=create_test_user('user@gmail.com')
        owner=create_test_user('owner@gmail.com')
        Photo.objects.create(media_file='api/media/123.png',photo_height=123,photo_width=22, is_public=True, owner=owner)
        photo_obj=Photo.objects.all().first()
        public_photos = get_photos_of_public_people(user)
        self.assertEqual(public_photos.first(),photo_obj )    


    def test_get_photos_of_the_public_people_failure(self):    
        user=create_test_user('user@gmail.com')
        owner=create_test_user('owner@gmail.com')
        Contacts.objects.create(user=user,followed=owner)
        Photo.objects.create(media_file='api/media/123.png',photo_height=123,photo_width=22,owner=user)
        public_photos = get_photos_of_public_people(user)
        self.assertEqual(public_photos.first(),None )
