class DocumentFileModel {
  const DocumentFileModel({
    required this.id,
    this.documentTypeId = 0,
    this.documentName = '',
    this.documentCode = '',
    this.categoryName = '',
    this.categoryCode = '',
    this.documentTitle = '',
    this.documentNumber = '',
    this.issueDate = '',
    this.issueDateRaw = '',
    this.expiryDate = '',
    this.expiryDateRaw = '',
    this.status = '',
    this.statusLabel = '',
    this.statusColor = '',
    this.remarks = '',
    this.currentVersion = '',
    this.fileUrl = '',
    this.canEdit = false,
    this.createdAt = '',
  });

  final int id;
  final int documentTypeId;
  final String documentName;
  final String documentCode;
  final String categoryName;
  final String categoryCode;
  final String documentTitle;
  final String documentNumber;
  final String issueDate;
  final String issueDateRaw;
  final String expiryDate;
  final String expiryDateRaw;
  final String status;
  final String statusLabel;
  final String statusColor;
  final String remarks;
  final String currentVersion;
  final String fileUrl;
  final bool canEdit;
  final String createdAt;

  String get displayTitle {
    if (documentTitle.isNotEmpty) return documentTitle;
    return documentName;
  }

  factory DocumentFileModel.fromJson(Map json) {
    return DocumentFileModel(
      id: int.tryParse((json["id"] ?? "").toString()) ?? 0,
      documentTypeId:
          int.tryParse((json["document_type_id"] ?? "").toString()) ?? 0,
      documentName: (json["document_name"] ?? "").toString().trim(),
      documentCode: (json["document_code"] ?? "").toString().trim(),
      categoryName: (json["category_name"] ?? "").toString().trim(),
      categoryCode: (json["category_code"] ?? "").toString().trim(),
      documentTitle: (json["document_title"] ?? "").toString().trim(),
      documentNumber: (json["document_number"] ?? "").toString().trim(),
      issueDate: (json["issue_date"] ?? "").toString().trim(),
      issueDateRaw: (json["issue_date_raw"] ?? "").toString().trim(),
      expiryDate: (json["expiry_date"] ?? "").toString().trim(),
      expiryDateRaw: (json["expiry_date_raw"] ?? "").toString().trim(),
      status: (json["status"] ?? "").toString().trim(),
      statusLabel: (json["status_label"] ?? json["status"] ?? "")
          .toString()
          .trim(),
      statusColor: (json["status_color"] ?? "").toString().trim().toLowerCase(),
      remarks: (json["remarks"] ?? "").toString().trim(),
      currentVersion: (json["current_version"] ?? "").toString().trim(),
      fileUrl: (json["file_url"] ?? json["file"] ?? json["url"] ?? "")
          .toString()
          .trim(),
      canEdit: false,
      // canEdit: json["can_edit"] == true ||
      //     json["can_edit"] == 1 ||
      //     json["can_edit"] == '1',
      createdAt: (json["created_at"] ?? "").toString().trim(),
    );
  }
}

List<DocumentFileModel> getDocumentFilesFromJson(dynamic json) {
  if (json is! List) return [];
  return List.from(
    json
        .whereType<Map>()
        .map(DocumentFileModel.fromJson)
        .where((document) => document.id > 0),
  );
}
