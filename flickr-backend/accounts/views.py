from profiles.models import *
from django.http import request
from rest_framework import generics, status, views
from django.shortcuts import render, redirect
from .serializers import *
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken
from accounts.models import Account
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
        current_site = get_current_site(request).domain
        relative_link = reverse('accounts:email-verify')
        absurl = 'http://'+current_site+relative_link+"?token="+str(token)
        email_body = 'Hi' + user.username + ' Use link to verify \n' + absurl
        data = {'email_body': email_body,
                'to_email': user.email,
                'email_subject': 'Verify Your Email'}
        Util.send_email(data)
        
        # Creating user profile
        Profile.objects.create(owner=user)

        return Response(user_data, status=status.HTTP_201_CREATED)


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
            if not user.is_verified:
                user.is_verified = True
                user.save()
            return Response({'email': 'Succesfully activated'},
                            status=status.HTTP_200_OK)

        except jwt.ExpiredSignatureError as identifier:
            return Response({'error': 'Activation Expired'},
                            status=status.HTTP_400_BAD_REQUEST)
        except jwt.exceptions.DecodeError as identifier:
            return Response({'error': 'Invalid Token'},
                            status=status.HTTP_400_BAD_REQUEST)


class LoginView(generics.GenericAPIView):
    serializer_class = LogInSerializer

    #POST
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response(serializer.data, status=status.HTTP_200_OK)



# class LogoutView(generics.GenericAPIView):
#     serializer_class = LogoutSerializer
#     permission_classes = (permissions.IsAuthenticated,)
    
#     #POST
#     def post(self, request):
#         serializer = self.serializer_class(data=request.data)
#         serializer.is_valid(raise_exception=True)
#         serializer.save()
#         return Response(status=status.HTTP_204_NO_CONTENT)

class RequestPasswordResetEmail(generics.GenericAPIView):
    serializer_class = RequestPasswordResetEmailSerializer
    
    #POST
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        email = request.data.get('email', '')
        if Account.objects.filter(email=email).exists():
            user = Account.objects.get(email=email)
            
            #encode user id
            uidb64 = urlsafe_base64_encode(smart_bytes(user.id))
            
            #create token
            token = PasswordResetTokenGenerator().make_token(user)
            
            #preparing mail
            current_site = get_current_site(request=request).domain
            relative_link = reverse('accounts:password-reset-confirm',
                                    kwargs={'uidb64': uidb64, 'token': token})
            absurl = 'http://'+current_site+relative_link
            email_body = 'Hello,\n Use link below to reset your password  \n' + absurl
            data = {'email_body': email_body, 'to_email': user.email,
                    'email_subject': 'Reset you password'}
            
            #sending mail
            Util.send_email(data)
            return Response({'Success':
                            'We have sent you a link to reset password'},
                            status=status.HTTP_200_OK)
        else:
            return Response({'error': 'Email doesnt exist. Kindly recheck entered email'}, status=status.HTTP_404_NOT_FOUND)


class PasswordTokenCheck(generics.GenericAPIView):
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

class SetNewPassword(generics.GenericAPIView):
    serializer_class = SetNewPasswordSerializer
    #PUT
    def put(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response({'Success': True, 'message': 'Password Reset Success'},
                        status=status.HTTP_200_OK)

class ChangePassword(generics.GenericAPIView):
    serializer_class = ChangePasswordSerializer
    permission_classes = (permissions.IsAuthenticated, IsOwner,)
    
    #PUT
    def put(self, request, *args, **kwargs):
        user = self.request.user
        serializer = self.serializer_class(data=request.data)
        
        if serializer.is_valid(raise_exception=True):
            
            # Check the old password
            if not user.check_password(serializer.data.get('old_password')):
                return Response({"old_password": ["Wrong password."]}, status=status.HTTP_400_BAD_REQUEST)
            
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
            return Response(response, status = status.HTTP_200_OK)
class ChangeToPro(generics.GenericAPIView):
    serializer_class = ChangeToPro
    permission_classes = (permissions.IsAuthenticated,)
    
    #PUT
    def put(self, request):
        user = self.request.user
        serializer = self.serializer_class(data=request.data)
    
        if serializer.is_valid(raise_exception=True):
            
            #Validate user input
            if user.is_pro and serializer.data['is_pro'] == True:
                return Response({'status': 'failed',
                                'message': 'User already a pro!'}, status = status.HTTP_400_BAD_REQUEST)    
            elif user.is_pro and serializer.data['is_pro'] == False:
                user.is_pro =False
                user.save()
                response = {
                    'status': 'success',
                    'message': 'Returned back to normal!',
                }
                return Response(response, status = status.HTTP_200_OK)
            elif not user.is_pro and serializer.data['is_pro'] == True:
                user.is_pro =True
                user.save()
                response = {
                    'status': 'success',
                    'message': 'Changed to Pro!',
                }
                return Response(response, status = status.HTTP_200_OK)
            elif not user.is_pro and serializer.data['is_pro'] == False:
                response = {
                    'status': 'failed',
                    'message': 'User already normal!',
                }
                return Response(response, status = status.HTTP_200_OK)
            
                
class UserInfo(generics.RetrieveAPIView):
    
    serializer_class = OwnerSerializer       
    permission_classes = (permissions.IsAuthenticated,)
    queryset = Account.objects.all()
    
    #override get object to get logged in user
    def get_object(self):
        queryset = self.filter_queryset(self.get_queryset())
        obj = queryset.get(id=self.request.user.id)
        return obj
    


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

    
