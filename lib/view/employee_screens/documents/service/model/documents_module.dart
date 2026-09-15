class DocumentsModule {
  DocumentsModule({
    required this.id,
    required this.categoryName,
    required this.badgeText,
    required this.subcategories
});
  String id;
  String categoryName;
  String badgeText;
  List<String> subcategories;
}
List<DocumentsModule>getDocumentsFromJson(List json){
  List<DocumentsModule> data = [];
  for (Map<String, dynamic> element in json){
    data.add(
      DocumentsModule(
        id: element["id"].toString(),
        categoryName: element["category_name"] ?? "",
        badgeText: element["document_count"].toString(),
        subcategories: List<String>.from(element["subcategories"] ?? []),
      )
    );
  }
  return data;
}