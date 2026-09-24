import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/view/widgets/document_type_card.dart';
import 'package:yes_hrm/view/employee_screens/documents/document_types/view/widgets/document_type_loading_screen.dart';

class DocumentTypesView extends GetView<DocumentTypesController> {
  const DocumentTypesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      floatingActionButton: controller.canAddDocument
          ? FloatingActionButton(
              onPressed: controller.onAddDocument,
              backgroundColor: appColors.brandColor,
              shape: const CircleBorder(),
              child: Icon(
                Icons.add,
                color: appColors.whiteColor,
                size: appSize.icon26,
              ),
            )
          : null,
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
                      controller.categoryName,
                      style: fontStyles.font16Black700,
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: appSize.size16.w),
            //   child: CustomTextField(
            //     controller: controller.searchController,
            //     onChanged: controller.onSearchChanged,
            //     hintText: 'Search documents...',
            //     maxLines: 1,
            //     radius: appSize.radius12,
            //     contentPadding: EdgeInsets.symmetric(
            //       vertical: appSize.size14.h,
            //     ),
            //     decoration: BoxDecoration(
            //       color: appColors.whiteColor,
            //       borderRadius: BorderRadius.circular(appSize.radius12),
            //       border: Border.all(color: appColors.strokeColor),
            //     ),
            //     prefix: Icon(
            //       Icons.search_rounded,
            //       color: appColors.lightGreyColor,
            //       size: appSize.icon20,
            //     ),
            //   ),
            // ),
            SizedBox(height: appSize.size16.h),
            Expanded(
              child: Obx(
                () => FutureBuilder(
                  future: controller.documents.value == null
                      ? controller.getDocuments()
                      : null,
                  builder: (context, snapshot) {
                    if (controller.documents.value == null &&
                        controller.hasError.value == false) {
                      return const DocumentTypeLoadingWidget();
                    } else if (controller.documents.value != null &&
                        controller.documents.value!.isNotEmpty) {
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
                          return DocumentTypeCard(document: docs[index]);
                        },
                      );
                    } else {
                      return NoDataPage(message: "No ${controller.categoryName} Found",);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
