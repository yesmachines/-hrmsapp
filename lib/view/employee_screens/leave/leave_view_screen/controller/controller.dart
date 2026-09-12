import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/attachment_viewer/attachment_viewer.dart';
import 'package:yes_hrm/view/employee_screens/leave/leave_view_screen/service/service.dart';
import 'package:yes_hrm/view/employee_screens/leave/model/leave_model.dart';
import 'package:yes_hrm/view/employee_screens/leave/model/leave_status_enum.dart';
import 'package:yes_hrm/view/employee_screens/leave/model/leave_type_model.dart';

class LeaveViewController extends GetxController with Bindings {
  final Rxn<LeaveModel> leave = Rxn(null);
  final RxBool hasError = false.obs;
  late String leaveId;

  @override
  void onInit() {
    leaveId = Get.arguments;
    super.onInit();
  }

  String formatDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  LeaveTypeStyle typeStyle(LeaveType type) {
    switch (type.leaveType.toLowerCase()) {
      case "annual leave":
        return LeaveTypeStyle(
          bg: appColors.submittedBadgeBg,
          text: appColors.submittedBadgeText,
        );
      case "sick leave":
        return LeaveTypeStyle(
          bg: appColors.profileIconPurpleBg,
          text: appColors.profileIconPurple,
        );
      default:
        return LeaveTypeStyle(
          bg: appColors.profileIconTealBg,
          text: appColors.profileIconTeal,
        );
    }
  }

  Color statusBg(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.requested:
        return appColors.pendingBadgeBg;
      case LeaveStatus.approved:
        return appColors.activeBadgeBg;
      case LeaveStatus.rejected:
        return appColors.rejectedBadgeBg;
    }
  }

  Color statusText(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.requested:
        return appColors.pendingBadgeText;
      case LeaveStatus.approved:
        return appColors.activeBadgeText;
      case LeaveStatus.rejected:
        return appColors.rejectedBadgeText;
    }
  }

  List<Color> statusGradient(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.requested:
        return [appColors.orangeColor, appColors.lightOrangeColor];
      case LeaveStatus.approved:
        return [appColors.profileIconGreen, appColors.checkOutGreen];
      case LeaveStatus.rejected:
        return [appColors.expiredBadgeText, appColors.tileRed];
    }
  }

  String yesNo(bool? value) {
    if (value == null) return '-';
    return value ? 'Yes' : 'No';
  }

  Future<LeaveModel> getLeave() async {
    hasError.value = false;
    return LeaveViewService.getLeave(id: leaveId)
        .then((value) {
          leave.value = value;
          return value;
        })
        .onError((error, stackTrace) {
          if (leave.value == null) {
            hasError.value = true;
          }
          throw Exception("");
        });
  }

  void onViewAttachment(LeaveAttachment file) {
    openAttachmentViewer(url: file.url, name: file.name);
  }

  void onEdit() {
    final record = leave.value;
    if (record == null || !record.canEdit) {
      notificationHandler.sendNotification(
        message: 'Only requested leaves can be edited',
        notificationType: .warning,
      );
      return;
    }
    Get.toNamed(appRoutes.applyLeave, arguments: record.id)?.then((value) {
      if (value == true) {
        leave.value = null;
        getLeave();
      }
    });
  }

  @override
  void dependencies() {
    Get.put(LeaveViewController());
  }
}
