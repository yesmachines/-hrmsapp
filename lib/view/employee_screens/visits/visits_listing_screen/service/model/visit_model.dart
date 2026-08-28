enum VisitTab { today, upcoming, history }

enum VisitStatus { approved, completed, rejected, requested }

enum VisitType { customerMeeting, supplierVisit, otherVisitor }

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
}

extension VisitTypeX on VisitType {
  String get label {
    switch (this) {
      case VisitType.customerMeeting:
        return 'Customer Meeting';
      case VisitType.supplierVisit:
        return 'Supplier Visit';
      case VisitType.otherVisitor:
        return 'Other Visitor';
    }
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
}

class VisitAttachment {
  const VisitAttachment({
    required this.name,
    required this.size,
  });

  final String name;
  final String size;
}

class VisitModel {
  const VisitModel({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.purpose,
    required this.assignedTask,
    required this.tab,
    this.visitorName,
    this.visitorContact,
    this.purposeDetail,
    this.assignees = const [],
    this.approvedBy,
    this.approvedDate,
    this.approvedRemarks,
    this.adminInstructions,
    this.attachments = const [],
    this.submittedDate,
  });

  final String id;
  final VisitType type;
  final VisitStatus status;
  final String title;
  final DateTime date;
  final String time;
  final String location;
  final String purpose;
  final String assignedTask;
  final VisitTab tab;
  final String? visitorName;
  final String? visitorContact;
  final String? purposeDetail;
  final List<VisitAssignee> assignees;
  final String? approvedBy;
  final DateTime? approvedDate;
  final String? approvedRemarks;
  final String? adminInstructions;
  final List<VisitAttachment> attachments;
  final DateTime? submittedDate;
}
