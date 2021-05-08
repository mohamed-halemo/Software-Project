from rest_framework import serializers
from .models import gallery, Comments
#   , Photo

# Serializers define the API representation.


class GallerySerializer(serializers.ModelSerializer):
    #   galery_comment = serializers.StringRelatedField(many=True)
    #   comments = serializers.PrimaryKeyRelatedField(
    # many=True, read_only=True)
    class Meta:
        model = gallery
        fields = [
            'id', 'title', 'description', 'date_create', 'date_update',
            'count_photos', 'count_videos', 'count_total',
            'count_views', 'count_comments', 'comments', 'owner']
        # depth = 1
        extra_kwargs = {'owner': {'read_only': True}}


class CommentSerializer(serializers.ModelSerializer):
    #   gallery = serializers.ReadOnlyField()
    #   owner = serializers.ReadOnlyField(source='owner.username')
    #   gallery = GallerySerializer()

    class Meta:
        model = Comments
        fields = '__all__'
        extra_kwargs = {
            'gallery': {'read_only': True}, 'owner': {'read_only': True}}


'''
    def create(self, validated_data):
        return gallery.objects.create(**validated_data)

    def update(self, instance, validated_data):
        instance.__dict__.update(**validated_data)
        instance.save()
'''

'''
class ImageSerializer(serializers.ModelSerializer):
    #   galery_comment = serializers.StringRelatedField(many=True)
    #   comments = serializers.PrimaryKeyRelatedField(
    # many=True, read_only=True)
    class Meta:
        model = Photo
        fields = '__all__'


from rest_framework_mongoengine import serializers, fields as field
from rest_framework import fields
from .models import gallery, Comments


class CommentSerializer(serializers.EmbeddedDocumentSerializer):
    class Meta:
        model = Comments
        fields = '__all__'


class GallerySerializer(serializers.DocumentSerializer):
    comments = CommentSerializer(required=False)
    title = fields.CharField(max_length=100)
    description = fields.CharField(max_length=1000, blank=True)
    url = fields.URLField(blank=True)
    date_create = fields.DateTimeField(auto_now=True)
    date_update = fields.DateTimeField(auto_now_add=True)
    count_photos = fields.IntegerField(default=0)
    count_videos = fields.IntegerField(default=0)
    count_total = fields.IntegerField(default=0)
    count_views = fields.IntegerField(default=0)
    count_comments = fields.IntegerField(default=0)

    class Meta:
        model = gallery
        fields = '__all__'
'''
