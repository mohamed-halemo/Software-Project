from rest_framework import serializers
from accounts.models import Account
from django.contrib import auth
from rest_framework.exceptions import AuthenticationFailed
from django.contrib.auth.tokens import PasswordResetTokenGenerator
from django.utils.encoding import smart_str, force_str, smart_bytes
from django.utils.encoding import DjangoUnicodeDecodeError
from django.utils.http import urlsafe_base64_decode, urlsafe_base64_encode
from rest_framework_simplejwt.tokens import RefreshToken
from project.utils import *
class SignUpSerializer(serializers.ModelSerializer):
    password = serializers.CharField(max_length=16, min_length=8,
                                     write_only=True)

    class Meta:
        model = Account
        fields = ['email', 'username', 'password','first_name','last_name','age']

    def validate(self, attrs):
        password = attrs.get('password', '')
        username = attrs.get('username', '')
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
    token = serializers.CharField(max_length=555)

    class Meta:
        model = Account
        fields = ['token']


class LogInSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(max_length=255, min_length=6)
    password = serializers.CharField(max_length=16, min_length=8,
                                     write_only=True)
    username = serializers.CharField(max_length=255, min_length=6,
                                     read_only=True)
    tokens = serializers.CharField(max_length=68, min_length=8,
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
        return {
            'email': user.email,
            'username': user.username,
            'tokens': user.tokens
        }
        
class CheckPasswordSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(max_length=255, min_length=6)
    password = serializers.CharField(max_length=16, min_length=8,
                                     write_only=True)
    username = serializers.CharField(max_length=255, min_length=6,
                                     read_only=True)
    tokens = serializers.CharField(max_length=68, min_length=8,
                                   read_only=True)

    class Meta:
        model = Account
        fields = ['email', 'password', 'username', 'tokens']

    def validate(self, attrs):
        email = attrs.get('email', '')
        password = attrs.get('password', '')
        user = auth.authenticate(email=email, password=password)
        
        if not user:
            raise AuthenticationFailed('Invalid credential, try again')
        if not user.is_active:
            raise AuthenticationFailed('Account disabled, contact admin')
        if not user.is_verified:
            raise AuthenticationFailed('Email is not verified')
        return {
            'email': user.email,
            'username': user.username,
            'tokens': user.tokens
        }

class LogoutSerializer(serializers.Serializer):
    refresh = serializers.CharField()
    
    default_error_messages = {
        'bad_token': ('Token is expired or invalid')
    }
    def validate(self, attrs):
        self.token = attrs['refresh']
        return attrs
    
    def save(self, **kwargs):
        try:
            RefreshToken(self.token).blacklist()
        except TokenError:
            self.fail('bad_token')
            

class RequestPasswordResetEmailSerializer(serializers.Serializer):
    email = serializers.EmailField(min_length=2)

    class Meta:
        fields = ['email']


class SetNewPasswordSerializer(serializers.Serializer):
    password = serializers.CharField(min_length=8, write_only=True)
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
    old_password = serializers.CharField(max_length=16, min_length=8,required=True)
    new_password = serializers.CharField(max_length=16, min_length=8,required=True)
    
class ChangeToPro(serializers.Serializer):
    is_pro = serializers.BooleanField(default=False)
    
class OwnerSerializer(serializers.ModelSerializer):
    # owner = serializers.CharField(read_only=True)
    class Meta:
        model = Account
        exclude=("password","date_joined", "updated_at",
        "last_login", "auth_provider", "groups","user_permissions")





