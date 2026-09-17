import 'dart:io';

import 'package:image_picker/image_picker.dart';

enum LeaveApplyKind {
  annual,
  sick,
  compassionate,
  festival,
  maternity,
  parental,
  pilgrimage,
  compensatory,
  unpaid,
  other,
}

LeaveApplyKind leaveApplyKindFromName(String? name) {
  return leaveApplyKindFromType(name: name);
}

LeaveApplyKind leaveApplyKindFromType({String? code, String? name}) {
  switch ((code ?? '').trim().toUpperCase()) {
    case 'ANNUAL':
      return LeaveApplyKind.annual;
    case 'SICK':
      return LeaveApplyKind.sick;
    case 'COMPASSIONATE':
      return LeaveApplyKind.compassionate;
    case 'FESTIVAL':
      return LeaveApplyKind.festival;
    case 'MATERNITY':
      return LeaveApplyKind.maternity;
    case 'PARENTAL':
    case 'PATERNITY':
      return LeaveApplyKind.parental;
    case 'PILGRIMAGE':
    case 'HAJJ':
      return LeaveApplyKind.pilgrimage;
    case 'COMPENSATORY':
    case 'COMP':
      return LeaveApplyKind.compensatory;
    case 'UNPAID':
      return LeaveApplyKind.unpaid;
  }

  final value = name?.trim().toLowerCase() ?? '';
  if (value.contains('annual')) return LeaveApplyKind.annual;
  if (value.contains('sick')) return LeaveApplyKind.sick;
  if (value.contains('compassionate')) return LeaveApplyKind.compassionate;
  if (value.contains('festival')) return LeaveApplyKind.festival;
  if (value.contains('maternity')) return LeaveApplyKind.maternity;
  if (value.contains('parental') || value.contains('paternity')) {
    return LeaveApplyKind.parental;
  }
  if (value.contains('pilgrimage') || value.contains('hajj')) {
    return LeaveApplyKind.pilgrimage;
  }
  if (value.contains('compensatory') || value.contains('comp')) {
    return LeaveApplyKind.compensatory;
  }
  if (value.contains('unpaid')) return LeaveApplyKind.unpaid;
  return LeaveApplyKind.other;
}

class LeaveApplyValidationInput {
  const LeaveApplyValidationInput({
    this.leaveTypeCode,
    required this.leaveTypeName,
    required this.startDate,
    required this.endDate,
    required this.remarks,
    required this.remainingBalance,
    required this.appliedDays,
    required this.includesWeekend,
    this.certificates = const [],
    this.handoverPersonId,
    this.handoverPerson,
    this.handoverDescription,
    this.personalContact,
    this.emergencyContact,
    this.requiresHandover = false,
    this.isTravellingOutside = false,
    this.destination,
    this.travelContact,
    this.declarationSigned = false,
    this.relative,
    this.relativeDayLimit,
    this.alreadyTakenFestivalThisYear = false,
    this.nationalityMatched = true,
    this.religionMatched = true,
    this.dueDate,
    this.doctorLetter = const [],
    this.childBirthDate,
    this.childAgeMonths,
    this.festivalId,
    this.alreadyTakenPilgrimage = false,
    this.hasExistingAttachment = false,
    this.policyRequiresAttachment = false,
    this.requiresWeekendDocument = false,
    this.requiresDocumentAfterDays,
  });

  final String? leaveTypeCode;
  final String? leaveTypeName;
  final DateTime? startDate;
  final DateTime? endDate;
  final String remarks;
  final int remainingBalance;
  final int appliedDays;
  final bool includesWeekend;
  final List<XFile> certificates;
  final String? handoverPersonId;
  final String? handoverPerson;
  final String? handoverDescription;
  final bool requiresHandover;
  final String? personalContact;
  final String? emergencyContact;
  final bool isTravellingOutside;
  final String? destination;
  final String? travelContact;
  final bool declarationSigned;
  final String? relative;
  final int? relativeDayLimit;
  final bool alreadyTakenFestivalThisYear;
  final bool nationalityMatched;
  final bool religionMatched;
  final DateTime? dueDate;
  final List<XFile> doctorLetter;
  final DateTime? childBirthDate;
  final int? childAgeMonths;
  final String? festivalId;
  final bool alreadyTakenPilgrimage;
  final bool hasExistingAttachment;
  final bool policyRequiresAttachment;
  final bool requiresWeekendDocument;
  final int? requiresDocumentAfterDays;
}

class LeaveApplyValidationResult {
  const LeaveApplyValidationResult.valid() : isValid = true, message = null;

  const LeaveApplyValidationResult.invalid(this.message) : isValid = false;

  final bool isValid;
  final String? message;
}

