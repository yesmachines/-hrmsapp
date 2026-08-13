import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/view/employee_screens/employee_documents/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/employee_documents/view/widgets/employee_document_card.dart';

class EmployeeDocSectionWidget extends GetView<EmployeeDocumentsController> {
  const EmployeeDocSectionWidget({super.key, required this.section});

  final EmployeeDocSection section;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final expanded = controller.isExpanded(section.id);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => controller.toggleSection(section.id),
            borderRadius: BorderRadius.circular(appSize.radius8),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: appSize.size8.h),
              child: Row(
                children: [
                  Icon(
                    section.icon,
                    color: appColors.brandColor,
                    size: appSize.icon20,
                  ),
                  SizedBox(width: appSize.size8.w),
                  Expanded(
                    child: Text(
                      section.title,
                      style: fontStyles.font14Black600.copyWith(
                        color: appColors.brandColor,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: appColors.brandColor,
                    size: appSize.icon24,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            SizedBox(height: appSize.size4.h),
            ...section.documents.map(
              (doc) => Padding(
                padding: EdgeInsets.only(bottom: appSize.size12.h),
                child: EmployeeDocumentCard(document: doc),
              ),
            ),
          ],
        ],
      );
    });
  }
}
