import 'dart:ui';

class DocumentCategory {
  const DocumentCategory({
    required this.title,
    required this.items,
    required this.count,
    required this.accentColor,
    this.shortCode = '',
  });

  final String title;
  final List<String> items;
  final int count;
  final Color accentColor;
  final String shortCode;
}

String? categoryCodeFromArguments(dynamic args, {String? fallback}) {
  if (args is String && args.trim().isNotEmpty) return args.trim();
  if (args is Map) {
    final code =
        args["category_code"] ?? args["short_code"] ?? args["categoryCode"];
    final value = code?.toString().trim() ?? '';
    if (value.isNotEmpty) return value;
  }
  return fallback;
}

String categoryNameFromArguments(dynamic args, {String fallback = 'Document Types'}) {
  if (args is Map) {
    final name = args["category_name"] ?? args["title"];
    final value = name?.toString().trim() ?? '';
    if (value.isNotEmpty) return value;
  }
  return fallback;
}