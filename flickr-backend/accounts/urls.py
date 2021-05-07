from django.urls import path
from .api.views import *
app_name = 'accounts'

urlpatterns = [
    path('sign-up/', SignUpView.as_view(), name="signup"),
    path('email-verify/', VerifyEmail.as_view(), name="email-verify"),
    path('password-reset-email', RequestPasswordResetEmail.as_view(),
         name="reset=pass"),
    path('login/', LoginView.as_view(), name="login"),
    path('password-reset/<uidb64>/<token>/', PasswordTokenCheck.as_view(),
         name="password-reset-confirm"),
    path('password-reset-complete/', SetNewPassword.as_view(),
         name="password-reset-complete"),
]
