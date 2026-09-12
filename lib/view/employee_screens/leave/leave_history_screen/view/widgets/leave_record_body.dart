import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../main.dart';
import '../../../../../../utils/loading_screen/loading_screen.dart';
import '../../../../../../utils/no_data_page/no_data_page.dart';
import '../../controller/controller.dart';
import 'leave_history_card.dart';

class LeaveRecordBody extends GetView<LeaveHistoryController> {
  const LeaveRecordBody({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.leave.value == null) {
      return const LoadingScreen();
    } else if (controller.leave.value != null &&
        controller.leave.value!.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          controller: controller.scrollController,
          padding: EdgeInsets.fromLTRB(
            appSize.size16.w,
            0,
            appSize.size16.w,
            appSize.size24.h,
          ),
          itemCount: controller.leave.value!.length,
          itemBuilder: (context, index) {
            return LeaveHistoryCard(record: controller.leave.value![index]);
          },
        ),
      );
    } else {
      return NoDataPage(
        message: "No leave records found",
        height: screenUtil.screenHeight / 2,
      );
    }
  }
}
