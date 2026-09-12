class LeaveMetaModel {
  LeaveMetaModel({
    required this.employee,
    required this.leaveTypes,
    this.festivals = const [],
    this.employees = const [],
  });

  final EmployeeModel employee;
  final List<LeaveTypeModel> leaveTypes;
  final List<FestivalModel> festivals;
  final List<EmployeeModel> employees;

  factory LeaveMetaModel.fromJson(Map json) {
    return LeaveMetaModel(
      employee: EmployeeModel.fromJson(json["employee"] ?? {}),
      leaveTypes: getLeaveTypeFromJson(json["leave_types"] ?? []),
      festivals: getFestivalsFromJson(
        json["festivals"] ?? json["festival"] ?? [],
      ),
      employees: getEmployeesFromJson(
        json["employees"] ??
            json["colleagues"] ??
            json["handover_employees"] ??
            [],
      ),
    );
  }
}

List<LeaveTypeModel> getLeaveTypeFromJson(List json) =>
    List.from(json.map((e) => LeaveTypeModel.fromJson(e)));

List<FestivalModel> getFestivalsFromJson(dynamic json) {
  if (json is! List) return [];
  return List.from(
    json.whereType<Map>().map((e) => FestivalModel.fromJson(e)),
  );
}

List<EmployeeModel> getEmployeesFromJson(dynamic json) {
  if (json is! List) return [];
  return List.from(
    json.whereType<Map>().map((e) => EmployeeModel.fromJson(e)),
  );
}

class EmployeeModel {
  const EmployeeModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.designation = '',
  });

  final String id;
  final String name;
  final String imageUrl;
  final String designation;

  factory EmployeeModel.fromJson(Map json) {
    return EmployeeModel(
      id: json["id"].toString(),
      name: json["name"] ?? json["full_name"] ?? "",
      imageUrl: json["image_url"] ?? json["avatar"] ?? json["photo"] ?? "",
      designation: json["designation"] ?? json["job_title"] ?? "",
    );
  }
}

class FestivalModel {
  const FestivalModel({required this.id, required this.name});

  final String id;
  final String name;

  factory FestivalModel.fromJson(Map json) {
    return FestivalModel(
      id: json["id"].toString(),
      name: json["name"] ?? json["festival_name"] ?? "",
    );
  }
}

class LeaveTypeModel {
  const LeaveTypeModel({
    required this.id,
    required this.leaveName,
    required this.leaveCode,
    required this.requiresAttachment,
    required this.requiresHandover,
    required this.balance,
    this.festivals = const [],
    this.policy,
  });

  final String id;
  final String leaveName;
  final String leaveCode;
  final bool requiresAttachment;
  final bool requiresHandover;
  final LeaveBalanceModel balance;
  final List<FestivalModel> festivals;
  final dynamic policy;

  factory LeaveTypeModel.fromJson(Map json) {
    return LeaveTypeModel(
      id: json["id"].toString(),
      leaveName: json["leave_name"] ?? json["name"] ?? "",
      leaveCode: (json["leave_code"] ?? json["code"] ?? "").toString(),
      requiresAttachment: json["requires_attachment"] ?? false,
      requiresHandover: json["requires_handover"] ?? false,
      balance: LeaveBalanceModel.fromJson(json["balance"] ?? {}),
      festivals: getFestivalsFromJson(json["festivals"] ?? []),
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
