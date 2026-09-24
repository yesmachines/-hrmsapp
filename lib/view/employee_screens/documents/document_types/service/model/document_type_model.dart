class DocumentTypeTemplate {
  const DocumentTypeTemplate({
    required this.id,
    required this.templateName,
    required this.templateCode,
  });

  final int id;
  final String templateName;
  final String templateCode;

  factory DocumentTypeTemplate.fromJson(Map json) {
    return DocumentTypeTemplate(
      id: int.tryParse((json["id"] ?? "").toString()) ?? 0,
      templateName: (json["template_name"] ?? "").toString().trim(),
      templateCode: (json["template_code"] ?? "").toString(),
    );
  }
}

class DocumentTypeModel {
  const DocumentTypeModel({
    required this.id,
    required this.documentName,
    this.categoryId = 0,
    this.categoryName = '',
    this.categoryCode = '',
    this.documentCode = '',
    this.requiresNumber = false,
    this.requiresExpiry = false,
    this.editableBeforeApproval = false,
    this.requiresHrApproval = false,
    this.requiresReminder = false,
    this.recordSource = '',
    this.requiresAttachments = false,
    this.templates = const [],
  });

  final int id;
  final String documentName;
  final int categoryId;
  final String categoryName;
  final String categoryCode;
  final String documentCode;
  final bool requiresNumber;
  final bool requiresExpiry;
  final bool editableBeforeApproval;
  final bool requiresHrApproval;
  final bool requiresReminder;
  final String recordSource;
  final bool requiresAttachments;
  final List<DocumentTypeTemplate> templates;

  String get name => documentName;

  bool get isGenerated => recordSource == 'generated';

  factory DocumentTypeModel.fromJson(Map json) {
    final templatesJson = json["templates"];
    return DocumentTypeModel(
      id: int.tryParse((json["id"] ?? "").toString()) ?? 0,
      documentName:
          (json["document_name"] ?? json["name"] ?? json["title"] ?? "")
              .toString()
              .trim(),
      categoryId: int.tryParse((json["category_id"] ?? "").toString()) ?? 0,
      categoryName: (json["category_name"] ?? "").toString().trim(),
      categoryCode: (json["category_code"] ?? json["short_code"] ?? "")
          .toString()
          .trim(),
      documentCode: (json["document_code"] ?? "").toString().trim(),
      requiresNumber: _bool(json["requires_number"]),
      requiresExpiry: _bool(json["requires_expiry"]),
      editableBeforeApproval: _bool(json["editable_before_approval"]),
      requiresHrApproval: _bool(json["requires_hr_approval"]),
      requiresReminder: _bool(json["requires_reminder"]),
      recordSource: (json["record_source"] ?? "").toString().trim(),
      requiresAttachments: _bool(json["requires_attachments"]),
      templates: templatesJson is List
          ? templatesJson
                .whereType<Map>()
                .map(DocumentTypeTemplate.fromJson)
                .where((template) => template.id > 0)
                .toList()
          : const [],
    );
  }
}

bool _bool(dynamic value) =>
    value == true || value == 1 || value == '1' || value == 'true';

List<DocumentTypeModel> getDocumentTypesFromJson(dynamic json) {
  if (json is! List) return [];
  return List.from(
    json
        .whereType<Map>()
        .map(DocumentTypeModel.fromJson)
        .where((type) => type.id > 0 && type.documentName.isNotEmpty),
  );
}
