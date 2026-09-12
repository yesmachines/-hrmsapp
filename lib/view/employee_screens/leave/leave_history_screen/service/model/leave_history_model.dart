import 'dart:developer';

import 'package:yes_hrm/common_model/pagination_data_model.dart';
import 'package:yes_hrm/view/employee_screens/leave/model/leave_model.dart';

class LeaveHistoryModel {
  LeaveHistoryModel({required this.leaves, required this.pagination});

  final List<LeaveModel> leaves;
  final PaginationData pagination;

  factory LeaveHistoryModel.fromJson(Map json) {
    final paginationJson = json["pagination"];
    return LeaveHistoryModel(
      leaves: getLeaveListFromJson(json["leave_requests"]),
      pagination: PaginationData.fromJson(
        paginationJson is Map
            ? paginationJson
            : {
                "total": json["total"] ?? 1,
                "current_page": json["current_page"] ?? 1,
                "last_page": json["last_page"] ?? 1,
              },
      ),
    );
  }
}

List<LeaveModel> getLeaveListFromJson(dynamic json) {
  if (json is! List) return [];
  return List.from(
    json.whereType<Map>().map((e) => LeaveModel.fromJson(e)),
  );
}
