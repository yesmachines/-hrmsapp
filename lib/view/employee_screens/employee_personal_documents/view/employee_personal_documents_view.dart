import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';

import '../../profile/view/widgets/profile_loading_widget.dart';
import '../controller/controller.dart';
import 'widgets/document_filter_chip.dart';
import 'widgets/personal_document_card.dart';

class EmployeePersonalDocumentsView
    extends GetView<EmployeePersonalDocumentsController> {
  const EmployeePersonalDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onAddDocument,
        backgroundColor: appColors.brandColor,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: appColors.whiteColor, size: appSize.icon26),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                appSize.size8.w,
                appSize.size8.h,
                appSize.size16.w,
                appSize.size8.h,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: Get.back,
                    borderRadius: BorderRadius.circular(appSize.radius60),
                    child: SizedBox(
                      width: appSize.size44.w,
                      height: appSize.size44.w,
                      child: Center(
                        child: ImageHandler(
                          imageType: ImageType.svg,
                          imageUrl: iconData.arrowLeftIconSvg,
                          width: appSize.icon20,
                          height: appSize.icon20,
                          svgImageColor: appColors.blackColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Employee Personal Documents',
                      style: fontStyles.font16Black700,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: appSize.size16.w),
              child: CustomTextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                hintText: 'Search documents...',
                maxLines: 1,
                radius: appSize.radius12,
                contentPadding: EdgeInsets.symmetric(
                  vertical: appSize.size14.h,
                ),
                decoration: BoxDecoration(
                  color: appColors.whiteColor,
                  borderRadius: BorderRadius.circular(appSize.radius12),
                  border: Border.all(color: appColors.strokeColor),
                ),
                prefix: Icon(
                  Icons.search_rounded,
                  color: appColors.lightGreyColor,
                  size: appSize.icon20,
                ),
              ),
            ),
            SizedBox(height: appSize.size12.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: appSize.size16.w),
              child: Obx(
                () => Row(
                  children: [
                    DocumentFilterChip(label: controller.selectedCategory.value),
                    SizedBox(width: appSize.size8.w),
                    DocumentFilterChip(label: controller.selectedYear.value),
                    SizedBox(width: appSize.size8.w),
                    DocumentFilterChip(label: controller.selectedMonth.value),
                    SizedBox(width: appSize.size8.w),
                    DocumentFilterChip(label: controller.selectedDate.value),
                  ],
                ),
              ),
            ),
            SizedBox(height: appSize.size16.h),
            Expanded(
              child: Obx(() =>
                  FutureBuilder(
                    future: controller.personalDocument.value == null
                      ? controller.getPersonalDocument()
                      : null,
                    builder: (context, snapshot) {
                      if (controller.personalDocument.value == null &&
                          controller.hasError.value == false) {
                        return const ProfileLoadingWidget();
                      } else if (controller.personalDocument.value != null &&
                          controller.personalDocument.value!.isNotEmpty) {
                        final docs = controller.filteredDocuments;
                        if (docs.isEmpty) {
                          return Center(
                            child: Text(
                              'No documents found',
                              style: fontStyles.font14LightGrey400,
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                            appSize.size16.w,
                            0,
                            appSize.size16.w,
                            appSize.size90.h,
                          ),
                          itemCount: docs.length,
                          separatorBuilder: (_, _) =>
                              SizedBox(height: appSize.size12.h),
                          itemBuilder: (context, index) {
                            return PersonalDocumentCard(document: docs[index]);
                          },
                        );
                      } else{
                        return Center(
                          child: Text(
                            'No documents found',
                            style: fontStyles.font14LightGrey400,
                          ),
                        );
                      }
                    }
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