/// Validates apply-leave form against leave-type business rules.
LeaveApplyValidationResult validateLeaveApply(LeaveApplyValidationInput input) {
  LeaveApplyKind kind = leaveApplyKindFromType(
    code: input.leaveTypeCode,
    name: input.leaveTypeName,
  );
  if (input.startDate == null || input.endDate == null) {
    return const LeaveApplyValidationResult.invalid(
      'Select start and end date',
    );
  }

  if (input.endDate!.isBefore(input.startDate!)) {
    return const LeaveApplyValidationResult.invalid(
      'End date cannot be before start date',
    );
  }

  if (input.remarks.trim().isEmpty) {
    return const LeaveApplyValidationResult.invalid(
      'Enter remarks to continue',
    );
  }

  if ( input.appliedDays <= 0) {
    return const LeaveApplyValidationResult.invalid('Invalid leave duration');
  }

  if (kind != LeaveApplyKind.unpaid &&input.appliedDays > input.remainingBalance) {
    return const LeaveApplyValidationResult.invalid('Insufficient Balance');
  }

  if (input.leaveTypeName == null || input.leaveTypeName!.trim().isEmpty) {
    return const LeaveApplyValidationResult.invalid(
      'Select leave type to continue',
    );
  }

  if (input.requiresHandover || kind == LeaveApplyKind.annual) {
    final handoverResult = _validateHandover(input);
    if (!handoverResult.isValid) return handoverResult;
  }

  final documentResult = _validatePolicyDocuments(input);
  if (!documentResult.isValid) return documentResult;

  switch (kind) {
    case LeaveApplyKind.annual:
      return const LeaveApplyValidationResult.valid();
    case LeaveApplyKind.sick:
      return _validateSick(input);
    case LeaveApplyKind.compassionate:
      return _validateCompassionate(input);
    case LeaveApplyKind.festival:
      return _validateFestival(input);
    case LeaveApplyKind.maternity:
      return _validateMaternity(input);
    case LeaveApplyKind.parental:
      return _validateParental(input);
    case LeaveApplyKind.pilgrimage:
      return _validatePilgrimage(input);
    case LeaveApplyKind.compensatory:
    case LeaveApplyKind.unpaid:
      return const LeaveApplyValidationResult.valid();
    case LeaveApplyKind.other:
      return const LeaveApplyValidationResult.valid();
  }
}

LeaveApplyValidationResult _validateHandover(LeaveApplyValidationInput input) {
  if (_isBlank(input.handoverPersonId) && _isBlank(input.handoverPerson)) {
    return const LeaveApplyValidationResult.invalid('Select handover person');
  }
  if (_isBlank(input.handoverDescription)) {
    return const LeaveApplyValidationResult.invalid(
      'Enter handover description',
    );
  }
  if (_isBlank(input.personalContact)) {
    return const LeaveApplyValidationResult.invalid(
      'Enter personal contact number',
    );
  }
  if (_isBlank(input.emergencyContact)) {
    return const LeaveApplyValidationResult.invalid(
      'Enter emergency local contact number',
    );
  }

  if (input.isTravellingOutside) {
    if (_isBlank(input.destination)) {
      return const LeaveApplyValidationResult.invalid(
        'Enter travel destination',
      );
    }
    if (_isBlank(input.travelContact)) {
      return const LeaveApplyValidationResult.invalid(
        'Enter travel contact number',
      );
    }
  } else if (!input.declarationSigned) {
    return const LeaveApplyValidationResult.invalid(
      'Sign declaration of availability to continue',
    );
  }

  return const LeaveApplyValidationResult.valid();
}

LeaveApplyValidationResult _validatePolicyDocuments(
  LeaveApplyValidationInput input,
) {
  final needsDocument =
      input.policyRequiresAttachment ||
      (input.requiresWeekendDocument && input.includesWeekend) ||
      (input.requiresDocumentAfterDays != null &&
          input.appliedDays > input.requiresDocumentAfterDays!);

  if (needsDocument && !_hasSupportingDocument(input)) {
    return const LeaveApplyValidationResult.invalid(
      'Upload supporting document to continue',
    );
  }
  if (_hasOversizedCertificate([
    ...input.certificates,
    ...input.doctorLetter,
  ])) {
    return const LeaveApplyValidationResult.invalid(
      'Certificate must be 10MB or smaller',
    );
  }
  return const LeaveApplyValidationResult.valid();
}

bool _hasSupportingDocument(LeaveApplyValidationInput input) {
  return input.certificates.isNotEmpty ||
      input.doctorLetter.isNotEmpty ||
      input.hasExistingAttachment;
}

LeaveApplyValidationResult _validateSick(LeaveApplyValidationInput input) {
  final hasPolicyDocumentRules =
      input.policyRequiresAttachment ||
      input.requiresWeekendDocument ||
      input.requiresDocumentAfterDays != null;
  if (hasPolicyDocumentRules) {
    return const LeaveApplyValidationResult.valid();
  }

  final needsCertificate = input.appliedDays > 2 || input.includesWeekend;
  if (needsCertificate && !_hasSupportingDocument(input)) {
    return const LeaveApplyValidationResult.invalid(
      'Upload medical certificate for leave more than 2 days or including weekend',
    );
  }
  return const LeaveApplyValidationResult.valid();
}

