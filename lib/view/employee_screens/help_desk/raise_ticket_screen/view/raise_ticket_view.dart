import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/buttons/custom_button.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/help_desk/help_desk_listing_screen/service/model/ticket_model.dart';
import 'package:yes_hrm/view/employee_screens/help_desk/raise_ticket_screen/controller/controller.dart';

class RaiseTicketView extends GetView<RaiseTicketController> {
  const RaiseTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Raise New Ticket"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomButton(
        margin: EdgeInsets.symmetric(horizontal: appSize.size16.w),
        buttonWidth: double.infinity,
        buttonName: 'Submit Ticket',
        onPressed: controller.submitTicket,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            appSize.size16.w,
            appSize.size8.h,
            appSize.size16.w,
            100.h,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(appSize.size16.w),
            decoration: BoxDecoration(
              color: appColors.whiteColor,
              borderRadius: BorderRadius.circular(appSize.radius16),
              boxShadow: [
                BoxShadow(
                  color: appColors.blackColor.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ticket Details', style: fontStyles.font16Black700),
                SizedBox(height: appSize.size6.h),
                Text(
                  'Please fill in the information below to alert our HR support desk.',
                  style: fontStyles.font12LightGrey500.copyWith(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: appSize.size16.h),
                Text(
                  'Ticket Category',
                  style: fontStyles.font12LightGrey500.copyWith(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: appSize.size8.h),
                Obx(
                  () => _DropdownField(
                    value: controller.selectedCategory.value?.fullLabel ??
                        'Select category',
                    isPlaceholder: controller.selectedCategory.value == null,
                    onTap: controller.onCategoryTap,
                  ),
                ),
                SizedBox(height: appSize.size16.h),
                Text(
                  'Subject',
                  style: fontStyles.font12LightGrey500.copyWith(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: appSize.size8.h),
                CustomTextField(
                  controller: controller.subjectController,
                  hintText: 'Enter issue title',
                  radius: appSize.radius12,
                  maxLines: 1,
                ),
                SizedBox(height: appSize.size16.h),
                Text(
                  'Description',
                  style: fontStyles.font12LightGrey500.copyWith(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: appSize.size8.h),
                CustomTextField(
                  controller: controller.descriptionController,
                  hintText: 'Describe your issue in detail...',
                  radius: appSize.radius12,
                  minLines: 5,
                  maxLines: 8,
                  maxLength: 500,
                ),
                SizedBox(height: appSize.size16.h),
                Text(
                  'Attachment',
                  style: fontStyles.font12LightGrey500.copyWith(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: appSize.size8.h),
                Obx(() {
                  final file = controller.attachment.value;
                  if (file != null) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(appSize.size12.w),
                      decoration: BoxDecoration(
                        color: appColors.scaffoldGreyColor,
                        borderRadius: BorderRadius.circular(appSize.radius12),
                        border: Border.all(color: appColors.strokeColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.attach_file_rounded,
                            color: appColors.brandColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: appSize.size8.w),
                          Expanded(
                            child: Text(
                              file.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: fontStyles.font14Black600,
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.removeAttachment,
                            child: Icon(
                              Icons.close_rounded,
                              size: 18.sp,
                              color: appColors.lightGreyColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return InkWell(
                    onTap: controller.pickAttachment,
                    borderRadius: BorderRadius.circular(appSize.radius16),
                    child: CustomPaint(
                      painter: _DashedBorderPainter(
                        color: appColors.strokeColor,
                        radius: appSize.radius16,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: appSize.size20.h,
                          horizontal: appSize.size16.w,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_file_rounded,
                                  color: appColors.brandColor,
                                  size: 18.sp,
                                ),
                                SizedBox(width: appSize.size6.w),
                                Text(
                                  'Attach File',
                                  style: fontStyles.font14Brand700,
                                ),
                              ],
                            ),
                            SizedBox(height: appSize.size6.h),
                            Text(
                              'Upload supporting document or screenshot (Max 5MB)',
                              textAlign: TextAlign.center,
                              style: fontStyles.font12LightGrey500.copyWith(
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.onTap,
    this.isPlaceholder = false,
  });

  final String value;
  final VoidCallback onTap;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size14.w,
          vertical: appSize.size14.h,
        ),
        decoration: BoxDecoration(
          color: appColors.whiteColor,
          borderRadius: BorderRadius.circular(appSize.radius12),
          border: Border.all(color: appColors.strokeColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: isPlaceholder
                    ? fontStyles.font14LightGrey400
                    : fontStyles.font14Black600,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: appColors.lightGreyColor,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    final dashed = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + 6;
        dashed.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + 4;
      }
    }
    canvas.drawPath(dashed, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
