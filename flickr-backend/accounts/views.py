from django.http.response import Http404
from django.http import request
from rest_framework import generics, status, views
from django.shortcuts import render, redirect
from .serializers import *
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from accounts.models import *
from project.utils import Util
from django.contrib.sites.shortcuts import get_current_site
from django.urls import reverse
import jwt
from django.conf import settings
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.utils.encoding import smart_str, force_str, smart_bytes
from django.utils.encoding import DjangoUnicodeDecodeError
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from django.contrib.sites.shortcuts import get_current_site
from django.urls import reverse
from project.utils import Util
from rest_framework import permissions,viewsets
from project.permissions import IsOwner
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view, permission_classes
from rest_framework import status
from rest_framework.parsers import MultiPartParser, FormParser
from django.core.exceptions import ObjectDoesNotExist
from rest_framework.pagination import PageNumberPagination

# push notifications
import requests
import json

#Functionality
def verifying_user(user):
    if not user.is_verified:
        user.is_verified = True
        user.save()
    
def prepare_verify_email(current_site,user,token):
    relative_link = reverse('accounts:email-verify')
    absurl = 'http://'+current_site+relative_link+"?token="+str(token)
    email_body = 'Hi ' + user.username + ' Use link to verify \n' + absurl
    data = {'email_body': email_body,
            'to_email': user.email,
            'email_subject': 'Verify Your Email'}
    return data

def prepare_reset_password_email(current_site,user,token,uidb64):
    relative_link = reverse('accounts:password-reset-confirm',
                            kwargs={'uidb64': uidb64, 'token': token})
    absurl = 'http://'+current_site+relative_link
    email_body = 'Hello,\n Use link below to reset your password  \n' + absurl
    data = {'email_body': email_body, 'to_email': user.email,
            'email_subject': 'Reset you password'}
    return data

def check_account_exist_email(email):
    bool = Account.objects.filter(email=email).exists()
    if bool:
        error=''
    else:
        error= 'Email doesnt exist. Kindly recheck entered email'
    return bool,error

def change_to_pro(user):
    user.is_pro =True
    user.save()

def change_to_normal(user):
    user.is_pro =False
    user.save()
    
def check_pro(user):
    return user.is_pro

def delete_user(user):
    user.delete()

def change_user_password(serializer,user):
    # Check the old password
        if not user.check_password(serializer.data.get('old_password')):
            response = {"old_password": ["Wrong password."]}
            statuss = status.HTTP_400_BAD_REQUEST
            return response, statuss
        
        # Change to the new password
        if serializer.data.get('old_password') == serializer.data.get('new_password'):
            raise serializers.ValidationError('New password cannot be same as old one!')
        
        #validate new password
        password,error=validate_password(serializer.data.get('new_password'),user.username)
        if len(password)==0:
            raise serializers.ValidationError(error)
        user.set_password(serializer.data.get('new_password'))
        user.save()
        response = {
            'status': 'success',
            'message': 'Password updated successfully',
        }
        statuss = status.HTTP_200_OK
        return response,statuss

def change_user_name(serializer,user):
    username,error = validate_username(serializer.data['username'])
    if len(username)==0:
        raise serializers.ValidationError(error)
    user.username = username
    try:
        user.save()
    except:
        response = {'Success': 'Username taken!'}
        return response
        
    response = {'Success': 'Username changed'}
    return response


def limit_people_number(people, max_limit):

    required_people_ids_list = []
    count = 1
    for people1 in people:
        if count <= max_limit:
            required_people_ids_list.append(people1.id)
            count += 1

    required_people = Account.objects.filter(
        id__in=required_people_ids_list).order_by('-date_joined')
    return required_people