LeaveApplyValidationResult _validateCompassionate(
  LeaveApplyValidationInput input,
) {
  if (_isBlank(input.relative)) {
    return const LeaveApplyValidationResult.invalid('Select relative');
  }
  final limit = input.relativeDayLimit;
  if (limit != null && input.appliedDays > limit) {
    return LeaveApplyValidationResult.invalid(
      'Compassionate leave for ${input.relative} is limited to $limit days',
    );
  }
  return const LeaveApplyValidationResult.valid();
}

LeaveApplyValidationResult _validateFestival(LeaveApplyValidationInput input) {
  if (input.alreadyTakenFestivalThisYear) {
    return const LeaveApplyValidationResult.invalid(
      'Festival leave already taken this year',
    );
  }
  if (!input.nationalityMatched || !input.religionMatched) {
    return const LeaveApplyValidationResult.invalid(
      'Festival leave is not available for your nationality/religion',
    );
  }
  if (_isBlank(input.festivalId)) {
    return const LeaveApplyValidationResult.invalid('Select festival');
  }
  return const LeaveApplyValidationResult.valid();
}

LeaveApplyValidationResult _validateMaternity(LeaveApplyValidationInput input) {
  if (input.dueDate == null) {
    return const LeaveApplyValidationResult.invalid('Enter due date');
  }
  if (input.doctorLetter.isEmpty &&
      input.certificates.isEmpty &&
      !input.hasExistingAttachment) {
    return const LeaveApplyValidationResult.invalid(
      "Upload doctor's letter to continue",
    );
  }
  if (_hasOversizedCertificate([
    ...input.doctorLetter,
    ...input.certificates,
  ])) {
    return const LeaveApplyValidationResult.invalid(
      'Certificate must be 10MB or smaller',
    );
  }
  return const LeaveApplyValidationResult.valid();
}

LeaveApplyValidationResult _validateParental(LeaveApplyValidationInput input) {
  final birthDate = input.childBirthDate;
  if (birthDate == null) {
    if (input.childAgeMonths == null) {
      return const LeaveApplyValidationResult.invalid(
        "Enter child's birth date",
      );
    }
    if (input.childAgeMonths! >= 6) {
      return const LeaveApplyValidationResult.invalid(
        'Parental leave is only allowed when child age is less than 6 months',
      );
    }
    return const LeaveApplyValidationResult.valid();
  }

  final today = DateTime.now();
  final birth = DateTime(birthDate.year, birthDate.month, birthDate.day);
  final now = DateTime(today.year, today.month, today.day);
  if (birth.isAfter(now)) {
    return const LeaveApplyValidationResult.invalid(
      'Child birth date cannot be in the future',
    );
  }
  if (!_isChildUnderSixMonths(birth, now)) {
    return const LeaveApplyValidationResult.invalid(
      'Parental leave is only allowed when child age is less than 6 months',
    );
  }
  return const LeaveApplyValidationResult.valid();
}

LeaveApplyValidationResult _validatePilgrimage(
  LeaveApplyValidationInput input,
) {
  if (input.alreadyTakenPilgrimage) {
    return const LeaveApplyValidationResult.invalid(
      'Pilgrimage leave already taken during tenure',
    );
  }
  return const LeaveApplyValidationResult.valid();
}

bool _isBlank(String? value) => value == null || value.trim().isEmpty;

bool _hasOversizedCertificate(List<XFile> files) {
  const maxBytes = 10 * 1024 * 1024;
  for (final file in files) {
    try {
      if (File(file.path).lengthSync() > maxBytes) return true;
    } catch (_) {
      return true;
    }
  }
  return false;
}

bool _isChildUnderSixMonths(DateTime birth, DateTime today) {
  final sixMonthsAgo = DateTime(today.year, today.month - 6, today.day);
  return !birth.isBefore(sixMonthsAgo);
}

bool leaveRangeIncludesWeekend(DateTime start, DateTime end) {
  var day = DateTime(start.year, start.month, start.day);
  final last = DateTime(end.year, end.month, end.day);
  while (!day.isAfter(last)) {
    if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
      return true;
    }
    day = day.add(const Duration(days: 1));
  }
  return false;
}

String sickLeavePayTier({
  required int appliedDays,
  required int usedSickDays,
  int? fullPayDays,
  int? halfPayDays,
}) {
  final full = fullPayDays ?? 15;
  final half = halfPayDays ?? 30;
  final totalUsedAfter = usedSickDays + appliedDays;
  if (totalUsedAfter <= full) return 'Full Pay';
  if (totalUsedAfter <= full + half) return 'Half Pay';
  return 'No Pay';
}
