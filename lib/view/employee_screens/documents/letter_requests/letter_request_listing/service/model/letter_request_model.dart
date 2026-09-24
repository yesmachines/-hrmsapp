class LetterRequestModel {
  const LetterRequestModel({
    required this.id,
    this.documentTypeId = 0,
    this.documentTemplateId = 0,
    this.documentName = '',
    this.documentTitle = '',
    this.documentCode = '',
    this.templateName = '',
    this.purpose = '',
    this.details = '',
    this.toAddress = '',
    this.visaDesignation = '',
    this.status = '',
    this.statusLabel = '',
    this.statusColor = '',
    this.applyDate = '',
    this.approvedDate = '',
    this.createdAt = '',
    this.fileUrl = '',
    this.canEdit = false,
  });

  final int id;
  final int documentTypeId;
  final int documentTemplateId;
  final String documentName;
  final String documentTitle;
  final String documentCode;
  final String templateName;
  final String purpose;
  final String details;
  final String toAddress;
  final String visaDesignation;
  final String status;
  final String statusLabel;
  final String statusColor;
  final String applyDate;
  final String approvedDate;
  final String createdAt;
  final String fileUrl;
  final bool canEdit;

  String get displayTitle {
    if (documentName.isNotEmpty) return documentName;
    if (documentTitle.isNotEmpty) return documentTitle;
    return 'Letter Request';
  }

  String get displayStatus {
    if (statusLabel.isNotEmpty) return statusLabel;
    if (status.isEmpty) return '';
    return status[0].toUpperCase() + status.substring(1);
  }

  factory LetterRequestModel.fromJson(Map json) {
    return LetterRequestModel(
      id: _int(json["id"]),
      documentTypeId: _int(json["document_type_id"]),
      documentTemplateId: _int(json["document_template_id"]),
      documentName: _string(
        json["document_name"] ?? json["letter_type"] ?? json["title"],
      ),
      documentTitle: _string(json["document_title"]),
      documentCode: _string(json["document_code"]),
      templateName: _string(json["template_name"]),
      purpose: _string(json["purpose"]),
      details: _string(json["details"] ?? json["description"]),
      toAddress: _string(json["to_address"]),
      visaDesignation: _string(json["visa_designation"]),
      status: _string(json["status"]),
      statusLabel: _string(json["status_label"] ?? json["status"]),
      statusColor: _string(json["status_color"]).toLowerCase(),
      applyDate: _string(
        json["apply_date"] ??
            json["applied_date"] ??
            json["created_at"] ??
            json["requested_date"],
      ),
      approvedDate: _string(
        json["approved_date"] ?? json["approved_at"],
      ),
      createdAt: _string(json["created_at"]),
      fileUrl: _string(json["file_url"] ?? json["file"] ?? json["url"]),
      canEdit: json["can_edit"] == true ||
          json["can_edit"] == 1 ||
          json["can_edit"] == '1',
    );
  }
}

int _int(dynamic value) => int.tryParse((value ?? "").toString()) ?? 0;

String _string(dynamic value) {
  if (value == null) return '';
  return value.toString().trim();
}

List<LetterRequestModel> getLetterRequestsFromJson(dynamic json) {
  if (json is! List) return [];
  return List.from(
    json
        .whereType<Map>()
        .map(LetterRequestModel.fromJson)
        .where((item) => item.id > 0),
  );
}
