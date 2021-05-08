from . import views
from django.urls import path, include
app_name = 'gallery'
urlpatterns = [
    # path('', views.add_gallery),
    # path('', views.gallery_list),
    path('<int:galpk>', views.gallery_info, name='gallery-info'),
    path('', views.gallery_list, name='gallery-list'),
    path('search', views.find_gallery,  name='gallery-search'),
    path('<int:galpk>/comments', views.comments_list,
         name='gallery-comments-list'),
    path('<int:galpk>/comment/<int:compk>', views.gallery_comments,
         name='gallery-comment-info'),
    #     path('upload/', views.upload, name='upload'),
]