#sign up user
class SignUpView(generics.GenericAPIView):
    serializer_class = SignUpSerializer
    
    #POST for user signing up
    def post(self, request):
        user = request.data
        serializer = self.serializer_class(data=user)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        user_data = serializer.data
        
        #Setting email message
        user = Account.objects.get(email=user_data['email'])
        token = RefreshToken.for_user(user).access_token
        print(request.data)
        current_site = get_current_site(request).domain

        email = prepare_verify_email(current_site,user,token)
        
        #sending mail
        Util.send_email(email)
        
        return Response(user_data, status=status.HTTP_201_CREATED)

#Resend mail
class ResendMailView(generics.GenericAPIView):
    serializer_class = ResendMailSerializer

    #POST for user signing up
    def post(self, request):
        user = request.data
        serializer = self.serializer_class(data=user)
        serializer.is_valid(raise_exception=True)
        try:
            serializer.save()
        except Exception as e:
            print(e)
        user_data = serializer.data
        
        #Setting email message
        try:
            user = Account.objects.get(email=user_data['email'])
        except:
            raise Http404
        token = RefreshToken.for_user(user).access_token
        current_site = get_current_site(request).domain

        email = prepare_verify_email(current_site,user,token)
        
        #sending mail
        Util.send_email(email)
        
        return Response({'Success' : 'Email resend !'}, status=status.HTTP_201_CREATED)




#Verify email
class VerifyEmail(views.APIView):
    serializer_class = EmailVerificationSerializer
    token_param_config = openapi.Parameter(
        'token', in_=openapi.IN_QUERY, description='Description',
        type=openapi.TYPE_STRING)


    #GET 
    @swagger_auto_schema(manual_parameters=[token_param_config])
    def get(self, request):
        token = request.GET.get('token')
        try:
            #decode token to check for the user
            payload = jwt.decode(token, settings.SECRET_KEY,
                                 algorithms=["HS256"])
            
            #extracting user id from token
            user = Account.objects.get(id=payload['user_id'])
            verifying_user(user)
            return Response({'email': 'Succesfully activated'},
                    status=status.HTTP_200_OK)
        except jwt.ExpiredSignatureError as identifier:
            return Response({'error': 'Activation Expired'},
                            status=status.HTTP_400_BAD_REQUEST)
        except jwt.exceptions.DecodeError as identifier:
            return Response({'error': 'Invalid Token'},
                            status=status.HTTP_400_BAD_REQUEST)


#User login
class LoginView(generics.GenericAPIView):
    serializer_class = LogInSerializer

    #POST
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


#Reset password mail
class RequestPasswordResetEmail(generics.GenericAPIView):
    serializer_class = RequestPasswordResetEmailSerializer
    
    #POST
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        email = request.data.get('email', '')
        bool,error = check_account_exist_email(email)        
        if bool:
            user = Account.objects.get(email=email)
            
            #encode user id
            uidb64 = urlsafe_base64_encode(smart_bytes(user.id))
            
            #create token
            token = PasswordResetTokenGenerator().make_token(user)

            #preparing mail
            current_site = get_current_site(request=request).domain

            email = prepare_reset_password_email(current_site,user,token,uidb64)

            #sending mail
            Util.send_email(email)

            return Response({'Success':
                            'We have sent you a link to reset password'},
                            status=status.HTTP_200_OK)
        else:
            return Response({'error': error}, status=status.HTTP_404_NOT_FOUND)


#Reset password mail
class PasswordTokenCheck(generics.GenericAPIView):
    serializer_class = PasswordTokenCheckSerializer

    def get(self, request, uidb64, token):
        try:
            #decoding token            
            id = smart_str(urlsafe_base64_decode(uidb64))
            user = Account.objects.get(id=id)

            #validate token
            if not PasswordResetTokenGenerator().check_token(user, token):
                return Response({'error': 'Invalid Token, Request a new one'},
                                status=status.HTTP_401_UNAUTHORIZED)

            return Response({'success': True, 'message': 'Credential Valid',
                             'uidb64': uidb64, 'token': token},
                            status=status.HTTP_200_OK)
            # check that the user havent used token twice
        except DjangoUnicodeDecodeError as identifier:
            return Response({'error': 'Invalid Token, Request a new one'},
                            status=status.HTTP_401_UNAUTHORIZED)

