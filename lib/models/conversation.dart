import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/conversation.g.dart';

@JsonSerializable()
class Conversation {
  final String id;
  final String? name;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;
  @JsonKey(name: 'users', defaultValue: [])
  final List<User> users;
  @JsonKey(name: 'last_message')
  final Message? lastMessage;

  Conversation(
      {required this.id,
      this.name,
      required this.createdAt,
      required this.updatedAt,
      required this.users,
      this.lastMessage});

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
