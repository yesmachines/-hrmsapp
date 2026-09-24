import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yes_hrm/main.dart';
import 'package:yes_hrm/utils/app_bar/title_app_bar/title_app_bar.dart';
import 'package:yes_hrm/utils/loading_screen/loading_screen.dart';
import 'package:yes_hrm/utils/no_data_page/no_data_page.dart';
import 'package:yes_hrm/view/employee_screens/documents/letter_requests/letter_request_details/controller/controller.dart';
import 'package:yes_hrm/view/employee_screens/documents/letter_requests/service/model/letter_request_model.dart';

class LetterRequestDetailsView extends GetView<LetterRequestDetailsController> {
  const LetterRequestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffoldGreyColor,
      appBar: TitleAppBar(title: "Letter Request Details"),
      body: SafeArea(
        child: Obx(() {
          return FutureBuilder(
            future: controller.request.value == null
                ? controller.getLetterRequest()
                : null,
            builder: (context, snapshot) {
              final request = controller.request.value;
              if (request == null && controller.hasError.value == false) {
                return const Center(child: LoadingScreen());
              } else if (request != null) {
                return _LetterRequestDetailsBody(request: request);
              }
              return const NoDataPage(message: 'Letter request not found');
            },
          );
        }),
      ),
    );
  }
}

class _LetterRequestDetailsBody
    extends GetView<LetterRequestDetailsController> {
  const _LetterRequestDetailsBody({required this.request});

  final LetterRequestModel request;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        appSize.size16.w,
        appSize.size8.h,
        appSize.size16.w,
        appSize.size24.h,
      ),
      child: Column(
        children: [
          _DetailCard(label: 'LETTER TYPE', value: request.displayTitle),
          if (request.templateName.isNotEmpty) ...[
            SizedBox(height: appSize.size12.h),
            _DetailCard(label: 'TEMPLATE', value: request.templateName),
          ],
          if (request.purpose.isNotEmpty) ...[
            SizedBox(height: appSize.size12.h),
            _DetailCard(label: 'PURPOSE', value: request.purpose),
          ],
          if (request.details.isNotEmpty) ...[
            SizedBox(height: appSize.size12.h),
            _DetailCard(label: 'DETAILS', value: request.details),
          ],
          if (request.toAddress.isNotEmpty) ...[
            SizedBox(height: appSize.size12.h),
            _DetailCard(label: 'TO ADDRESS', value: request.toAddress),
          ],
          if (request.visaDesignation.isNotEmpty) ...[
            SizedBox(height: appSize.size12.h),
            _DetailCard(
              label: 'VISA DESIGNATION',
              value: request.visaDesignation,
            ),
          ],
          SizedBox(height: appSize.size12.h),
          Row(
            children: [
              if (request.applyDate.isNotEmpty)
                Expanded(
                  child: _DetailCard(
                    label: 'APPLIED DATE',
                    value: request.applyDate,
                  ),
                ),
              if (request.applyDate.isNotEmpty &&
                  request.displayStatus.isNotEmpty)
                SizedBox(width: appSize.size12.w),
              if (request.displayStatus.isNotEmpty)
                Expanded(
                  child: _DetailCard(
                    label: 'STATUS',
                    value: request.displayStatus,
                  ),
                ),
            ],
          ),
          if (request.approvedDate.isNotEmpty) ...[
            SizedBox(height: appSize.size12.h),
            _DetailCard(label: 'APPROVED DATE', value: request.approvedDate),
          ],
          if (request.fileUrl.isNotEmpty) ...[
            SizedBox(height: appSize.size16.h),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: controller.onViewFile,
                borderRadius: BorderRadius.circular(appSize.radius8),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: appSize.size12.w,
                    vertical: appSize.size8.h,
                  ),
                  decoration: BoxDecoration(
                    color: appColors.whiteColor,
                    borderRadius: BorderRadius.circular(appSize.radius8),
                    border: Border.all(color: appColors.brandColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: appSize.icon16,
                        color: appColors.brandColor,
                      ),
                      SizedBox(width: appSize.size4.w),
                      Text(
                        'View Letter',
                        style: fontStyles.font12Brand600.copyWith(
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(appSize.size14.w),
      decoration: BoxDecoration(
        color: appColors.whiteColor,
        borderRadius: BorderRadius.circular(appSize.radius12),
        border: Border.all(color: appColors.strokeColor.withValues(alpha: 0.8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: fontStyles.font10LightGrey500),
          SizedBox(height: appSize.size8.h),
          Text(value, style: fontStyles.font14Black600),
        ],
      ),
    );
  }
}
