import 'dart:ui';

class DocumentCategory {
  const DocumentCategory({
    required this.title,
    required this.items,
    required this.count,
    required this.accentColor,
  });

  final String title;
  final List<String> items;
  final int count;
  final Color accentColor;
}