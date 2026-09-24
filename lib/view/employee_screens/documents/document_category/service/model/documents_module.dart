class DocumentsModule {
  DocumentsModule({
    required this.id,
    required this.categoryName,
    required this.shortCode,
    required this.documentCount,
    required this.badgeText,
    required this.subcategories,
  });

  String id;
  String categoryName;
  String shortCode;
  int documentCount;
  String badgeText;
  List<String> subcategories;
}

List<DocumentsModule> getDocumentsFromJson(List json) {
  final List<DocumentsModule> data = [];
  for (final element in json.whereType<Map>()) {
    data.add(
      DocumentsModule(
        id: (element["id"] ?? "").toString(),
        categoryName: element["category_name"]?.toString() ?? "",
        shortCode: (element["short_code"] ?? "").toString().trim(),
        documentCount: int.tryParse(
              (element["document_count"] ?? "").toString(),
            ) ??
            0,
        badgeText: (element["badge_text"] ?? "").toString(),
        subcategories: List<String>.from(element["subcategories"] ?? []),
      ),
    );
  }
  return data;
}
