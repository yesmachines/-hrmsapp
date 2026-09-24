class DepartmentModel {
  const DepartmentModel({required this.id, required this.name});

  final String id;
  final String name;

  String get shortName => name.replaceAll(' Department', '').trim();

  factory DepartmentModel.fromJson(Map json) {
    return DepartmentModel(
      id: (json["id"] ?? "").toString(),
      name: (json["name"] ?? json["title"] ?? json["department"] ?? "")
          .toString()
          .trim(),
    );
  }
}

List<DepartmentModel> getDepartmentsFromJson(dynamic json) {
  if (json is! List) return [];
  return List.from(
    json.whereType<Map>().map((e) => DepartmentModel.fromJson(e)).where(
          (department) => department.id.isNotEmpty || department.name.isNotEmpty,
        ),
  );
}
