from rest_framework import serializers
from .models import Domain, Aspect, Angle , Bookmark
from django.contrib.auth.models import User


class AspectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Aspect
        fields = ('id', 'name')


class DomainSerializer(serializers.ModelSerializer):
    aspect_set = AspectSerializer(many=True, read_only=True)

    class Meta:
        model = Domain
        fields = ('id', 'name', 'aspect_set')


class DomainOnlySerializer(serializers.ModelSerializer):
    class Meta:
        model = Domain
        fields = ('id', 'name')


class AspectWithDomainSerializer(serializers.ModelSerializer):
    domain = DomainOnlySerializer(many=False, read_only=True)

    class Meta:
        model = Aspect
        fields = ('id', 'name', 'domain')


class AngleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Angle
        fields = ('id', 'name')


class BookmarkSerializer(serializers.ModelSerializer):
    aspect = AspectWithDomainSerializer(many=False, read_only=True)
    angle = AngleSerializer(many=False, read_only=True)

    class Meta:
        model = Bookmark
        fields = ('id', 'name', 'aspect', 'angle',
                  'url', 'description', 'favicon', 'image',
                  'feed_url', 'feed_type', 'content_type', 'updated_at')


class UserSerializer(serializers.ModelSerializer):
    bookmark_set = serializers.PrimaryKeyRelatedField(many=True, queryset=Bookmark.objects.all())

    class Meta:
        model = User
        field = ('id', 'username', 'bookmark_set')


