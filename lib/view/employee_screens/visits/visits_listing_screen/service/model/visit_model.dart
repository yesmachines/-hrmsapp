enum VisitTab { today, tomorrow, dayAfterTomorrow }

enum VisitStatus { approved, completed, rejected, requested }

extension VisitTabX on VisitTab {
  String get apiValue {
    switch (this) {
      case VisitTab.today:
        return 'today';
      case VisitTab.tomorrow:
        return 'tomorrow';
      case VisitTab.dayAfterTomorrow:
        return 'day_after_tomorrow';
    }
  }

  String get label {
    switch (this) {
      case VisitTab.today:
        return 'Today';
      case VisitTab.tomorrow:
        return 'Tomorrow';
      case VisitTab.dayAfterTomorrow:
        return 'Day After';
    }
  }
}

extension VisitStatusX on VisitStatus {
  String get label {
    switch (this) {
      case VisitStatus.approved:
        return 'Approved';
      case VisitStatus.completed:
        return 'Completed';
      case VisitStatus.rejected:
        return 'Rejected';
      case VisitStatus.requested:
        return 'Requested';
    }
  }

  String get apiValue => name;

  static VisitStatus fromString(dynamic value) {
    switch (value?.toString().trim().toLowerCase()) {
      case 'approved':
        return VisitStatus.approved;
      case 'completed':
        return VisitStatus.completed;
      case 'rejected':
        return VisitStatus.rejected;
      case 'pending':
      case 'requested':
      default:
        return VisitStatus.requested;
    }
  }
}

class VisitVisitor {
  const VisitVisitor({required this.name, required this.designation});

  final String name;
  final String designation;

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Map<String, String> toJson() => {"name": name, "designation": designation};

  factory VisitVisitor.fromJson(Map json) {
    return VisitVisitor(
      name: (json["name"] ?? "").toString(),
      designation: (json["designation"] ?? json["role"] ?? "").toString(),
    );
  }
}

class VisitAssignee {
  const VisitAssignee({
    required this.id,
    required this.name,
    required this.role,
    this.initials,
  });

  final String id;
  final String name;
  final String role;
  final String? initials;

  factory VisitAssignee.fromJson(Map json) {
    final source = json["employee"] is Map ? json["employee"] as Map : json;
    final name = (source["name"] ?? source["full_name"] ?? "").toString();
    return VisitAssignee(
      id: (source["id"] ?? json["id"] ?? "").toString(),
      name: name,
      role:
          (source["role"] ?? source["designation"] ?? source["job_title"] ?? "")
              .toString(),
      initials: _initialsFrom(name),
    );
  }
}

class VisitAttachment {
  const VisitAttachment({
    required this.name,
    required this.size,
    this.url = '',
  });

  final String name;
  final String size;
  final String url;

  factory VisitAttachment.fromJson(Map json) {
    final url =
        (json["url"] ?? json["file_url"] ?? json["path"] ?? json["file"] ?? "")
            .toString();
    return VisitAttachment(
      name: (json["name"] ?? json["file_name"] ?? _fileName(url)).toString(),
      size: (json["size"] ?? "").toString(),
      url: url,
    );
  }
}

class VisitModel {
  const VisitModel({
    required this.id,
    required this.status,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.purpose,
    required this.tab,
    this.company,
    this.contactNo,
    this.email,
    this.expectedStartDate,
    this.expectedEndDate,
    this.visitors = const [],
    this.visitorName,
    this.visitorContact,
    this.purposeDetail,
    this.remarks,
    this.assignees = const [],
    this.approvedBy,
    this.approvedDate,
    this.approvedRemarks,
    this.adminInstructions,
    this.attachments = const [],
    this.submittedDate,
  });

  final String id;
  final VisitStatus status;
  final String title;
  final DateTime date;
  final String time;
  final String location;
  final String purpose;
  final VisitTab tab;
  final String? company;
  final String? contactNo;
  final String? email;
  final DateTime? expectedStartDate;
  final DateTime? expectedEndDate;
  final List<VisitVisitor> visitors;
  final String? visitorName;
  final String? visitorContact;
  final String? purposeDetail;
  final String? remarks;
  final List<VisitAssignee> assignees;
  final String? approvedBy;
  final DateTime? approvedDate;
  final String? approvedRemarks;
  final String? adminInstructions;
  final List<VisitAttachment> attachments;
  final DateTime? submittedDate;

