import 'package:complaints/common/utils/enum_utils.dart';
import 'package:complaints/common/utils/extension_utils.dart';

class Profile {
  final String? id;
  final String? username;
  final String? email;
  final StreamType? stream;
  final String? mobileNo;
  final String? avatarUrl;
  final DateTime? createdAt;
  final bool? isLoading;

  Profile({
    this.id,
    this.username,
    this.email,
    this.stream,
    this.mobileNo,
    this.avatarUrl,
    this.createdAt,
    this.isLoading,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      stream: json['stream'] != null
          ? StreamTypeExtension.fromJson(json['stream'])
          : null,
      mobileNo: json['mobile_no'],
      avatarUrl: json['avatar_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Profile copyWith({
    String? id,
    String? username,
    String? email,
    StreamType? stream,
    String? mobileNo,
    String? avatarUrl,
    DateTime? createdAt,
    bool? isLoading,
  }) {
    return Profile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      stream: stream ?? this.stream,
      mobileNo: mobileNo ?? this.mobileNo,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
