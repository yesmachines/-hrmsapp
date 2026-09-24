import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/service/model/document_file_model.dart';

class DocumentTypeCard extends GetView<DocumentTypesController> {
  const DocumentTypeCard({super.key, required this.document});

  final DocumentFileModel document;

  @override
  Widget build(BuildContext context) {

    final details = controller.documentDetails(document);
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
        children: [
          Row(
            children: [
              Icon(
                controller.iconForDocument(document),
                color: appColors.brandColor,
                size: appSize.icon20,
              ),
              SizedBox(width: appSize.size8.w),
              Expanded(
                child: Text(
                  document.displayTitle,
                  style: fontStyles.font14Black600,
                ),
              ),
              if (document.statusLabel.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: appSize.size10.w,
                    vertical: appSize.size4.h,
                  ),
                  decoration: BoxDecoration(
                    color: controller.statusBg(document),
                    borderRadius: BorderRadius.circular(appSize.radius60),
                  ),
                  child: Text(
                    document.statusLabel,
                    style: fontStyles.font10LightGrey500.copyWith(
                      color: controller.statusText(document),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: appSize.size12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: details.entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: appSize.size8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              entry.key,
                              style: fontStyles.font12LightGrey500.copyWith(
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              entry.value,
                              textAlign: TextAlign.right,
                              style: fontStyles.font12LightGrey500.copyWith(
                                color: appColors.blackColor,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: appSize.size12.w),
              Column(
                children: [
                  _ActionChip(
                    label: 'View',
                    icon: Icons.visibility_outlined,
                    background: appColors.profileIconBlueBg,
                    foreground: appColors.brandColor,
                    onTap: () => controller.onViewDocument(document),
                  ),
                  if (document.canEdit) ...[
                    SizedBox(height: appSize.size8.h),
                    _ActionChip(
                      label: 'Edit',
                      icon: Icons.edit_outlined,
                      background: appColors.profileIconOrangeBg,
                      foreground: appColors.orangeColor,
                      onTap: () => controller.onEditDocument(document),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(appSize.radius8),
      child: Container(
        width: 72.w,
        padding: EdgeInsets.symmetric(vertical: appSize.size8.h),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(appSize.radius8),
        ),
        child: Column(
          children: [
            Icon(icon, color: foreground, size: appSize.icon18),
            SizedBox(height: appSize.size2.h),
            Text(
              label,
              style: fontStyles.font10LightGrey500.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
