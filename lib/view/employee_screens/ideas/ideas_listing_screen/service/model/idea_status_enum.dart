enum IdeaStatus {
  approved,
  submitted,
  accepted,
  rejected;

  String get apiValue => name;

  String get label {
    switch (this) {
      case IdeaStatus.approved:
        return "Approved";
      case IdeaStatus.submitted:
        return "Submitted";
      case IdeaStatus.accepted:
        return "Accepted";
      case IdeaStatus.rejected:
        return "Rejected";
    }
  }

  static IdeaStatus fromString(dynamic value) {
    final status = value?.toString().trim().toLowerCase();
    return IdeaStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => IdeaStatus.submitted,
    );
  }
}
