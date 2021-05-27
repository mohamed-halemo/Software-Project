from rest_framework import serializers
from accounts.models import Account
from django.contrib import auth
from rest_framework.exceptions import AuthenticationFailed
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.utils.encoding import smart_str, force_str, smart_bytes
from django.utils.encoding import DjangoUnicodeDecodeError
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from rest_framework_simplejwt.tokens import RefreshToken,TokenError
from project.utils import *
class SignUpSerializer(serializers.ModelSerializer):
    '''Serializer for Signing up'''
    password = serializers.CharField(max_length=16, min_length=12,
                                     write_only=True)

    class Meta:
        model = Account
        fields = ['email', 'username', 'password','first_name','last_name','age']

    def validate(self, attrs):
        password = attrs.get('password', '')
        username = attrs.get('username', '')
        age= attrs.get('age', '')
        if age == 0:
            raise serializers.ValidationError("Enter valid age")
            
        username,error1=validate_username(username)
        password,error2=validate_password(password,username)
        if len(username)==0:
            raise serializers.ValidationError(error1)
        if len(password)==0:
            raise serializers.ValidationError(error2)
        return attrs

    def create(self, validated_data):        
        return Account.objects.create_user(**validated_data)


class EmailVerificationSerializer(serializers.ModelSerializer):
    '''Serializer for Email Verification'''
    token = serializers.CharField(max_length=555)

    class Meta:
        model = Account
        fields = ['token']


class PasswordTokenCheckSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields='__all__'

class LogInSerializer(serializers.ModelSerializer):
    '''Serializer for Log in'''
    
    email = serializers.EmailField(max_length=255, min_length=6)
    password = serializers.CharField(max_length=16, min_length=12,
                                     write_only=True)
    username = serializers.CharField(max_length=255, min_length=6,
                                     read_only=True)
    tokens = serializers.CharField(max_length=68, min_length=12,
                                   read_only=True)

    class Meta:
        model = Account
        fields = ['email', 'password', 'username', 'tokens']

    def validate(self, attrs):
        email = attrs.get('email', '')
        password = attrs.get('password', '')
        email=email.lower()
        user = auth.authenticate(email=email, password=password)
        
        if not user:
            raise AuthenticationFailed('Invalid email or password.')
        if not user.is_active:
            raise AuthenticationFailed('Account disabled, contact admin')
        if not user.is_verified:
            raise AuthenticationFailed('Email is not verified')
        user.login_from = "email"
        user.save()
        return {
            'email': user.email,
            'username': user.username,
            'tokens': user.tokens
        }
        

# class LogoutSerializer(serializers.Serializer):
#     '''Serializer for Log out'''
    
#     refresh = serializers.CharField()
    
#     default_error_messages = {
#         'bad_token': ('Token is expired or invalid')
#     }
#     def validate(self, attrs):
#         self.token = attrs['refresh']
#         return attrs
    
#     def save(self, **kwargs):
#         try:
#             RefreshToken(self.token).blacklist()
#         except TokenError:
#             self.fail('bad_token')
            

class RequestPasswordResetEmailSerializer(serializers.Serializer):
    '''Serializer for Reset Password'''
    
    email = serializers.EmailField(min_length=2)

    class Meta:
        fields = ['email']


class SetNewPasswordSerializer(serializers.Serializer):
    '''Serializer for setting new password after password reset'''
    
    password = serializers.CharField(min_length=12, write_only=True)
    token = serializers.CharField(min_length=1, write_only=True)
    uidb64 = serializers.CharField(min_length=1, write_only=True)

    class Meta:
        fields = ['password', 'token', 'uidb64']

    def validate(self, attrs):
        password = attrs.get('password')
        token = attrs.get('token')
        uidb64 = attrs.get('uidb64')

        id = force_str(urlsafe_base64_decode(uidb64))

        user = Account.objects.get(id=id)
        if not PasswordResetTokenGenerator().check_token(user, token):
            raise AuthenticationFailed('The reset link is invalid.', 401)
        
        password,error2=validate_password(password,user.username)
        if len(password)==0:
            raise serializers.ValidationError(error2)
        user.set_password(password)
        user.save()
        return (user)

class ChangePasswordSerializer(serializers.Serializer):
    '''Serializer for changing Password'''
    
    old_password = serializers.CharField(max_length=16, min_length=12,required=True)
    new_password = serializers.CharField(max_length=16, min_length=12,required=True)
    
class ChangeToPro(serializers.Serializer):
    '''Serializer for changing Account type'''
    is_pro = serializers.BooleanField(default=False)
    
    # class Meta:
    #     fields = ['is_pro']
    
    
    # def validate(self, attrs):
    #     is_pro = attrs.get('is_pro')
    #     print(is_pro)
class OwnerSerializer(serializers.ModelSerializer):
    '''Serializer to get Account info '''
    class Meta:
        model = Account
        exclude=("password","date_joined", "updated_at",
        "last_login", "login_from", "groups","user_permissions")