  DateTime get startAt => expectedStartDate ?? date;

  factory VisitModel.fromJson(Map json, {VisitTab tab = VisitTab.today}) {
    final start = _tryParseDate(
      json["expected_start_date"] ??
          json["visit_date"] ??
          json["date"] ??
          json["start_date"],
    );
    final end = _tryParseDate(json["expected_end_date"] ?? json["end_date"]);
    final company = _nullableString(json["company"]);
    final purpose = (json["purpose"] ?? "").toString();
    final title =
        (json["title"] ?? json["visit_type_name"] ?? company ?? purpose)
            .toString();
    return VisitModel(
      id: (json["id"] ?? "").toString(),
      status: VisitStatusX.fromString(json["status"]),
      title: title,
      date: start ?? DateTime.now(),
      time: _parseTime(
        json["expected_time"] ??
            json["time"] ??
            json["visit_time"] ??
            json["expected_start_date"],
      ),
      location: (json["location"] ?? "").toString(),
      purpose: purpose,
      tab: tab,
      company: company,
      contactNo: _nullableString(
        json["contact_no"] ?? json["contact"] ?? json["phone"],
      ),
      email: _nullableString(json["email"]),
      expectedStartDate: start,
      expectedEndDate: end,
      visitors: _visitorsFromJson(json["visitor_details"] ?? json["visitors"]),
      visitorName: _nullableString(json["visitor_name"]),
      visitorContact: _nullableString(
        json["visitor_contact"] ?? json["visitor_phone"],
      ),
      purposeDetail: _nullableString(
        json["purpose_detail"] ?? json["purpose_details"],
      ),
      remarks: _nullableString(json["remarks"]),
      assignees: _assigneesFromJson(
        json["assignees"] ?? json["assigned_employees"] ?? json["employees"],
      ),
      approvedBy: _nullableString(
        json["approved_by"] is Map
            ? json["approved_by"]["name"]
            : json["approved_by"],
      ),
      approvedDate: _tryParseDate(json["approved_date"] ?? json["approved_at"]),
      approvedRemarks: _nullableString(
        json["approved_remarks"] ?? json["approver_remarks"],
      ),
      adminInstructions: _nullableString(json["admin_instructions"]),
      attachments: _attachmentsFromJson(json["attachments"] ?? json["files"]),
      submittedDate: _tryParseDate(
        json["submitted_date"] ?? json["created_at"],
      ),
    );
  }
}

List<VisitVisitor> _visitorsFromJson(dynamic json) {
  if (json is Map) json = [json];
  if (json is! List) return const [];
  return List.from(json.whereType<Map>().map((e) => VisitVisitor.fromJson(e)));
}

List<VisitAssignee> _assigneesFromJson(dynamic json) {
  if (json is! List) return const [];
  return List.from(json.whereType<Map>().map((e) => VisitAssignee.fromJson(e)));
}

List<VisitAttachment> _attachmentsFromJson(dynamic json) {
  if (json is! List) return const [];
  return List.from(
    json.whereType<Map>().map((e) => VisitAttachment.fromJson(e)),
  );
}

String? _nullableString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

DateTime? _tryParseDate(dynamic value) {
  if (value == null || value.toString().trim().isEmpty) return null;
  if (value is DateTime) return value;
  final raw = value.toString().trim();
  return DateTime.tryParse(raw) ??
      DateTime.tryParse(raw.replaceFirst(' ', 'T'));
}

String _parseTime(dynamic value) {
  if (value == null) return '-';
  final parsed = _tryParseDate(value);
  if (parsed != null) {
    final period = parsed.hour >= 12 ? 'PM' : 'AM';
    final displayHour = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
    return '${displayHour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')} $period';
  }
  final raw = value.toString().trim();
  if (raw.isEmpty) return '-';
  final lower = raw.toLowerCase();
  if (lower.contains('am') || lower.contains('pm')) return raw;
  final parts = raw.split(':');
  if (parts.length >= 2) {
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour != null && minute != null) {
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour % 12 == 0 ? 12 : hour % 12;
      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    }
  }
  return raw;
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

String? _initialsFrom(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return null;
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
