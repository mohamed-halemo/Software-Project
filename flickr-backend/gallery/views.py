from django.http import JsonResponse
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from .models import gallery, Comments
#   , Photo
from .serializers import GallerySerializer, CommentSerializer
#   , ImageSerializer
from django.core.exceptions import ObjectDoesNotExist
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.permissions import IsAuthenticated


@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes((IsAuthenticated,))
def gallery_info(request, galpk):
    try:
        gallery_obj = gallery.objects.get(id=galpk)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    #   GET
    if request.method == 'GET':
        serializer = GallerySerializer(gallery_obj)
        return Response(serializer.data)
    #   PUT
    elif request.method == 'PUT':
        if (gallery_obj.owner != request.user):
            return Response(
                 {'stat': 'fail',
                  'message': 'User does not have permission to edit'
                             ' this gallery'},
                 status=status.HTTP_403_FORBIDDEN)
        serializer = GallerySerializer(gallery_obj, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    #   DELETE
    elif request.method == 'DELETE':
        if (gallery_obj.owner != request.user):
            return Response(
                 {'stat': 'fail',
                  'message': 'User does not have permission to delete'
                             ' this gallery'},
                 status=status.HTTP_403_FORBIDDEN)
        gallery_obj.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
        '''
        operation = gallery_obj.delete()
        data = {}
        if operation:
            data["stat"] = "OK"
            status= status.HTTP_400_BAD_REQUEST
        else:
            data["stat"] = "Fail"
            status= status.HTTP_400_BAD_REQUEST
        return Response(data=data)
           return Response(status= 404)
        '''


@api_view(['GET', 'POST'])
@permission_classes((IsAuthenticated,))
def gallery_list(request):
    # GET
    if request.method == 'GET':
        galleries = gallery.objects.all().order_by('-date_create')
        serializer = GallerySerializer(galleries, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    # POST
    elif request.method == 'POST':
        #   serializer = CreateGallerySerializer(data= request.data)
        serializer = GallerySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(owner=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def find_gallery(request):
    value = request.query_params.get("title")
    galleries = gallery.objects.filter(title__icontains=value)\
        .order_by('-date_create')
    serializer = GallerySerializer(galleries, many=True)
    return Response(serializer.data)


@api_view(['GET', 'POST'])
def comments_list(request, galpk):
    try:
        gallery_obj = gallery.objects.get(id=galpk)
    except ObjectDoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    # GET
    if request.method == 'GET':
        comments = gallery_obj.comments.all()
        serializer = CommentSerializer(comments, many=True)
        return Response(serializer.data)
    # POST
    elif request.method == 'POST':
        serializer = CommentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(
                gallery=gallery_obj, owner=request.user)
            gallery_obj.count_comments += 1
            gallery_obj.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.data, status=status.HTTP_400_BAD_REQUEST)
        '''
        data = request.data
        for comment in data["comments"]:
            comment_obj = Comments.objects.get(content=data["content"])
            gallery_obj.comments.add(comment_obj)
        serializer = GallerySerializer(gallery_obj)
        return Response(serializer.data)
        '''


@api_view(['GET', 'PUT', 'DELETE'])
@permission_classes((IsAuthenticated,))
def gallery_comments(request, galpk, compk):
    try:
        gallery_obj = gallery.objects.get(id=galpk)
    except ObjectDoesNotExist:
        #   raise Http404
        return Response(status=status.HTTP_404_NOT_FOUND)
    try:
        comment_obj = gallery_obj.comments.get(id=compk)
    except ObjectDoesNotExist:
        #   raise Http404
        return Response(status=status.HTTP_404_NOT_FOUND)
    # GET
    if request.method == 'GET':
        serializer = CommentSerializer(comment_obj)
        return Response(serializer.data)
    # PUT
    elif request.method == 'PUT':
        if (comment_obj.owner != request.user):
            return Response(
                {'stat': 'fail',
                 'message': 'User does not have permission to edit'
                            ' this comment'},
                status=status.HTTP_403_FORBIDDEN)
        serializer = CommentSerializer(comment_obj, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    #   DELETE
    elif request.method == 'DELETE':
        if (comment_obj.owner != request.user):
            return Response(
                {'stat': 'fail',
                 'message': 'User does not have permission to delete'
                            ' this comment'},
                status=status.HTTP_403_FORBIDDEN)
        comment_obj.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


'''

@api_view(['GET'])
def gallery_photos(request, galpk):
    try:
        gallery_obj = gallery.objects.get(id=galpk)
    except gallery_obj.DoesNotExists:
        #   raise Http404
        return Response(status=status.HTTP_404_NOT_FOUND)
    # GET
    if request.method == 'GET':
        photos = gallery_obj.gallery_photos.all()
        serializer = CommentSerializer(photos, many=True)
        return Response(serializer.data)

            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.data, status=status.HTTP_400_BAD_REQUEST)
@api_view(['POST','DELETE'])
def gallery_photo(request, galpk, phopk):
    try:
        gallery_obj = gallery.objects.get(id=galpk)
    except gallery_obj.DoesNotExists:
        #   raise Http404
        return Response(status=status.HTTP_404_NOT_FOUND)
    try:
        photo_obj = gallery_obj.gallery_photos.get(id=phopk)
    except photo_obj.DoesNotExists:
        #   raise Http404
        return Response(status=status.HTTP_404_NOT_FOUND)
    if request.method == 'POST':
        serializer = PhotoSerializer(photo_obj)
        if serializer.is_valid():
            if photo_obj.owner not user.request && is public==True
                serializer.save(gallery=gallery_obj)
                if photo_obj.media=='photo':
                    gallery_obj.count_photos += 1
                else:
                    gallery_obj.count_videos += 1
                gallery_obj.save()
                return Response(
                    serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.data, status=status.HTTP_400_BAD_REQUEST)
    #   DELETE
    elif request.method == 'DELETE':
        photo_obj
        return Response(status=status.HTTP_204_NO_CONTENT)

@api_view(['GET'])
def fav_List(request):
    #GET
    if request.method == 'GET':
        fav_photos = Photo.objects.get(is_faved=True/1)

@api_view(['POST','DELETE'])
def fav_photo(request, phopk):
    try:
        photo_obj = photo.objects.get(id=phopk)
    except photo_obj.DoesNotExists:
        #   raise Http404
        return Response(status=status.HTTP_404_NOT_FOUND)
    #POST
    if request.method == 'POST':
        photo_obj.is_faved = True
        Photo.save()
    #   DELETE
    if request.method == 'DELETE'
        photo_obj.is_faved = False
        Photo_obj.save()
'''
'''
   def upload(instance,filename):
    imagename , extension = filename.split(".")
    photo=Photo()
    photo.count_videos = gallery.objects.filter(media="video").count
    photo.count_photos = gallery.objects.filter(media="photo").count
    photo.save()
'''
'''
@api_view(['POST'])
def upload(request):
    if request.method == 'POST':
        form = ImageSerializer(request.POST, request.FILES)
        if form.is_valid():
            photo = form.save()
            data = {
                'is_valid': True,
                 'name': photo.file.name, 'url': photo.file.url}
        else:
            data = {'is_valid': False}
        return JsonResponse(data)

@api_view(['POST'])
def upload(request):
    if request.method == 'POST':
        parser_classes = (MultiPartParser, FormParser)
        serializer = ImageSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            print(serializer.data)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(
                serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        for image in images:
            serializer = ImageSerializer(data=request.data)
            if serializer.is_valid():
                serializer.save(image=image)
                return Response(
                    serializer.data, status=status.HTTP_201_CREATED)
            return Response(status=status.HTTP_400_BAD_REQUEST)
        data = request.POST
        images = request.FILES.getlist('image')
        for image in images:
            image = Images.objects.create(
                name=data['name'],
                image=image,
            )
            #if image.content_type == ("photo"):
            #    user.count_photos+=1
            #else:
            #    user.count_videos +=1
        return Response(status=status.HTTP_201_CREATED)
#in models:     image = models.ImageField(null=False, blank=False)

@api_view(['POST'])
def addPhoto(request):
    categories = Category.objects.all()

    if request.method == 'POST':
        data = request.POST
        images = request.FILES.getlist('images')

        if data['category'] != 'none':
            category = Category.objects.get(id=data['category'])
        elif data['category_new'] != '':
            category, created = Category.objects.get_or_create(
                name=data['category_new'])
        else:
            category = None

        for image in images:
            photo = Photo.objects.create(
                category=category,
                description=data['description'],
                image=image,
            )

        return redirect('gallery')

    context = {'categories': categories}
    return render(request, 'photos/add.html', context)
'''
'''
from django.shortcuts import render
from .models import gallery #name of the class in models
from django.core.paginator import Paginator
# Create your views here.
def add_gallery(request):
    pass


def gallery_list(request):
    gallery_list= gallery.objects.all()
    per_page=1
    paginator=(Paginator(gallery_list, per_page))
    page_number= request.Get.get('page')
    page_obj = paginator.get_page(page_number)
    context={'galleries': page_obj} #its name in the template
    return render(request,'html',context)

def gallery_info(request , id):
    galelery_info = gallery.objects.get(id=id)
    context={'gallery': gallery_info}
    return render(request,'html',context)

def add_gallery(request):
    pass
'''
