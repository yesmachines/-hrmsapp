import 'dart:convert';

import 'package:yes_hrm/common_model/pagination_data_model.dart';
import 'package:yes_hrm/constants/shared_data_key/shared_data_key.dart';
import 'package:yes_hrm/main.dart';

EventCalenderModel calenderEventsFromJson(String str) =>
    EventCalenderModel.fromJson(json.decode(str));

class EventCalenderModel {
  final List<Event> events;
  final PaginationData pagination;

  EventCalenderModel({required this.events, required this.pagination});

  factory EventCalenderModel.fromJson(Map<String, dynamic> json) =>
      EventCalenderModel(
        events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
        pagination: PaginationData.fromJson(json["pagination"]),
      );
}

class Event {
  final int id;
  final int eventTypeId;
  final int? organisationId;
  final String title;
  final String description;
  final DateTime startDatetime;
  final DateTime endDatetime;
  final dynamic externalLink;
  final String status;
  final int? createdBy;
  final int? employeeId;
  final String? filePath;
  final bool showDashboard;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final EventType eventType;
  final Organisation? organisation;
  final Employee? employee;

  Event({
    required this.id,
    required this.eventTypeId,
    required this.organisationId,
    required this.title,
    required this.description,
    required this.startDatetime,
    required this.endDatetime,
    required this.externalLink,
    required this.status,
    required this.createdBy,
    required this.employeeId,
    required this.filePath,
    required this.showDashboard,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.eventType,
    required this.organisation,
    required this.employee,
  });

  bool occursOn(DateTime day) => _occursOn(day, startDatetime, endDatetime);

  bool isStart(DateTime day) => _isSameDay(startDatetime, day);

  bool isEnd(DateTime day) => _isSameDay(endDatetime, day);

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _occursOn(DateTime day, DateTime startDate, DateTime endDate) {
    final date = _dateOnly(day);
    final start = _dateOnly(startDate);
    final end = _dateOnly(endDate);

    return !date.isBefore(start) && !date.isAfter(end);
  }

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    eventTypeId: json["event_type_id"],
    organisationId: json["organisation_id"],
    title: json["title"],
    description: json["description"],
    startDatetime: DateTime.parse(json["start_datetime"]),
    endDatetime: DateTime.parse(json["end_datetime"]),
    externalLink: json["external_link"],
    status: json["status"],
    createdBy: json["created_by"],
    employeeId: json["employee_id"],
    filePath: json["file_path"],
    showDashboard: json["show_dashboard"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    eventType: EventType.fromJson(json["event_type"]),
    organisation: json["organisation"] == null
        ? null
        : Organisation.fromJson(json["organisation"]),
    employee: json["employee"] == null
        ? null
        : Employee.fromJson(json["employee"]),
  );
}

class Employee {
  final int id;
  final int userId;
  final String empNum;
  final String designation;
  final User user;

  Employee({
    required this.id,
    required this.userId,
    required this.empNum,
    required this.designation,
    required this.user,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"],
    userId: json["user_id"],
    empNum: json["emp_num"],
    designation: json["designation"],
    user: User.fromJson(json["user"]),
  );
}

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], name: json["name"]);
}

class EventType {
  final int id;
  final String eventCode;
  final String eventName;
  final String eventSource;
  final int priority;
  final dynamic iconPath;

  EventType({
    required this.id,
    required this.eventCode,
    required this.eventName,
    required this.eventSource,
    required this.priority,
    required this.iconPath,
  });

  factory EventType.fromJson(Map<String, dynamic> json) => EventType(
    id: json["id"],
    eventCode: json["event_code"],
    eventName: json["event_name"],
    eventSource: json["event_source"],
    priority: json["priority"],
    iconPath: json["icon_path"],
  );
}

class Organisation {
  final int id;
  final String orgName;
  final String shortName;

  Organisation({
    required this.id,
    required this.orgName,
    required this.shortName,
  });

  factory Organisation.fromJson(Map<String, dynamic> json) => Organisation(
    id: json["id"],
    orgName: json["org_name"],
    shortName: json["short_name"],
  );
}
