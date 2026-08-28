import 'package:flutter/material.dart';

import 'leave_status_enum.dart';
import 'leave_type_enum.dart';

class LeaveModel {
  const LeaveModel({
    required this.id,
    required this.type,
    required this.status,
    required this.fromDate,
    required this.toDate,
    required this.appliedOn,
  });

  final String id;
  final LeaveType type;
  final LeaveStatus status;
  final DateTime fromDate;
  final DateTime toDate;
  final DateTime appliedOn;

  factory LeaveModel.fromJson(Map json) {
    return LeaveModel(
      id: "1",
      type: LeaveType.sickLeave,
      status: LeaveStatus.approved,
      fromDate: DateTime.now(),
      toDate: DateTime.now(),
      appliedOn: DateTime.now(),
    );
  }
}

class LeaveTypeStyle {
  const LeaveTypeStyle({required this.bg, required this.text});

  final Color bg;
  final Color text;
}
