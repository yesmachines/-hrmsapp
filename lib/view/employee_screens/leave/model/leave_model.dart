import 'dart:developer';

import 'package:flutter/material.dart';

import 'leave_status_enum.dart';
import 'leave_type_model.dart';

class LeaveModel {
  const LeaveModel({
    required this.id,
    required this.type,
    required this.status,
    required this.fromDate,
    required this.toDate,
    required this.appliedOn,
    this.totalDays,
    this.remarks = '',
    this.handoverPersonId = '',
    this.handoverPersonName = '',
    this.handoverDescription = '',
    this.personalContact = '',
    this.emergencyContact = '',
    this.travelingOutsideCountry,
    this.destination = '',
    this.travelContact = '',
    this.declarationSigned,
    this.dueDate,
    this.childBirthDate,
    this.childAge = '',
    this.festivalId = '',
    this.festivalName = '',
    this.relative = '',
    this.attachments = const [],
    this.reviewComment = '',
    this.reviewedBy = '',
    this.employeeName = '',
  });

  final String id;
  final LeaveType type;
  final LeaveStatus status;
  final DateTime fromDate;
  final DateTime toDate;
  final DateTime appliedOn;
  final int? totalDays;
  final String remarks;
  final String handoverPersonId;
  final String handoverPersonName;
  final String handoverDescription;
  final String personalContact;
  final String emergencyContact;
  final bool? travelingOutsideCountry;
  final String destination;
  final String travelContact;
  final bool? declarationSigned;
  final DateTime? dueDate;
  final DateTime? childBirthDate;
  final String childAge;
  final String festivalId;
  final String festivalName;
  final String relative;
  final List<LeaveAttachment> attachments;
  final String reviewComment;
  final String reviewedBy;
  final String employeeName;

  int get durationDays {
    if (totalDays != null && totalDays! > 0) return totalDays!;
    final days = toDate.difference(fromDate).inDays + 1;
    return days < 1 ? 0 : days;
  }

  String get durationLabel {
    final days = durationDays;
    return days == 1 ? '1 Day' : '$days Days';
  }

  bool get hasHandover =>
      handoverPersonName.isNotEmpty ||
      handoverDescription.isNotEmpty ||
      personalContact.isNotEmpty ||
      emergencyContact.isNotEmpty ||
      travelingOutsideCountry != null ||
      declarationSigned != null;

  bool get hasExtraDetails =>
      dueDate != null ||
      childBirthDate != null ||
      childAge.isNotEmpty ||
      festivalName.isNotEmpty ||
      relative.isNotEmpty;

  bool get hasReview => reviewComment.isNotEmpty || reviewedBy.isNotEmpty;

  bool get canEdit => status == LeaveStatus.requested;

  factory LeaveModel.fromJson(Map json) {
    final handover = json["handover_person"];
    final festival = json["festival"];
    final employee = json["employee"];
    return LeaveModel(
      id: (json["id"] ?? "").toString(),
      type: _leaveTypeFromJson(json),
      status: LeaveStatusEnum.fromString(json["status"]),
      fromDate: _parseDate(
        json["start_date"] ?? json["from_date"] ?? json["from"],
      ),
      toDate: _parseDate(json["end_date"] ?? json["to_date"] ?? json["to"]),
      appliedOn: _parseDate(
        json["applied_on"] ?? json["applied_date"] ?? json["created_at"],
      ),
      totalDays: _parseInt(json["total_days"] ?? json["days"]),
      remarks: _string(json["remarks"] ?? json["reason"] ?? json["comment"]),
      handoverPersonId: _string(
        json["handover_person_id"] ?? (handover is Map ? handover["id"] : null),
      ),
      handoverPersonName: handover is Map
          ? _string(handover["name"] ?? handover["full_name"])
          : _string(json["handover_person_name"]),
      handoverDescription: _string(json["handover_description"]),
      personalContact: _string(
        json["personal_contact"] ?? json["personal_contact_no"],
      ),
      emergencyContact: _string(
        json["emergency_contact_no"] ?? json["emergency_contact"],
      ),
      travelingOutsideCountry: _parseBool(
        json["traveling_outside_country"] ?? json["travelling_outside_country"],
      ),
      destination: _string(json["destination"]),
      travelContact: _string(
        json["travel_contact_no"] ?? json["travel_contact"],
      ),
      declarationSigned: _parseBool(json["declaration_signed"]),
      dueDate: _tryParseDate(json["due_date"]),
      childBirthDate: _tryParseDate(json["child_birth_date"]),
      childAge: _string(json["child_age"] ?? json["child_age_months"]),
      festivalId: _string(
        json["festival_id"] ?? (festival is Map ? festival["id"] : null),
      ),
      festivalName: festival is Map
          ? _string(festival["name"] ?? festival["festival_name"])
          : _string(json["festival_name"]),
      relative: _string(
        json["relative"] ?? json["compassionate_relative"] ?? json["relation"],
      ),
      attachments: _attachmentsFromJson(json),
      reviewComment: _string(
        json["review_comment"] ??
            json["rejection_reason"] ??
            json["approver_remarks"],
      ),
      reviewedBy: _string(
        json["reviewed_by"] ?? json["approved_by"] ?? json["rejected_by"],
      ),
      employeeName: employee is Map
          ? _string(employee["name"] ?? employee["full_name"])
          : _string(json["employee_name"]),
    );
  }
}

