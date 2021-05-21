from django.urls import path

from . import views

app_name = 'profiles'
urlpatterns = [
    path('', views.ProfileList.as_view(), name='profilelist'),
    path('<int:id>', views.ProfileDetailList.as_view(), name='profiledetail'),
    path('profile-pic', views.upload_profile, name='upload_profile'),
    path('cover-photo', views.upload_cover, name='upload_cover'),
    
    # Contacts
    path('follow/<int:userpk>', views.follow_unfollow, name='follow_unfollow'),
    # get the favourites photos list API
    path('followers', views.followers_list, name='followers_list'),
    path('following', views.following_list, name='following_list'),
    path('following/<int:userpk>', views.user_following, name='user_following'),

]
