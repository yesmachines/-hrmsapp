import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/employee_documents/controller/controller.dart';

class EmployeeDocumentCard extends GetView<EmployeeDocumentsController> {
  const EmployeeDocumentCard({super.key, required this.document});

  final EmployeeDocItem document;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(appSize.size14.w),
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.circular(appSize.radius16),
        boxShadow: [
          BoxShadow(
            color: appColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: appSize.size36.w,
                height: appSize.size36.w,
                decoration: BoxDecoration(
                  color: appColors.profileIconBlueBg,
                  borderRadius: BorderRadius.circular(appSize.radius8),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: appColors.brandColor,
                  size: appSize.icon18,
                ),
              ),
              SizedBox(width: appSize.size10.w),
              Expanded(
                child: Text(document.title, style: fontStyles.font14Black600),
              ),
              if (document.status != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: appSize.size10.w,
                    vertical: appSize.size4.h,
                  ),
                  decoration: BoxDecoration(
                    color: controller.approvedBadgeBg,
                    borderRadius: BorderRadius.circular(appSize.radius60),
                  ),
                  child: Text(
                    document.status!,
                    style: fontStyles.font10LightGrey500.copyWith(
                      color: controller.approvedBadgeText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          ...document.details.entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: appSize.size6.h),
              child: Row(
                children: [
                  Text(
                    '${entry.key}: ',
                    style: fontStyles.font12LightGrey500.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: fontStyles.font12LightGrey500.copyWith(
                        color: appColors.blackColor,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: appSize.size8.h),
          Row(
            children: [
              _ActionButton(
                label: 'View',
                icon: Icons.visibility_outlined,
                onTap: () => controller.onViewDocument(document),
              ),
              if (document.canEdit) ...[
                SizedBox(width: appSize.size8.w),
                _ActionButton(
                  label: 'Edit',
                  icon: Icons.edit_outlined,
                  onTap: () => controller.onEditDocument(document),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: appSize.size12.w,
          vertical: appSize.size8.h,
        ),
        decoration: BoxDecoration(
          color: appColors.whiteColor,
          borderRadius: BorderRadius.circular(appSize.radius8),
          border: Border.all(color: appColors.strokeColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: appSize.icon16, color: appColors.mediumGreyColor),
            SizedBox(width: appSize.size4.w),
            Text(
              label,
              style: fontStyles.font12LightGrey500.copyWith(
                letterSpacing: 0,
                color: appColors.mediumGreyColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
