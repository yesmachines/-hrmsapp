import 'package:flutter/material.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/service/model/leave_meta_model.dart';
import 'package:yes_hrm/view/employee_screens/leave/apply_leave_screen/view/widgets/apply_leave_info_card.dart';

class LeavePolicyCard extends StatelessWidget {
  const LeavePolicyCard({super.key, required this.policy});

  final LeavePolicyModel policy;

  @override
  Widget build(BuildContext context) {
    final lines = _policyLines(policy);
    if (lines.isEmpty) return const SizedBox.shrink();

    return ApplyLeaveInfoCard(
      title: 'Leave Policy',
      icon: Icons.policy_outlined,
      accent: appColors.submittedBadgeText,
      background: appColors.submittedBadgeBg,
      children: [
        for (final line in lines)
          ApplyLeaveBullet(text: line, color: const Color(0xFF1D4ED8)),
      ],
    );
  }
}

List<String> _policyLines(LeavePolicyModel policy) {
  final lines = <String>[];

  if (policy.fullPayDays != null) {
    lines.add(
      '${policy.fullPayDays} full pay ${_daysWord(policy.fullPayDays!)} available for this leave',
    );
  }
  if (policy.halfPayDays != null) {
    lines.add(
      '${policy.halfPayDays} half pay ${_daysWord(policy.halfPayDays!)} available for this leave',
    );
  }
  if (policy.noPayDays != null) {
    lines.add(
      '${policy.noPayDays} no pay ${_daysWord(policy.noPayDays!)} available for this leave',
    );
  }
  if (policy.requiresDocumentAfterDays != null) {
    lines.add(
      'Documents are mandatory after ${policy.requiresDocumentAfterDays} ${_daysWord(policy.requiresDocumentAfterDays!)}',
    );
  }
  if (policy.requiresWeekendDocument) {
    lines.add(
      'A document is needed if a weekend is included in the leave range',
    );
  }
  if (policy.requiresAttachment) {
    lines.add('A supporting document is required');
  }
  if (policy.carryForward) {
    lines.add('Unused leave days can be carried forward');
  }
  if (policy.encashment) {
    lines.add('Unused leave days can be cashed out');
  }
  lines.add(
    policy.probationApplicable
        ? 'Employees on probation can apply for this leave'
        : 'Employees on probation cannot apply for this leave',
  );
  if (policy.minimumServiceMonths != null &&
      policy.minimumServiceMonths! > 0) {
    lines.add(
      '${policy.minimumServiceMonths} ${_monthsWord(policy.minimumServiceMonths!)} of service required to avail this leave',
    );
  }
  if (policy.remarks != null) {
    lines.add('Remark: ${policy.remarks}');
  }

  return lines;
}

String _daysWord(int count) => count == 1 ? 'day' : 'days';

String _monthsWord(int count) => count == 1 ? 'month' : 'months';
