import 'dart:convert';

class UserScreenModel {
  bool? success;
  String? message;
  Data? data;

  UserScreenModel({
    this.success,
    this.message,
    this.data,
  });

  factory UserScreenModel.fromRawJson(String str) => UserScreenModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserScreenModel.fromJson(Map<String, dynamic> json) => UserScreenModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Meta? meta;
  List<UserModelData>? data;

  Data({
    this.meta,
    this.data,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    data: json["data"] == null ? [] : List<UserModelData>.from(json["data"]!.map((x) => UserModelData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class UserModelData {
  String? id;
  String? fullName;
  String? email;
  bool? isTutorApproved;
  bool? isTutorRequest;
  TutorRequestStatus? tutorRequestStatus;
  dynamic isOnline;
  Role? role;
  List<String>? subject;
  DateTime? createdAt;

  UserModelData({
    this.id,
    this.fullName,
    this.email,
    this.isTutorApproved,
    this.isTutorRequest,
    this.tutorRequestStatus,
    this.isOnline,
    this.role,
    this.subject,
    this.createdAt,
  });

  factory UserModelData.fromRawJson(String str) => UserModelData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModelData.fromJson(Map<String, dynamic> json) => UserModelData(
    id: json["id"],
    fullName: json["fullName"],
    email: json["email"],
    isTutorApproved: json["isTutorApproved"],
    isTutorRequest: json["isTutorRequest"],
    tutorRequestStatus: tutorRequestStatusValues.map[json["tutorRequestStatus"]]!,
    isOnline: json["isOnline"],
    role: roleValues.map[json["role"]]!,
    subject: json["subject"] == null ? [] : List<String>.from(json["subject"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "isTutorApproved": isTutorApproved,
    "isTutorRequest": isTutorRequest,
    "tutorRequestStatus": tutorRequestStatusValues.reverse[tutorRequestStatus],
    "isOnline": isOnline,
    "role": roleValues.reverse[role],
    "subject": subject == null ? [] : List<dynamic>.from(subject!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
  };
}

enum Role {
  STUDENT,
  TUTOR
}

final roleValues = EnumValues({
  "STUDENT": Role.STUDENT,
  "TUTOR": Role.TUTOR
});

enum TutorRequestStatus {
  ACCEPTED,
  CANCELLED,
  PENDING
}

final tutorRequestStatusValues = EnumValues({
  "ACCEPTED": TutorRequestStatus.ACCEPTED,
  "CANCELLED": TutorRequestStatus.CANCELLED,
  "PENDING": TutorRequestStatus.PENDING
});

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPage,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPage: json["totalPage"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPage": totalPage,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
