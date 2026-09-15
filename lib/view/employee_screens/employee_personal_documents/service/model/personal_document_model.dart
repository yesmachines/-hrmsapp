class PersonalDocumentModel {
  PersonalDocumentModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.categoryCode,
    required this.documentName,
    required this.documentCode,
    required this.requiresNumber,
    required this.requiresExpiry,
    required this.editableBeforeApproval,
    required this.requiresHrApproval,
    required this.requiresReminder,
    required this.recordSource,
    required this.requiresAttachments,
    required this.templates,
  });

  int id;
  int categoryId;
  String categoryName;
  String categoryCode;
  String documentName;
  String documentCode;
  bool requiresNumber;
  bool requiresExpiry;
  bool editableBeforeApproval;
  bool requiresHrApproval;
  bool requiresReminder;
  String recordSource;
  bool requiresAttachments;
  List<dynamic> templates;
}

List<PersonalDocumentModel> getPersonalDocumentFromJson(List json) {
  final List<PersonalDocumentModel> data = [];

  for (final element in json) {
    data.add(
      PersonalDocumentModel(
        id: element['id'],
        categoryId: element['category_id'],
        categoryName: element['category_name'],
        categoryCode: element['category_code'],
        documentName: element['document_name'],
        documentCode: element['document_code'],
        requiresNumber: element['requires_number'] ?? false,
        requiresExpiry: element['requires_expiry'] ?? false,
        editableBeforeApproval:
        element['editable_before_approval'] ?? false,
        requiresHrApproval:
        element['requires_hr_approval'] ?? false,
        requiresReminder:
        element['requires_reminder'] ?? false,
        recordSource: element['record_source'],
        requiresAttachments:
        element['requires_attachments'] ?? false,
        templates: element['templates'] ?? [],
      ),
    );
  }

  return data;
}