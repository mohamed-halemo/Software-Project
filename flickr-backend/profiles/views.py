from django.shortcuts import render
from rest_framework.generics import RetrieveUpdateAPIView,RetrieveAPIView
from .serializers import ProfileSerializer
from .models import Profile
from rest_framework import permissions
from project.permissions import IsOwner
# Create your views here.


class ProfileList(RetrieveUpdateAPIView):
    serializer_class = ProfileSerializer
    permission_classes = (permissions.IsAuthenticated,)
    queryset = Profile.objects.all()

    def perform_create(self, serializer):
        return serializer.save(owner=self.request.user)

    # def get_queryset(self):
    #     return self.queryset.filter(owner=self.request.user)
    
    def get_object(self):
        queryset = self.filter_queryset(self.get_queryset())
        obj = queryset.get(owner=self.request.user)
        return obj
    


class ProfileDetailList(RetrieveAPIView):
    serializer_class = ProfileSerializer
    permission_classes = (permissions.IsAuthenticated,)
    queryset = Profile.objects.all()
    lookup_field = 'id'
