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
  @JsonKey(name: 'messages')
  List<Message> messages;

  Conversation(
      {required this.id,
      this.name,
      required this.createdAt,
      required this.updatedAt,
      required this.users,
      required this.messages});

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  bool isGroup() {
    return users.length > 1;
  }
}
