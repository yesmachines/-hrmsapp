import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../controller/controller.dart';
import 'contact_info_row.dart';

class InfoCard extends GetView<ContactInformationController> {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: appSize.size16.w,
        vertical: appSize.size4.h,
      ),
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.circular(appSize.radius20),
        boxShadow: [
          BoxShadow(
            color: appColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final fields = controller.fields;
        return Column(
          children: List.generate(fields.length, (index) {
            return ContactInfoRow(
              field: fields[index],
              showDivider: index != fields.length - 1,
            );
          }),
        );
      }),
    );
  }
}
