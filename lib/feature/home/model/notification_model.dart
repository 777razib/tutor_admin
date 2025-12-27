class NotificationResponse {
  bool success;
  String message;
  List<NotificationData> data;

  NotificationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NotificationData.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class NotificationData {
  String id;
  String userId;
  String title;
  String body;
  String type;
  String data;
  String targetId;
  String slug;
  String fcmToken;
  bool read;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  NotificationData({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.targetId,
    required this.slug,
    required this.fcmToken,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      data: json['data'] ?? '',
      targetId: json['targetId'] ?? '',
      slug: json['slug'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
      read: json['read'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  // ✅ copyWith method
  NotificationData copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? type,
    String? data,
    String? targetId,
    String? slug,
    String? fcmToken,
    bool? read,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return NotificationData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      data: data ?? this.data,
      targetId: targetId ?? this.targetId,
      slug: slug ?? this.slug,
      fcmToken: fcmToken ?? this.fcmToken,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }
}

class User {
  String id;
  String fullName;
  String email;

  User({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
