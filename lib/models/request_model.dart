import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseRequestModel {
  String? get id;
  String get userEmail;
  DateTime get date;
  String get status;
  String get type;
  String get description;
  Map<String, String>? get supportingDocs;

  factory BaseRequestModel.fromMap(String id, Map<String, dynamic> map) {
    throw UnimplementedError('fromMap() has not been implemented.');
  }

  Map<String, dynamic> toMap();

  BaseRequestModel copyWith({
    String? id,
    DateTime? date,
    String? userEmail,
    String? status,
    String? type,
    String? description,
    Map<String, String>? supportingDocs,
  });
}

class RequestModel implements BaseRequestModel {
  ///type = 'Organizer Role Request' | 'Feedback'
  @override
  final String? id;
  @override
  final String userEmail;
  @override
  final DateTime date;
  @override
  final String status;
  @override
  final String type;
  @override
  final String description;
  @override
  final Map<String, String> supportingDocs;

  RequestModel({
    this.id,
    required this.userEmail,
    required this.date,
    required this.status,
    required this.type,
    required this.description,
    required this.supportingDocs,
  });

  factory RequestModel.fromMap(String id, Map<String, dynamic> map) =>
      RequestModel(
        id: id,
        userEmail: map['userEmail'],
        date: (map['date'] as Timestamp).toDate(),
        status: map['status'],
        type: map['type'],
        description: map['description'],
        supportingDocs: Map<String, String>.from(map['supportingDocs']),
      );

  @override
  Map<String, dynamic> toMap() => {
        'userEmail': userEmail,
        'date': date,
        'status': status,
        'type': type,
        'description': description,
        'supportingDocs': supportingDocs,
      };

  @override
  RequestModel copyWith({
    String? id,
    DateTime? date,
    String? userEmail,
    String? status,
    String? type,
    String? description,
    Map<String, String>? supportingDocs,
  }) =>
      RequestModel(
        id: id ?? this.id,
        userEmail: userEmail ?? this.userEmail,
        date: date ?? this.date,
        status: status ?? this.status,
        type: type ?? this.type,
        description: description ?? this.description,
        supportingDocs: supportingDocs ?? this.supportingDocs,
      );
}

class ReportModel implements BaseRequestModel {
  ///type = 'Report User'
  @override
  final String? id;
  @override
  final String userEmail;
  final String reportedUserEmail;
  @override
  final DateTime date;
  @override
  final String status;
  @override
  final String type;
  @override
  final String description;
  @override
  final Map<String, String> supportingDocs;
  final int? days;

  ReportModel({
    this.id,
    required this.userEmail,
    required this.reportedUserEmail,
    required this.date,
    required this.status,
    required this.type,
    required this.description,
    required this.supportingDocs,
    this.days
  });

  factory ReportModel.fromMap(String id, Map<String, dynamic> map) =>
      ReportModel(
        id: id,
        userEmail: map['userEmail'],
        reportedUserEmail: map['reportedUserEmail'],
        date: (map['date'] as Timestamp).toDate(),
        status: map['status'],
        type: map['type'],
        description: map['description'],
        supportingDocs: Map<String, String>.from(map['supportingDocs']),
        days: map['days'] ?? 0,
      );

  @override
  Map<String, dynamic> toMap() => {
        'userEmail': userEmail,
        'reportedUserEmail': reportedUserEmail,
        'date': date,
        'status': status,
        'type': type,
        'description': description,
        'supportingDocs': supportingDocs,
        'days': days ?? 0,
      };

  @override
  ReportModel copyWith({
    String? id,
    DateTime? date,
    String? userEmail,
    String? reportedUserEmail,
    String? status,
    String? type,
    String? description,
    Map<String, String>? supportingDocs,
    int? days,
  }) =>
      ReportModel(
        id: id ?? this.id,
        userEmail: userEmail ?? this.userEmail,
        reportedUserEmail: reportedUserEmail ?? this.reportedUserEmail,
        date: date ?? this.date,
        status: status ?? this.status,
        type: type ?? this.type,
        description: description ?? this.description,
        supportingDocs: supportingDocs ?? this.supportingDocs,
        days: days ?? this.days,
      );
}
