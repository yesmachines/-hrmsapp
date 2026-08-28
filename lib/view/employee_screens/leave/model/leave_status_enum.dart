enum LeaveStatus { requested, approved, rejected }

extension LeaveStatusEnum on LeaveStatus {
  String get label {
    switch (this) {
      case LeaveStatus.requested:
        return "Requested";
      case LeaveStatus.approved:
        return "Approved";
      case LeaveStatus.rejected:
        return "Rejected";
    }
  }
}
