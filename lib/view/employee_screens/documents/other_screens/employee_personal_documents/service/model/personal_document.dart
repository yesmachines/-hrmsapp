import 'package:flutter/cupertino.dart';


enum PersonalDocStatus { approved, rejected, pendingApproval }

class PersonalDocument {
  const PersonalDocument({
    required this.title,
    required this.icon,
    required this.status,
    required this.details,
  });

  final String title;
  final IconData icon;
  final PersonalDocStatus? status;
  final Map<String, String> details;
}