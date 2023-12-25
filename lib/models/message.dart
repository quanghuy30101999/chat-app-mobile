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

  Message(
      {required this.id,
      this.text,
      this.mediaUrl,
      required this.userId,
      required this.conversationId,
      required this.createdAt,
      required this.updatedAt,
      this.asset});

  static Message createRandomMessage(
      String userId, String conversationId, AssetEntity asset) {
    return Message(
      id: const Uuid().v4(),
      userId: userId,
      conversationId: conversationId,
      asset: asset,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
