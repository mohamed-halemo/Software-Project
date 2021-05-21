from django.urls import path
from .views import *
from rest_framework_simplejwt.views import TokenRefreshView


app_name = 'accounts'

urlpatterns = [
    #sign user up
    path('sign-up/', SignUpView.as_view(), name="signup"),
    
    #change user's password
    path('change-password/', ChangePassword.as_view(), name='change-password'),
    
    #verify user's mail
    path('email-verify/', VerifyEmail.as_view(), name="email-verify"),
    
    #reset users password
    path('password-reset-email', RequestPasswordResetEmail.as_view(),
         name="reset=pass"),
    
    #log user in
    path('login/', LoginView.as_view(), name="login"),
    
    #log user out
    path('logout/', LogoutView.as_view(), name="logout"),
    
    #reset user's password
    path('password-reset/<uidb64>/<token>/', PasswordTokenCheck.as_view(),
         name="password-reset-confirm"),
    
    #setting new password after reset
    path('password-reset-complete/', SetNewPassword.as_view(),
         name="password-reset-complete"),
    
    #refresh token api
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    #delete user's account
    path('delete-account/', DeleteAccount, name='delete-account'),
    
    #change account type
    path('change-to-pro/', ChangeToPro.as_view(), name="change-to-pro"),
    
    #get account info
    path('user-info/', UserInfo.as_view(), name="user-info"),

]