#Setting password (from reset mail)
class SetNewPassword(generics.GenericAPIView):
    serializer_class = SetNewPasswordSerializer
    #PUT
    def put(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response({'Success': True, 'message': 'Password Reset Success'},
                        status=status.HTTP_200_OK)

#change account password
class ChangePassword(generics.GenericAPIView):
    serializer_class = ChangePasswordSerializer
    permission_classes = (permissions.IsAuthenticated, IsOwner,)
    
    #PUT
    def put(self, request, *args, **kwargs):
        user = self.request.user
        serializer = self.serializer_class(data=request.data)
        
        if serializer.is_valid(raise_exception=True):
            response,statuss = change_user_password(serializer,user)
            return Response(response, status=statuss)
            
            

#change user type
class ChangeToPro(generics.GenericAPIView):
    serializer_class = ChangeToPro
    permission_classes = (permissions.IsAuthenticated,)
    
    #PUT
    def put(self, request):
        user = self.request.user
        serializer = self.serializer_class(data=request.data)
    
        if serializer.is_valid(raise_exception=True):
            
            #Validate user input
            if check_pro(user) and serializer.data['is_pro'] == True:
                return Response({'status': 'failed',
                                'message': 'User already a pro!'}, status = status.HTTP_400_BAD_REQUEST)    
            elif check_pro(user) and serializer.data['is_pro'] == False:
                change_to_normal(user)
                response = {
                    'status': 'success',
                    'message': 'Returned back to normal!',
                }
                return Response(response, status = status.HTTP_200_OK)
            elif not check_pro(user) and serializer.data['is_pro'] == True:
                change_to_pro(user)
                response = {
                    'status': 'success',
                    'message': 'Changed to Pro!',
                }
                return Response(response, status = status.HTTP_200_OK)
            elif not check_pro(user) and serializer.data['is_pro'] == False:
                response = {
                    'status': 'failed',
                    'message': 'User already normal!',
                }
                return Response(response, status = status.HTTP_200_OK)

#change user username
class ChangeUsername(generics.GenericAPIView):
    serializer_class = ChangeUsernameSerializer
    permission_classes = (permissions.IsAuthenticated,)
    
    #PUT
    def put(self, request):
        user = self.request.user
        serializer = self.serializer_class(data=request.data)
    
        if serializer.is_valid(raise_exception=True):
            response = change_user_name(serializer,user)
            return Response(response)
#get user info
class UserInfo(generics.RetrieveAPIView):
    
    serializer_class = OwnerSerializer       
    permission_classes = (permissions.IsAuthenticated,)
    queryset = Account.objects.all()
    
    #override get object to get logged in user
    def get_object(self):
        queryset = self.filter_queryset(self.get_queryset())
        obj = queryset.get(id=self.request.user.id)
        return obj

class UserDetailList(generics.RetrieveAPIView):
    serializer_class = OwnerSerializer
    permission_classes = (permissions.IsAuthenticated,)
    queryset = Account.objects.all()
    lookup_field = 'id'

#Resend Reset password mail
class ResendPasswordResetEmail(generics.GenericAPIView):
    serializer_class = ResendPasswordResetEmailSerializer
    
    #POST
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        email = request.data.get('email', '')
        bool,error = check_account_exist_email(email)        
        if bool:
            user = Account.objects.get(email=email)
            
            #encode user id
            uidb64 = urlsafe_base64_encode(smart_bytes(user.id))
            
            #create token
            token = PasswordResetTokenGenerator().make_token(user)

            #preparing mail
            current_site = get_current_site(request=request).domain

            email = prepare_reset_password_email(current_site,user,token,uidb64)

            print(email)
            #sending mail
            Util.send_email(email)

            return Response({'Success':
                            'We have sent you a link to reset password'},
                            status=status.HTTP_200_OK)
        else:
            return Response({'error': error}, status=status.HTTP_404_NOT_FOUND)

#Delete users account
@api_view(['DELETE'])
@permission_classes((IsAuthenticated,))
def DeleteAccount(request):
    user = request.user
    try:
        userpassword=request.data['password']
    except:
        return Response({'stat': 'Failed', "message":'Please enter your password'}, status=status.HTTP_200_OK)
    user=auth.authenticate(email=user.email, password=userpassword)
    if not user:
        return Response(
            {'stat': 'incorrect password'},status=status.HTTP_400_BAD_REQUEST)
    user.delete()
    return Response({'stat': 'ok'}, status=status.HTTP_200_OK)

@api_view(['PUT'])
@permission_classes((IsAuthenticated,))
def upload_profile(request):
    try:
        user=request.user
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    if request.method == 'PUT':
        parser_classes = (MultiPartParser, FormParser)
        serializer = PhotoUserSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        else:
            return Response(
                serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
@permission_classes((IsAuthenticated,))
def upload_cover(request):
    try:
        user=request.user
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    if request.method == 'PUT':
        parser_classes = (MultiPartParser, FormParser)
        serializer = CoverUserSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
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
        user=request.user
        # increment the count of following for the calling user
        # and the count of followers for the given user by 1
        user.following_count += 1
        user.save()
        followed_user_obj.followers_count += 1
        followed_user_obj.save()

        # # push notification
        header = {"Content-Type": "application/json; charset=utf-8",
                  "Authorization": "Basic MzIwM2IwZTQtN2U1MS00YzFkLWFhZGUtMjIzYzQ3NzNhMDc3"}

        payload = {"app_id": "494522f0-cedd-4d54-b99b-c12ac52f66a6",
                   "include_player_ids": ["dac726e1-3b56-48ce-b9a2-e6b6731c0883"],
                   "contents": {"en": str(request.user.first_name + " " + request.user.last_name + " is now following you!")}}

        req = requests.post("https://app.onesignal.com/api/v1/notifications",
                            headers=header, data=json.dumps(payload))
        # print(req.status_code, req.reason)

        return Response(status=status.HTTP_200_OK)
    # DELETE
    if request.method == 'DELETE':
        if not contact:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        user=request.user
        # decrement the count of following for the calling user
        # and the count of followers for the given user by 1
        user.following_count -= 1
        user.save()
        followed_user_obj.followers_count -= 1
        followed_user_obj.save()
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


@api_view(['GET'])
def search(request):
    paginator = PageNumberPagination()
    paginator.page_size = 10

    value = request.query_params.get("username")
    people = Account.objects.all().filter(username__icontains=value)
    required_people = limit_people_number(people,500)
    result_page = paginator.paginate_queryset(required_people, request)
    all_people = OwnerSerializer(result_page, many=True).data

    if request.user.is_anonymous:
        following = []
    else:
        user = request.user
        following_list = user.follow_follower.all().filter(user__in=people)
        result_page1 = paginator.paginate_queryset(following_list, request)
        following = FollowingSerializer(result_page1, many=True).data

    return paginator.get_paginated_response({'following': following, 'all_people': all_people})


@api_view(['GET'])
def search_email(request):
    paginator = PageNumberPagination()
    paginator.page_size = 10

    value = request.query_params.get("email")
    people = Account.objects.all().filter(email=value)
    result_page = paginator.paginate_queryset(people, request)
    all_people = OwnerSerializer(result_page, many=True).data

    if request.user.is_anonymous:
        following = []
    else:
        user = request.user
        following_list = user.follow_follower.all().filter(user__in=people)
        result_page1 = paginator.paginate_queryset(following_list, request)
        following = FollowingSerializer(result_page1, many=True).data

    return paginator.get_paginated_response({'following': following, 'all_people': all_people})
