import 'package:flutter/material.dart';
import 'package:yes_hrm/main.dart';

enum NewsCategory { hr, company, safety }

extension NewsCategoryX on NewsCategory {
  String get label {
    switch (this) {
      case NewsCategory.hr:
        return 'HR';
      case NewsCategory.company:
        return 'Company';
      case NewsCategory.safety:
        return 'Safety';
    }
  }

  Color get bg {
    switch (this) {
      case NewsCategory.hr:
        return appColors.submittedBadgeBg;
      case NewsCategory.company:
        return appColors.profileIconGreenBg;
      case NewsCategory.safety:
        return appColors.expiredBadgeBg;
    }
  }

  Color get text {
    switch (this) {
      case NewsCategory.hr:
        return appColors.submittedBadgeText;
      case NewsCategory.company:
        return appColors.profileIconGreen;
      case NewsCategory.safety:
        return appColors.expiredBadgeText;
    }
  }
}

enum NewsAttachmentType { pdf, image }

extension NewsAttachmentTypeX on NewsAttachmentType {
  String get label {
    switch (this) {
      case NewsAttachmentType.pdf:
        return 'PDF FILE';
      case NewsAttachmentType.image:
        return 'IMAGE FILE';
    }
  }

  IconData get icon {
    switch (this) {
      case NewsAttachmentType.pdf:
        return Icons.picture_as_pdf_outlined;
      case NewsAttachmentType.image:
        return Icons.image_outlined;
    }
  }
}

class NewsAttachment {
  const NewsAttachment({
    required this.name,
    required this.type,
  });

  final String name;
  final NewsAttachmentType type;
}

class NewsModel {
  const NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.category,
    required this.date,
    required this.author,
    this.isPinned = false,
    this.actionItems = const [],
    this.attachments = const [],
  });

  final String id;
  final String title;
  final String summary;
  final String body;
  final NewsCategory category;
  final DateTime date;
  final String author;
  final bool isPinned;
  final List<String> actionItems;
  final List<NewsAttachment> attachments;
}
