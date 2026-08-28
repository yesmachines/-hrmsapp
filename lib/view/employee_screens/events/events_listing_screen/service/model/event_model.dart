import 'package:flutter/material.dart';

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
}
