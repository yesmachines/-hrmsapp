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
    this.allowBalance = false,
    this.festivals = const [],
    this.policy,
  });

  final String id;
  final String leaveName;
  final String leaveCode;
  final bool requiresAttachment;
  final bool requiresHandover;
  final LeaveBalanceModel balance;
  final bool allowBalance;
  final List<FestivalModel> festivals;
  final LeavePolicyModel? policy;

  factory LeaveTypeModel.fromJson(Map json) {
    return LeaveTypeModel(
      id: json["id"].toString(),
      leaveName: json["leave_name"] ?? json["name"] ?? "",
      leaveCode: (json["leave_code"] ?? json["code"] ?? "").toString(),
      requiresAttachment: json["requires_attachment"] ?? false,
      requiresHandover: json["requires_handover"] ?? false,
      allowBalance: json["allow_balance"] == true,
      balance: LeaveBalanceModel.fromJson(json["balance"] ?? {}),
      festivals: getFestivalsFromJson(json["festivals"] ?? []),
      policy: LeavePolicyModel.maybeFromJson(json["policy"]),
    );
  }
}

class LeavePolicyModel {
  const LeavePolicyModel({
    this.id,
    this.fullPayDays,
    this.halfPayDays,
    this.noPayDays,
    this.requiresDocumentAfterDays,
    this.requiresWeekendDocument = false,
    this.requiresAttachment = false,
    this.carryForward = false,
    this.encashment = false,
    this.probationApplicable = false,
    this.minimumServiceMonths,
    this.remarks,
  });

  final String? id;
  final int? fullPayDays;
  final int? halfPayDays;
  final int? noPayDays;
  final int? requiresDocumentAfterDays;
  final bool requiresWeekendDocument;
  final bool requiresAttachment;
  final bool carryForward;
  final bool encashment;
  final bool probationApplicable;
  final int? minimumServiceMonths;
  final String? remarks;

  static LeavePolicyModel? maybeFromJson(dynamic json) {
    if (json is Map) return LeavePolicyModel.fromJson(json);
    return null;
  }

  factory LeavePolicyModel.fromJson(Map json) {
    final remarks = json["remarks"]?.toString().trim();
    return LeavePolicyModel(
      id: json["id"]?.toString(),
      fullPayDays: _asInt(json["full_pay_days"]),
      halfPayDays: _asInt(json["half_pay_days"]),
      noPayDays: _asInt(json["no_pay_days"]),
      requiresDocumentAfterDays: _asInt(json["requires_document_after_days"]),
      requiresWeekendDocument: json["requires_weekend_document"] == true,
      requiresAttachment: json["requires_attachment"] == true,
      carryForward: json["carry_forward"] == true,
      encashment: json["encashment"] == true,
      probationApplicable: json["probation_applicable"] == true,
      minimumServiceMonths: _asInt(json["minimum_service_months"]),
      remarks: (remarks == null || remarks.isEmpty) ? null : remarks,
    );
  }
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

class LeaveBalanceModel {
  const LeaveBalanceModel({
    required this.total,
    required this.used,
    required this.balance,
    this.pending = 0,
  });

  final int total;
  final int used;
  final int balance;
  final int pending;

  factory LeaveBalanceModel.fromJson(Map json) {
    return LeaveBalanceModel(
      total: json["total"] ?? 0,
      used: json["used"] ?? 0,
      balance: json["balance"] ?? 0,
      pending: json["pending"] ?? 0,
    );
  }
}
