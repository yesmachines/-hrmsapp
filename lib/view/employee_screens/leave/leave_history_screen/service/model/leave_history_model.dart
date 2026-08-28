import 'package:yes_hrm/common_model/pagination_data_model.dart';
import 'package:yes_hrm/view/employee_screens/leave/model/leave_model.dart';

class LeaveHistoryModel {
  LeaveHistoryModel({required this.leaves, required this.pagination});

  final List<LeaveModel> leaves;
  final PaginationData pagination;

  factory LeaveHistoryModel.fromJson(Map json) {
    return LeaveHistoryModel(
      leaves: json["leaves"],
      pagination: PaginationData.fromJson(json["pagination"]),
    );
  }
}
