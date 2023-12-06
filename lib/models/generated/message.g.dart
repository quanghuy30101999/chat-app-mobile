// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String,
      text: json['text'] as String?,
      mediaUrl: json['media_url'] as String?,
      userId: json['user_id'] as String,
      conversationId: json['conversation_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'media_url': instance.mediaUrl,
      'user_id': instance.userId,
      'conversation_id': instance.conversationId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
