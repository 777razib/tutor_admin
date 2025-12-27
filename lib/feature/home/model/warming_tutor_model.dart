import 'dart:convert';

class WarmingTutorsModel {
  bool? success;
  String? message;
  List<WarmingTutorData>? data;

  WarmingTutorsModel({
    this.success,
    this.message,
    this.data,
  });

  factory WarmingTutorsModel.fromRawJson(String str) => WarmingTutorsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WarmingTutorsModel.fromJson(Map<String, dynamic> json) => WarmingTutorsModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<WarmingTutorData>.from(json["data"]!.map((x) => WarmingTutorData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class WarmingTutorData {
  String? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? password;
  String? gender;
  String? city;
  String? status;
  String? fcmToken;
  String? profileImage;
  dynamic hourlyRate;
  String? demoClassUrl;
  bool? isTutorRequest;
  bool? isTutorApproved;
  String? tutorRequestStatus;
  dynamic otp;
  DateTime? otpExpiresAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? role;
  List<dynamic>? subject;
  dynamic education;
  dynamic experience;
  dynamic about;
  List<dynamic>? availableDays;
  List<dynamic>? availableTime;
  int? rating;
  dynamic totalReviews;
  List<TutorReview>? tutorReview;

  WarmingTutorData({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.password,
    this.gender,
    this.city,
    this.status,
    this.fcmToken,
    this.profileImage,
    this.hourlyRate,
    this.demoClassUrl,
    this.isTutorRequest,
    this.isTutorApproved,
    this.tutorRequestStatus,
    this.otp,
    this.otpExpiresAt,
    this.createdAt,
    this.updatedAt,
    this.role,
    this.subject,
    this.education,
    this.experience,
    this.about,
    this.availableDays,
    this.availableTime,
    this.rating,
    this.totalReviews,
    this.tutorReview,
  });

  factory WarmingTutorData.fromRawJson(String str) => WarmingTutorData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WarmingTutorData.fromJson(Map<String, dynamic> json) => WarmingTutorData(
    id: json["id"],
    fullName: json["fullName"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    password: json["password"],
    gender: json["gender"],
    city: json["city"],
    status: json["status"],
    fcmToken: json["fcmToken"],
    profileImage: json["profileImage"],
    hourlyRate: json["hourlyRate"],
    demoClassUrl: json["demoClassUrl"],
    isTutorRequest: json["isTutorRequest"],
    isTutorApproved: json["isTutorApproved"],
    tutorRequestStatus: json["tutorRequestStatus"],
    otp: json["otp"],
    otpExpiresAt: json["otpExpiresAt"] == null ? null : DateTime.parse(json["otpExpiresAt"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    role: json["role"],
    subject: json["subject"] == null ? [] : List<dynamic>.from(json["subject"]!.map((x) => x)),
    education: json["education"],
    experience: json["experience"],
    about: json["about"],
    availableDays: json["availableDays"] == null ? [] : List<dynamic>.from(json["availableDays"]!.map((x) => x)),
    availableTime: json["availableTime"] == null ? [] : List<dynamic>.from(json["availableTime"]!.map((x) => x)),
    rating: json["rating"],
    totalReviews: json["totalReviews"],
    tutorReview: json["tutorReview"] == null ? [] : List<TutorReview>.from(json["tutorReview"]!.map((x) => TutorReview.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "phoneNumber": phoneNumber,
    "password": password,
    "gender": gender,
    "city": city,
    "status": status,
    "fcmToken": fcmToken,
    "profileImage": profileImage,
    "hourlyRate": hourlyRate,
    "demoClassUrl": demoClassUrl,
    "isTutorRequest": isTutorRequest,
    "isTutorApproved": isTutorApproved,
    "tutorRequestStatus": tutorRequestStatus,
    "otp": otp,
    "otpExpiresAt": otpExpiresAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "role": role,
    "subject": subject == null ? [] : List<dynamic>.from(subject!.map((x) => x)),
    "education": education,
    "experience": experience,
    "about": about,
    "availableDays": availableDays == null ? [] : List<dynamic>.from(availableDays!.map((x) => x)),
    "availableTime": availableTime == null ? [] : List<dynamic>.from(availableTime!.map((x) => x)),
    "rating": rating,
    "totalReviews": totalReviews,
    "tutorReview": tutorReview == null ? [] : List<dynamic>.from(tutorReview!.map((x) => x.toJson())),
  };
}

class TutorReview {
  String? id;
  String? studentId;
  String? tutorId;
  int? rating;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;

  TutorReview({
    this.id,
    this.studentId,
    this.tutorId,
    this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory TutorReview.fromRawJson(String str) => TutorReview.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TutorReview.fromJson(Map<String, dynamic> json) => TutorReview(
    id: json["id"],
    studentId: json["studentId"],
    tutorId: json["tutorId"],
    rating: json["rating"],
    comment: json["comment"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "studentId": studentId,
    "tutorId": tutorId,
    "rating": rating,
    "comment": comment,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
