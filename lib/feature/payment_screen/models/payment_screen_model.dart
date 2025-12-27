import 'dart:convert';

class PaymentModel {
  bool? success;
  String? message;
  Data? data;

  PaymentModel({
    this.success,
    this.message,
    this.data,
  });

  factory PaymentModel.fromRawJson(String str) => PaymentModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
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
  double? total;
  double? lastWeek;
  int? thisWeek;
  String? percentageChange;
  List<User>? user;

  Data({
    this.total,
    this.lastWeek,
    this.thisWeek,
    this.percentageChange,
    this.user,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["total"]?.toDouble(),
    lastWeek: json["lastWeek"]?.toDouble(),
    thisWeek: json["thisWeek"],
    percentageChange: json["percentageChange"],
    user: json["user"] == null ? [] : List<User>.from(json["user"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "lastWeek": lastWeek,
    "thisWeek": thisWeek,
    "percentageChange": percentageChange,
    "user": user == null ? [] : List<dynamic>.from(user!.map((x) => x.toJson())),
  };
}

class User {
  String? id;
  double? amountPaid;
  String? studentId;
  Student? student;

  User({
    this.id,
    this.amountPaid,
    this.studentId,
    this.student,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    amountPaid: json["amountPaid"]?.toDouble(),
    studentId: json["studentID"],
    student: json["student"] == null ? null : Student.fromJson(json["student"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amountPaid": amountPaid,
    "studentID": studentId,
    "student": student?.toJson(),
  };
}

class Student {
  String? fullName;
  String? profileImage;
  String? email;

  Student({
    this.fullName,
    this.profileImage,
    this.email,
  });

  factory Student.fromRawJson(String str) => Student.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    fullName: json["fullName"],
    profileImage: json["profileImage"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "profileImage": profileImage,
    "email": email,
  };
}
