import 'dart:convert';

class HomeModel {
  bool? success;
  String? message;
  DashboardData? data;

  HomeModel({
    this.success,
    this.message,
    this.data,
  });

  factory HomeModel.fromRawJson(String str) => HomeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : DashboardData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class DashboardData {
  int? totalUser;
  int? totalTutors;
  int? totalStudents;
  int? newUser7;
  int? newUser30;
  List<LastDay>? last7Days;
  List<LastDay>? last30Days;

  DashboardData({
    this.totalUser,
    this.totalTutors,
    this.totalStudents,
    this.newUser7,
    this.newUser30,
    this.last7Days,
    this.last30Days,
  });

  factory DashboardData.fromRawJson(String str) => DashboardData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
    totalUser: json["totalUser"],
    totalTutors: json["totalTutors"],
    totalStudents: json["totalStudents"],
    newUser7: json["newUser7"],
    newUser30: json["newUser30"],
    last7Days: json["last7Days"] == null ? [] : List<LastDay>.from(json["last7Days"]!.map((x) => LastDay.fromJson(x))),
    last30Days: json["last30Days"] == null ? [] : List<LastDay>.from(json["last30Days"]!.map((x) => LastDay.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalUser": totalUser,
    "totalTutors": totalTutors,
    "totalStudents": totalStudents,
    "newUser7": newUser7,
    "newUser30": newUser30,
    "last7Days": last7Days == null ? [] : List<dynamic>.from(last7Days!.map((x) => x.toJson())),
    "last30Days": last30Days == null ? [] : List<dynamic>.from(last30Days!.map((x) => x.toJson())),
  };
}

class LastDay {
  DateTime? date;
  double? amountPaid;

  LastDay({
    this.date,
    this.amountPaid,
  });

  factory LastDay.fromRawJson(String str) => LastDay.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LastDay.fromJson(Map<String, dynamic> json) => LastDay(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    amountPaid: json["amountPaid"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "amountPaid": amountPaid,
  };
}
