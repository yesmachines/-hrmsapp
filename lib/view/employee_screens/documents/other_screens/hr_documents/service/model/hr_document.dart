import 'dart:ui';

class HrDocument {
  const HrDocument({
    required this.title,
    required this.version,
    required this.updatedDate,
    required this.iconColor,
    required this.iconBg,
  });

  final String title;
  final String version;
  final String updatedDate;
  final Color iconColor;
  final Color iconBg;
}