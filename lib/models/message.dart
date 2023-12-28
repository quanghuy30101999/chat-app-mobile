import 'package:json_annotation/json_annotation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

part 'generated/message.g.dart';

@JsonSerializable()
class Message {
  final String id;
  final String? text;
  @JsonKey(name: "media_url")
  final String? mediaUrl;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'conversation_id')
  final String conversationId;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;
  final AssetEntity? asset;
  final bool? isTyping;

  Message(
      {required this.id,
      this.text,
      this.mediaUrl,
      required this.userId,
      required this.conversationId,
      required this.createdAt,
      required this.updatedAt,
      this.asset,
      this.isTyping});

  static Message createRandomMessage(
      String userId, String conversationId, AssetEntity? asset,
      {bool isTyping = false, DateTime? createdAt, DateTime? updatedAt}) {
    return Message(
      id: const Uuid().v4(),
      userId: userId,
      conversationId: conversationId,
      asset: asset,
      isTyping: isTyping,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