class LeaveAttachment {
  const LeaveAttachment({
    required this.name,
    required this.url,
    this.size = '',
  });

  final String name;
  final String url;
  final String size;

  bool get isPdf {
    final value = '$name $url'.toLowerCase();
    return value.contains('.pdf');
  }

  bool get isImage {
    final value = '$name $url'.toLowerCase();
    const imageHints = [
      '.png',
      '.jpg',
      '.jpeg',
      '.gif',
      '.webp',
      '.heic',
      '.bmp',
    ];
    return imageHints.any(value.contains);
  }
}

LeaveType _leaveTypeFromJson(Map json) {
  final raw = json["leave_type"];
  if (raw is Map) {
    return LeaveType.fromJson(raw);
  }
  return LeaveType(
    id: (json["leave_type_id"] ?? "").toString(),
    leaveType: _string(json["leave_name"] ?? json["type"] ?? "Leave"),
  );
}

List<LeaveAttachment> _attachmentsFromJson(Map json) {
  final files =
      json["attachments"] ??
      json["files"] ??
      json["certificates"] ??
      json["certificate"];
  if (files is List) {
    return files
        .map(_attachmentFromValue)
        .where((file) => file.url.isNotEmpty || file.name.isNotEmpty)
        .toList();
  }
  final single = _attachmentFromValue(files);
  if (single.url.isEmpty && single.name.isEmpty) return const [];
  return [single];
}

LeaveAttachment _attachmentFromValue(dynamic value) {
  if (value is Map) {
    final url = _string(
      value["url"] ?? value["file_url"] ?? value["path"] ?? value["file"],
    );
    final name = _string(value["name"] ?? value["file_name"] ?? _fileName(url));
    return LeaveAttachment(
      name: name.isEmpty ? 'Attachment' : name,
      url: url,
      size: _string(value["size"]),
    );
  }
  final url = _string(value);
  return LeaveAttachment(name: _fileName(url), url: url);
}

String _fileName(String url) {
  if (url.isEmpty) return 'Attachment';
  final uri = Uri.tryParse(url);
  if (uri != null && uri.pathSegments.isNotEmpty) {
    final name = uri.pathSegments.last;
    if (name.isNotEmpty) return name;
  }
  return url;
}

String _string(dynamic value) {
  if (value == null) return '';
  return value.toString().trim();
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

bool? _parseBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  switch (value.toString().trim().toLowerCase()) {
    case 'true':
    case '1':
    case 'yes':
      return true;
    case 'false':
    case '0':
    case 'no':
      return false;
    default:
      return null;
  }
}

DateTime? _tryParseDate(dynamic value) {
  if (value == null || value.toString().trim().isEmpty) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

DateTime _parseDate(dynamic value) {
  return _tryParseDate(value) ?? DateTime.now();
}

class LeaveTypeStyle {
  const LeaveTypeStyle({required this.bg, required this.text});

  final Color bg;
  final Color text;
}
