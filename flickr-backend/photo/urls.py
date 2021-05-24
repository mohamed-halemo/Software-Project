from django.urls import path, include
from . import views

app_name = 'photo'

urlpatterns = [

    # Get photo permissions API
    path('<int:id>/perms', views.get_perms, name='get_perms'),

    # Set photo meta API
    path('<int:id>/meta', views.set_meta, name='set_meta'),

    # Set photo dates API
    path('<int:id>/dates', views.set_dates, name='set_dates'),

    # Edit or delete photo comment APIs
    path('comments/<int:id>', views.edit_or_delete_comment,
         name='edit_or_delete_comment'),

    # Edit or delete photo note APIs
    path('notes/<int:id>', views.edit_or_delete_note,
         name='edit_or_delete_note'),

    # Delete photo API
    path('<int:id>', views.delete_photo, name='delete_photo'),

    # Get photo views API
    path('<int:id>/views', views.get_views, name='get_views'),
    
    # Faves
    # get the favourites photos list API
    path('faves', views.faves_list, name='faves_list'),

    # get List of the users who faved a photo API
    path('<int:id>/faves', views.photo_faves, name='photo_faves'),

    # add or remove a specific photo to the favourites photos API
    path('<int:id>/fav', views.fav_photo, name='fav_photo'),
    
    # Upload
    path('upload', views.upload_media, name='upload_media'),

]
