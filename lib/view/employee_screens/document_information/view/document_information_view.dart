import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';

import '../controller/controller.dart';
import 'widgets/document_card.dart';

class DocumentInformationView extends GetView<DocumentInformationController> {
  const DocumentInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      body: SafeArea(
        child: Column(
          children: [
            _DocumentInfoAppBar(),
            Expanded(
              child: Obx(() {
                final documents = controller.documents;
                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    appSize.size16.w,
                    appSize.size8.h,
                    appSize.size16.w,
                    appSize.size24.h,
                  ),
                  itemCount: documents.length + 1,
                  separatorBuilder: (_, _) => SizedBox(height: appSize.size12.h),
                  itemBuilder: (context, index) {
                    if (index == documents.length) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: appSize.size8.h,
                          bottom: appSize.size8.h,
                        ),
                        child: Text(
                          'Documents are synchronized from the YES Documents module.',
                          textAlign: TextAlign.center,
                          style: fontStyles.font12LightGrey500.copyWith(
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }
                    return DocumentCard(document: documents[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentInfoAppBar extends GetView<DocumentInformationController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: appSize.size8.w,
        vertical: appSize.size8.h,
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
              'Document Information',
              textAlign: TextAlign.center,
              style: fontStyles.font16Black700,
            ),
          ),
          InkWell(
            onTap: controller.toggleEdit,
            borderRadius: BorderRadius.circular(appSize.radius60),
            child: SizedBox(
              width: appSize.size44.w,
              height: appSize.size44.w,
              child: Icon(
                Icons.edit_outlined,
                color: appColors.brandColor,
                size: appSize.icon24,
              ),
            ),
          ),
          SizedBox(width: appSize.size4.w),
        ],
      ),
    );
  }
}
