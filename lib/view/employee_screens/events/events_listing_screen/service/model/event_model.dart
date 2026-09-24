import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum EventType { meeting, training, companyEvent, workshop }

extension EventTypeX on EventType {
  String get label {
    switch (this) {
      case EventType.meeting:
        return 'Meeting';
      case EventType.training:
        return 'Training Sessions';
      case EventType.companyEvent:
        return 'Company Event';
      case EventType.workshop:
        return 'Workshop';
    }
  }

  String get badgeLabel => label.toUpperCase();

  IconData get icon {
    switch (this) {
      case EventType.meeting:
        return Icons.calendar_month_outlined;
      case EventType.training:
        return Icons.school_outlined;
      case EventType.companyEvent:
        return Icons.cake_outlined;
      case EventType.workshop:
        return Icons.work_outline_rounded;
    }
  }

  static EventType fromApi({String code = '', String name = ''}) {
    final haystack = '$code $name'.toLowerCase();
    if (haystack.contains('workshop')) return EventType.workshop;
    if (haystack.contains('train')) return EventType.training;
    if (haystack.contains('company') ||
        haystack.contains('celebration') ||
        haystack.contains('party')) {
      return EventType.companyEvent;
    }
    return EventType.meeting;
  }
}

class EventTypeInfo {
  const EventTypeInfo({
    required this.id,
    this.eventCode = '',
    this.eventName = '',
    this.eventSource = '',
    this.priority = 0,
    this.iconPath,
  });

  final int id;
  final String eventCode;
  final String eventName;
  final String eventSource;
  final int priority;
  final String? iconPath;

  factory EventTypeInfo.fromJson(Map json) {
    return EventTypeInfo(
      id: _int(json['id']),
      eventCode: _string(json['event_code']),
      eventName: _string(json['event_name']),
      eventSource: _string(json['event_source']),
      priority: _int(json['priority']),
      iconPath: _nullableString(json['icon_path']),
    );
  }
}

class EventOrganisation {
  const EventOrganisation({
    required this.id,
    this.orgName = '',
    this.shortName = '',
  });

  final int id;
  final String orgName;
  final String shortName;

  factory EventOrganisation.fromJson(Map json) {
    return EventOrganisation(
      id: _int(json['id']),
      orgName: _string(json['org_name']),
      shortName: _string(json['short_name']),
    );
  }
}

class EventModel {
  const EventModel({
    required this.id,
    required this.type,
    required this.title,
    required this.date,
    required this.time,
    required this.venue,
    this.organizer,
    this.meetingLink,
    this.instructions,
    this.endDate,
    this.filePath,
    this.status = '',
    this.eventType,
    this.organisation,
  });

  final String id;
  final EventType type;
  final String title;
  final DateTime date;
  final String time;
  final String venue;
  final String? organizer;
  final String? meetingLink;
  final String? instructions;
  final DateTime? endDate;
  final String? filePath;
  final String status;
  final EventTypeInfo? eventType;
  final EventOrganisation? organisation;

  String get typeLabel {
    final name = eventType?.eventName.trim() ?? '';
    if (name.isNotEmpty) return name;
    return type.label;
  }

  String get typeBadgeLabel => typeLabel.toUpperCase();

  factory EventModel.fromJson(Map json) {
    final eventTypeJson = json['event_type'];
    final organisationJson = json['organisation'];
    final eventType = eventTypeJson is Map
        ? EventTypeInfo.fromJson(eventTypeJson)
        : null;
    final organisation = organisationJson is Map
        ? EventOrganisation.fromJson(organisationJson)
        : null;
    final start = _tryParseDate(json['start_datetime']) ?? DateTime.now();
    final end = _tryParseDate(json['end_datetime']);
    final description = _nullableString(json['description']);
    final orgName = organisation?.orgName.trim() ?? '';
    final creatorJson = json['creator'];
    final employeeJson = json['employee'];
    final creatorName = creatorJson is Map
        ? _nullableString(creatorJson['name'])
        : null;
    final employeeName = employeeJson is Map
        ? _nullableString(employeeJson['name'] ?? employeeJson['full_name'])
        : null;

    return EventModel(
      id: (json['id'] ?? '').toString(),
      type: EventTypeX.fromApi(
        code: eventType?.eventCode ?? '',
        name: eventType?.eventName ?? '',
      ),
      title: _string(json['title']),
      date: start,
      time: _formatTimeRange(start, end),
      venue: orgName,
      organizer: creatorName ?? employeeName,
      meetingLink: _nullableString(json['external_link']),
      instructions: description,
      endDate: end,
      filePath: _nullableString(json['file_path']),
      status: _string(json['status']),
      eventType: eventType,
      organisation: organisation,
    );
  }
}

int _int(dynamic value) => int.tryParse((value ?? '').toString()) ?? 0;

String _string(dynamic value) {
  if (value == null) return '';
  return value.toString().trim();
}

String? _nullableString(dynamic value) {
  final text = _string(value);
  return text.isEmpty ? null : text;
}

DateTime? _tryParseDate(dynamic value) {
  if (value == null || value.toString().trim().isEmpty) return null;
  if (value is DateTime) return value.toLocal();
  final raw = value.toString().trim();
  final parsed =
      DateTime.tryParse(raw) ?? DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  return parsed?.toLocal();
}

String _formatClock(DateTime date) => DateFormat('hh:mm a').format(date);

String _formatTimeRange(DateTime start, DateTime? end) {
  final startLabel = _formatClock(start);
  if (end == null) return startLabel;
  return '$startLabel - ${_formatClock(end)}';
}

List<EventModel> getEventsFromJson(dynamic json) {
  if (json is! List) return [];
  return List.from(
    json
        .whereType<Map>()
        .map(EventModel.fromJson)
        .where((event) => event.id.isNotEmpty && event.id != '0'),
  );
}
