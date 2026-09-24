import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/image_handler/image_handler.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/utils/textfield/custom_textfield.dart';
import 'package:yes_hrm/view/employee_screens/documents/letter_requests/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/documents/letter_requests/view/widgets/letter_request_card.dart';
import 'package:yes_hrm/view/employee_screens/documents/letter_requests/view/widgets/letter_request_loading_screen.dart';

class LetterRequestsView extends GetView<LetterRequestsController> {
  const LetterRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onAddRequest,
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
                  Text('Letter Requests', style: fontStyles.font16Black700),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: appSize.size16.w),
              child: CustomTextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                hintText: 'Search letter requests...',
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
            SizedBox(height: appSize.size16.h),
            Expanded(
              child: Obx(
                () => FutureBuilder(
                  future: controller.requests.value == null
                      ? controller.getLetterRequests()
                      : null,
                  builder: (context, snapshot) {
                    if (controller.requests.value == null &&
                        controller.hasError.value == false) {
                      return const LetterRequestLoadingWidget();
                    } else if (controller.requests.value != null &&
                        controller.requests.value!.isNotEmpty) {
                      final requests = controller.filteredRequests;
                      if (requests.isEmpty) {
                        return const NoDataPage(
                          message: 'No letter requests found',
                        );
                      }
                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          appSize.size16.w,
                          0,
                          appSize.size16.w,
                          appSize.size90.h,
                        ),
                        itemCount: requests.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(height: appSize.size12.h),
                        itemBuilder: (context, index) {
                          return LetterRequestCard(request: requests[index]);
                        },
                      );
                    } else {
                      return const NoDataPage(
                        message: 'No letter requests found',
                      );
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
