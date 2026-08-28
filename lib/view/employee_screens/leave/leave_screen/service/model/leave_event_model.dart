import 'package:flutter/material.dart';

enum LeaveEventBadge { approved, businessTrip }

class LeaveEventModel {
  const LeaveEventModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.accentColor,
    required this.badge,
  });

  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final Color accentColor;
  final LeaveEventBadge badge;

  bool occursOn(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    return !date.isBefore(start) && !date.isAfter(end);
  }

  bool get isRange =>
      startDate.year != endDate.year ||
      startDate.month != endDate.month ||
      startDate.day != endDate.day;
}

class LeaveActionModel {
  const LeaveActionModel({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;
}
