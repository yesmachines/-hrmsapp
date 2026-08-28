enum LeaveType { annualLeave, sickLeave }

extension LeaveTypeExtenstion on LeaveType {
  String get label {
    switch (this) {
      case LeaveType.annualLeave:
        return "Annual Leave";
      case LeaveType.sickLeave:
        return "Sick Leave";
    }
  }
}
