import 'package:flutter/material.dart';
import 'package:yes_hrm/main.dart';

enum TicketCategory { payroll, hr, it }

enum TicketStatus { newTicket, open, inProgress, resolved, closed }

enum TicketAttachmentType { image, pdf }

enum TicketAuthorType { support, employee }

extension TicketCategoryX on TicketCategory {
  String get label {
    switch (this) {
      case TicketCategory.payroll:
        return 'Payroll';
      case TicketCategory.hr:
        return 'HR';
      case TicketCategory.it:
        return 'IT';
    }
  }

  String get fullLabel {
    switch (this) {
      case TicketCategory.payroll:
        return 'Payroll';
      case TicketCategory.hr:
        return 'HR Support';
      case TicketCategory.it:
        return 'IT & Technical Support';
    }
  }

  Color get bg {
    switch (this) {
      case TicketCategory.payroll:
      case TicketCategory.hr:
        return appColors.submittedBadgeBg;
      case TicketCategory.it:
        return appColors.scaffoldGreyColor;
    }
  }

  Color get text {
    switch (this) {
      case TicketCategory.payroll:
      case TicketCategory.hr:
        return appColors.submittedBadgeText;
      case TicketCategory.it:
        return appColors.mediumGreyColor;
    }
  }

  String get teamLabel {
    switch (this) {
      case TicketCategory.payroll:
        return 'Payroll';
      case TicketCategory.hr:
        return 'HR';
      case TicketCategory.it:
        return 'IT';
    }
  }
}

extension TicketStatusX on TicketStatus {
  String get label {
    switch (this) {
      case TicketStatus.newTicket:
        return 'New';
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.closed:
        return 'Closed';
    }
  }

  String get badgeLabel => label.toUpperCase();

  Color get bg {
    switch (this) {
      case TicketStatus.newTicket:
      case TicketStatus.open:
        return appColors.submittedBadgeBg;
      case TicketStatus.inProgress:
        return appColors.pendingBadgeBg;
      case TicketStatus.resolved:
        return appColors.activeBadgeBg;
      case TicketStatus.closed:
        return appColors.scaffoldGreyColor;
    }
  }

  Color get text {
    switch (this) {
      case TicketStatus.newTicket:
      case TicketStatus.open:
        return appColors.submittedBadgeText;
      case TicketStatus.inProgress:
        return appColors.pendingBadgeText;
      case TicketStatus.resolved:
        return appColors.activeBadgeText;
      case TicketStatus.closed:
        return appColors.mediumGreyColor;
    }
  }

  Color get indicator {
    switch (this) {
      case TicketStatus.newTicket:
      case TicketStatus.open:
        return appColors.lightBrandColor;
      case TicketStatus.inProgress:
        return appColors.tileAmber;
      case TicketStatus.resolved:
        return appColors.checkOutGreen;
      case TicketStatus.closed:
        return appColors.whiteColor;
    }
  }

  int get stepIndex => index;
}

extension TicketAttachmentTypeX on TicketAttachmentType {
  String get label {
    switch (this) {
      case TicketAttachmentType.image:
        return 'Image';
      case TicketAttachmentType.pdf:
        return 'PDF Document';
    }
  }

  IconData get icon {
    switch (this) {
      case TicketAttachmentType.image:
        return Icons.image_outlined;
      case TicketAttachmentType.pdf:
        return Icons.picture_as_pdf_outlined;
    }
  }
}

class TicketAttachment {
  const TicketAttachment({
    required this.name,
    required this.type,
    required this.size,
  });

  final String name;
  final TicketAttachmentType type;
  final String size;
}

class TicketComment {
  const TicketComment({
    required this.author,
    required this.avatarLabel,
    required this.authorType,
    required this.message,
  });

  final String author;
  final String avatarLabel;
  final TicketAuthorType authorType;
  final String message;
}

class TicketModel {
  const TicketModel({
    required this.id,
    required this.ticketNumber,
    required this.category,
    required this.status,
    required this.subject,
    required this.description,
    required this.date,
    required this.submittedDate,
    this.attachments = const [],
    this.comments = const [],
  });

  final String id;
  final String ticketNumber;
  final TicketCategory category;
  final TicketStatus status;
  final String subject;
  final String description;
  final DateTime date;
  final DateTime submittedDate;
  final List<TicketAttachment> attachments;
  final List<TicketComment> comments;
}
