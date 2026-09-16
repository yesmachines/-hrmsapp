class HrDocumentModel {
  HrDocumentModel({
    required this.id,
    required this.policyName,
    required this.documentCode,
    required this.version,
    required this.updated,
    required this.fileUrl
});
  String id;
  String policyName;
  String documentCode;
  String version;
  String updated;
  String? fileUrl;
}

List<HrDocumentModel> getHrDocumentFromJson(List json){
  final List<HrDocumentModel> data = [];
  for (final element in json){
    data.add(
      HrDocumentModel(
          id: element["id"].toString(),
          policyName: element["policy_name"] ?? "",
          documentCode: element["document_code"] ?? "",
          version: element["version"] ?? "",
          updated: element["updated_at"] ?? "",
          fileUrl: element["file_url"]
      )
    );
  }
  return data;
}