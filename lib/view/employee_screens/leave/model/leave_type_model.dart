class LeaveType {
  LeaveType({required this.id, required this.leaveType});

  final String id;
  final String leaveType;

  factory LeaveType.fromJson(Map json) {
    return LeaveType(
      id: (json["id"] ?? "").toString(),
      leaveType: (json["leave_name"] ?? json["name"] ?? "Leave").toString(),
    );
  }
}