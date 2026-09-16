import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/dashboard/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/documents/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/documents/view/widgets/document_category_card.dart';
import 'package:yes_hrm/view/employee_screens/documents/view/widgets/document_loading_screen.dart';

class DocumentsView extends GetView<DocumentsController> {
  const DocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: appColors.scaffoldGreyColor,
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
                  onTap: () {
                    if (Get.isRegistered<EmployeeDashboardController>()) {
                      Get.find<EmployeeDashboardController>().onNavTap(0);
                    }
                  },
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
                Text('Documents', style: fontStyles.font20Black700Fixed),
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
              contentPadding: EdgeInsets.symmetric(vertical: appSize.size14.h),
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
          SizedBox(height: appSize.size16.h),
          Expanded(
            child: Obx(
                  () => FutureBuilder(
                future: controller.documentsList.value == null
                    ? controller.getDocuments()
                    : null,
                builder: (context, snapshot) {
                  if (controller.documentsList.value == null &&
                      controller.hasError.value == false) {
                    return const DocumentLoadingWidget();
                  } else if (controller.documentsList.value != null &&
                      controller.documentsList.value!.isNotEmpty) {

                    final categories = controller.filteredCategories;

                    if (categories.isEmpty) {
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
                        appSize.size100.h,
                      ),
                      itemCount: categories.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: appSize.size12.h),
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        return DocumentCategoryCard(
                          category: category,
                          onTap: () => controller.onCategoryTap(category),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        'No documents found',
                        style: fontStyles.font14LightGrey400,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
