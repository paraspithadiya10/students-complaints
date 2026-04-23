class Profile {
  final String? id;
  final String? username;
  final String? email;
  final String? stream;
  final DateTime? createdAt;
  final bool? isLoading;

  Profile({
    this.id,
    this.username,
    this.email,
    this.stream,
    this.createdAt,
    this.isLoading,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      stream: json['stream'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Profile copyWith({
    String? id,
    String? username,
    String? email,
    String? stream,
    DateTime? createdAt,
    bool? isLoading,
  }) {
    return Profile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      stream: stream ?? this.stream,
      createdAt: createdAt ?? this.createdAt,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
