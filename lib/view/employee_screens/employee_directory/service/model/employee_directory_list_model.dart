import 'package:yes_hrm/common_model/pagination_data_model.dart';
import 'package:yes_hrm/view/employee_screens/employee_directory/service/model/employee_directory_model.dart';

class EmployeeDirectoryListModel {
  EmployeeDirectoryListModel({
    required this.employees,
    required this.pagination,
  });

  final List<EmployeeDirectoryModel> employees;
  final PaginationData pagination;

  factory EmployeeDirectoryListModel.fromJson(Map json) {
    final paginationJson = json["pagination"] is Map
        ? json["pagination"] as Map
        : json;
    return EmployeeDirectoryListModel(
      employees: getEmployeeDirectoryListFromJson(_employeesJson(json)),
      pagination: PaginationData.fromJson({
        "total": paginationJson["total"] ?? json["total"] ?? 1,
        "current_page":
            paginationJson["current_page"] ?? json["current_page"] ?? 1,
        "last_page": paginationJson["last_page"] ?? json["last_page"] ?? 1,
      }),
    );
  }
}

dynamic _employeesJson(Map json) {
  if (json["employees"] is List) return json["employees"];
  if (json["data"] is List) return json["data"];
  if (json["data"] is Map) {
    final nested = json["data"] as Map;
    return nested["employees"] ?? nested["data"] ?? [];
  }
  return [];
}

List<EmployeeDirectoryModel> getEmployeeDirectoryListFromJson(dynamic json) {
  if (json is! List) return [];
  return List.from(
    json.whereType<Map>().map((e) => EmployeeDirectoryModel.fromJson(e)),
  );
}
