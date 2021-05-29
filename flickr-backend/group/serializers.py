from rest_framework import serializers
from .models import *
from djongo import models
from accounts.models import *


class MemberSerializer(serializers.ModelSerializer):

    class Meta:
        model = Account
        fields = ['id', 'username', 'first_name', 'last_name', 'is_pro']


class GroupMemberSerializer(serializers.ModelSerializer):

    member = MemberSerializer(read_only=True)

    class Meta:
        model = Members
        fields = ['member', 'member_type']


class GroupPendingMemberSerializer(serializers.ModelSerializer):

    pending_member = MemberSerializer(read_only=True)

    class Meta:
        model = PendingMembers
        fields = ['pending_member', 'date_send_request', 'message']


class GroupSerializer(serializers.ModelSerializer):

    class Meta:
        model = group
        fields = ['id', 'name', 'description', 'privacy',
                  'member_count', 'pool_count', 'date_create',
                  'topic_count', 'group_topic']
        depth = 1
        # extra_kwargs = {'members': {'read_only': True}}


class GroupRulesSerializer(serializers.ModelSerializer):

    class Meta:
        model = group
        fields = ['rules', 'rules_is_enabled']


class GroupNameSerializer(serializers.ModelSerializer):

    class Meta:
        model = group
        fields = ['name', 'description']


class GroupRoleSerializer(serializers.ModelSerializer):

    class Meta:
        model = group
        fields = ['member_role', 'admin_role']


class GroupPrivacySerializer(serializers.ModelSerializer):

    class Meta:
        model = group
        fields = ['privacy']


class GroupSafetyLevelSerializer(serializers.ModelSerializer):

    class Meta:
        model = group
        fields = ['eighteenplus']


class GroupMemberListSerializer(serializers.ModelSerializer):
    group = GroupSerializer(read_only=True)

    class Meta:
        model = Members
        fields = ['group']


class TopicSerializer(serializers.ModelSerializer):
    owner = MemberSerializer(read_only=True)

    class Meta:
        model = topic
        fields = ['subject', 'message', 'owner', 'count_replies',
                  'date_create', 'last_reply', 'last_edit',
                  'group_topic_reply']
        depth = 1
        extra_kwargs = {'group': {'read_only': True},
                        'owner': {'read_only': True}}


class ReplySerializer(serializers.ModelSerializer):

    class Meta:
        model = reply
        fields = '__all__'
        extra_kwargs = {'topic': {'read_only': True},
                        'owner': {'read_only': True}}
