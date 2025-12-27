import 'dart:convert';

class TutorRequest {
  bool? success;
  String? message;
  List<TutorReqData>? data;

  TutorRequest({
    this.success,
    this.message,
    this.data,
  });

  factory TutorRequest.fromRawJson(String str) => TutorRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TutorRequest.fromJson(Map<String, dynamic> json) => TutorRequest(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<TutorReqData>.from(json["data"]!.map((x) => TutorReqData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TutorReqData {
  String? id;
  String? fullName;
  int? experience;
  bool? isTutorApproved;
  bool? isTutorRequest;
  TutorRequestStatus? tutorRequestStatus;
  String? profileImage;
  String? email;
  Role? role;
  List<String>? subject;
  DateTime? createdAt;

  TutorReqData({
    this.id,
    this.fullName,
    this.experience,
    this.isTutorApproved,
    this.isTutorRequest,
    this.tutorRequestStatus,
    this.profileImage,
    this.email,
    this.role,
    this.subject,
    this.createdAt,
  });

  factory TutorReqData.fromRawJson(String str) => TutorReqData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TutorReqData.fromJson(Map<String, dynamic> json) => TutorReqData(
    id: json["id"],
    fullName: json["fullName"],
    experience: json["experience"],
    isTutorApproved: json["isTutorApproved"],
    isTutorRequest: json["isTutorRequest"],
    tutorRequestStatus: tutorRequestStatusValues.map[json["tutorRequestStatus"]]!,
    profileImage: json["profileImage"],
    email: json["email"],
    role: roleValues.map[json["role"]]!,
    subject: json["subject"] == null ? [] : List<String>.from(json["subject"]!.map((x) => x)),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "experience": experience,
    "isTutorApproved": isTutorApproved,
    "isTutorRequest": isTutorRequest,
    "tutorRequestStatus": tutorRequestStatusValues.reverse[tutorRequestStatus],
    "profileImage": profileImage,
    "email": email,
    "role": roleValues.reverse[role],
    "subject": subject == null ? [] : List<dynamic>.from(subject!.map((x) => x)),
    "createdAt": createdAt?.toIso8601String(),
  };
}

enum Role {
  TUTOR
}

final roleValues = EnumValues({
  "TUTOR": Role.TUTOR
});

enum TutorRequestStatus {
  PENDING
}

final tutorRequestStatusValues = EnumValues({
  "PENDING": TutorRequestStatus.PENDING
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
