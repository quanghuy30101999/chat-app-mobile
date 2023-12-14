import 'package:json_annotation/json_annotation.dart';

part 'generated/user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String username;
  @JsonKey(name: "last_active")
  final DateTime? lastActive;
  @JsonKey(name: "is_online", defaultValue: false)
  bool isOnline;
  @JsonKey(name: "is_admin", defaultValue: false)
  final bool isAdmin;
  @JsonKey(name: "avatar_url")
  final String? avatarUrl;
  @JsonKey(name: "created_at")
  final DateTime createdAt;
  @JsonKey(name: "updated_at")
  final DateTime updatedAt;

  User(
      {required this.id,
      required this.username,
      this.lastActive,
      required this.isOnline,
      required this.isAdmin,
      this.avatarUrl,
      required this.createdAt,
      required this.updatedAt});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
