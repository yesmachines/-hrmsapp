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

  static LeaveStatus fromString(dynamic value) {
    switch (value?.toString().trim().toLowerCase()) {
      case 'approved':
        return LeaveStatus.approved;
      case 'rejected':
        return LeaveStatus.rejected;
      case 'pending':
      case 'applied':
      case 'requested':
      default:
        return LeaveStatus.requested;
    }
  }
}
