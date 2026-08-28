class LeaveMetaModel {
  LeaveMetaModel({required this.employee, required this.leaveTypes});

  final EmployeeModel employee;
  final List<LeaveTypeModel> leaveTypes;

  factory LeaveMetaModel.fromJson(Map json) {
    return LeaveMetaModel(
      employee: EmployeeModel.fromJson(json["employee"]),
      leaveTypes: getLeaveTypeFromJson(json["leave_types"]),
    );
  }
}

List<LeaveTypeModel> getLeaveTypeFromJson(List json) =>
    List.from(json.map((e) => LeaveTypeModel.fromJson(e)));

class EmployeeModel {
  const EmployeeModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String imageUrl;

  factory EmployeeModel.fromJson(Map json) {
    return EmployeeModel(
      id: json["id"].toString(),
      name: json["name"] ?? "",
      imageUrl: json["image_url"] ?? "",
    );
  }
}

class LeaveTypeModel {
  const LeaveTypeModel({
    required this.id,
    required this.leaveName,
    required this.requiresAttachment,
    required this.balance,
    this.policy,
  });

  final String id;
  final String leaveName;
  final bool requiresAttachment;
  final LeaveBalanceModel balance;
  final dynamic policy;

  factory LeaveTypeModel.fromJson(Map json) {
    return LeaveTypeModel(
      id: json["id"].toString(),
      leaveName: json["leave_name"] ?? "",
      requiresAttachment: json["requires_attachment"] ?? false,
      balance: LeaveBalanceModel.fromJson(json["balance"]),
      policy: json["policy"],
    );
  }
}

class LeaveBalanceModel {
  const LeaveBalanceModel({
    required this.total,
    required this.used,
    required this.balance,
  });

  final int total;
  final int used;
  final int balance;

  factory LeaveBalanceModel.fromJson(Map json) {
    return LeaveBalanceModel(
      total: json["total"] ?? 0,
      used: json["used"] ?? 0,
      balance: json["balance"] ?? 0,
    );
  }
}
