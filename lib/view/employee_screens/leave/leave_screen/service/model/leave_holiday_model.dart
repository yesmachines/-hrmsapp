import 'package:flutter/material.dart';

enum AppliedLeaveTone { pending, approvedUpcoming, approvedPast }

class LeaveHolidayItem {
  const LeaveHolidayItem({
    required this.id,
    required this.name,
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  final String id;
  final String name;
  final String type;
  final DateTime startDate;
  final DateTime endDate;

  bool get isFestival => type.toLowerCase() == 'festival';

  bool get isHoliday => type.toLowerCase() == 'holiday';

  bool occursOn(DateTime day) => _occursOn(day, startDate, endDate);

  bool isStart(DateTime day) => _isSameDay(startDate, day);

  bool isEnd(DateTime day) => _isSameDay(endDate, day);

  factory LeaveHolidayItem.fromJson(Map json) {
    return LeaveHolidayItem(
      id: (json["id"] ?? "").toString(),
      name: (json["name"] ?? json["title"] ?? "").toString(),
      type: (json["type"] ?? "").toString(),
      startDate: _parseDate(json["start_date"]) ?? DateTime.now(),
      endDate:
          _parseDate(json["end_date"]) ??
          _parseDate(json["start_date"]) ??
          DateTime.now(),
    );
  }
}

class CalendarAppliedLeave {
  const CalendarAppliedLeave({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.remarks = '',
    this.totalDays,
  });

  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String remarks;
  final int? totalDays;

  bool get isApproved => status == 'approved';

  bool get isPending =>
      status == 'applied' || status == 'pending' || status == 'requested';

  AppliedLeaveTone get tone {
    if (!isApproved) return AppliedLeaveTone.pending;
    final today = _dateOnly(DateTime.now());
    final end = _dateOnly(endDate);
    if (end.isBefore(today)) return AppliedLeaveTone.approvedPast;
    return AppliedLeaveTone.approvedUpcoming;
  }

  bool occursOn(DateTime day) => _occursOn(day, startDate, endDate);

  factory CalendarAppliedLeave.fromJson(Map json) {
    final leaveType = json["leave_type"];
    return CalendarAppliedLeave(
      id: (json["id"] ?? "").toString(),
      name: (json["leave_type_name"] ??
              (leaveType is Map
                  ? leaveType["leave_name"] ?? leaveType["name"]
                  : null) ??
              json["leave_name"] ??
              "Leave")
          .toString(),
      startDate: _parseDate(json["start_date"]) ?? DateTime.now(),
      endDate:
          _parseDate(json["end_date"]) ??
          _parseDate(json["start_date"]) ??
          DateTime.now(),
      status: (json["status"] ?? "").toString().trim().toLowerCase(),
      remarks: (json["remarks"] ?? "").toString(),
      totalDays: json["total_days"] is int
          ? json["total_days"] as int
          : int.tryParse((json["total_days"] ?? "").toString()),
    );
  }
}

class CalendarDayDetail {
  const CalendarDayDetail({
    required this.title,
    required this.dateLabel,
    required this.badge,
    required this.accent,
    required this.badgeBg,
    required this.badgeText,
  });

  final String title;
  final String dateLabel;
  final String badge;
  final Color accent;
  final Color badgeBg;
  final Color badgeText;
}

class LeaveHolidaysModel {
  const LeaveHolidaysModel({
    required this.festivals,
    required this.holidays,
    required this.leaves,
  });

  final List<LeaveHolidayItem> festivals;
  final List<LeaveHolidayItem> holidays;
  final List<CalendarAppliedLeave> leaves;

  factory LeaveHolidaysModel.fromJson(Map json) {
    return LeaveHolidaysModel(
      festivals: _holidayItems(json["festivals"]),
      holidays: _holidayItems(json["holidays"]),
      leaves: _leaveItems(json["leaves"]),
    );
  }
}

List<LeaveHolidayItem> _holidayItems(dynamic json) {
  if (json is! List) return const [];
  return List.unmodifiable(
    json.whereType<Map>().map(LeaveHolidayItem.fromJson),
  );
}

List<CalendarAppliedLeave> _leaveItems(dynamic json) {
  if (json is! List) return const [];
  return List.unmodifiable(
    json
        .whereType<Map>()
        .map(CalendarAppliedLeave.fromJson)
        .where((item) => item.isPending || item.isApproved),
  );
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool _occursOn(DateTime day, DateTime startDate, DateTime endDate) {
  final date = _dateOnly(day);
  final start = _dateOnly(startDate);
  final end = _dateOnly(endDate);
  return !date.isBefore(start) && !date.isAfter(end);
}

DateTime? _parseDate(dynamic value) {
  if (value == null || value.toString().trim().isEmpty) return null;
  return DateTime.tryParse(value.toString());
}
